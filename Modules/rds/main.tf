# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ➤ RDS Instance
resource "aws_db_instance" "myrds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  identifier             = "rdstf"
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  username               = var.rds_username
  password               = var.rds_password
  publicly_accessible    = "false" # no public IP assigned to this.! Not acesable outside the Internet 
  skip_final_snapshot = true  # 👈 Skip snapshot on deletion !! Also this {}{}
  multi_az = false  # Important: stick Single-AZ -->> for Free Tier

  db_subnet_group_name = aws_db_subnet_group.private_db_subnet.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "pocRDS"
  }
}

#  “Tell RDS which VPC subnets to live in.”
#  “Tell RDS who can talk to the DB.”
resource "aws_db_subnet_group" "private_db_subnet" {
  name       = "private-db-subnet-group"

  # Used by multi-AZ if - multi_az = true.
  subnet_ids = [
    var.private_subnet_us_east_1a_id,
    var.private_subnet_us_east_1b_id
  ]
  tags = {
    Name = "Private DB Subnet Group"
  }
}

# ➤ RDS Subnet Group
# Allowing the Traffic into this RDS only from the ECS inside the VPC. 
resource "aws_security_group" "rds_sg" {
  name        = "rds-ecs-only"
  description = "Allow RDS from ECS tasks only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ecs_service_sg_id] # <-- Allow traffic only FROM teh ECS!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}