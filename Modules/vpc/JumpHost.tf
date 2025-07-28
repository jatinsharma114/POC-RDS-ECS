resource "aws_instance" "jump" {
  ami           = "ami-020cba7c55df1f615" # Ubuntu 22.04 LTS us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_us-east-1a.id
  vpc_security_group_ids = [aws_security_group.jump_sg.id]
 
  associate_public_ip_address = true
  key_name = "TestKV"

  tags = { 
    Name = "jump-host" 
    }
}

resource "aws_security_group" "jump_sg" {
  name        = "jump-sg"
  description = "SSH from anywhere + MySQL to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # restrict to your IP in prod
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jump-sg"
  }

}
