# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ➤ AWS SECRET MANAGER 
# Note :::: Problem: an earlier secret named poc-rds-creds was deleted but is still in the 7-day recovery window, so the name is reserved.
resource "aws_secretsmanager_secret" "rds_creds" {
  name        = "poc-rds-creds-v4"
  description = "MySQL credentials for pocRDS"
  tags = {
    Environment = "poc"
  }
}

resource "aws_secretsmanager_secret_version" "rds_creds" {
  secret_id = aws_secretsmanager_secret.rds_creds.id
  secret_string = jsonencode({
    username = var.rds_username
    password = var.rds_password
    engine   = var.rds_engine
    host     = aws_db_instance.myrds.endpoint
    port     = 3306
    dbname   = "demodb"
  })
}

output "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret that stimageores RDS credentials"
  value       = aws_secretsmanager_secret.rds_creds.arn
}