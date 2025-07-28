output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_us-east-1a_id" {
  value = aws_subnet.public_subnet_us-east-1a.id
}

output "private_subnet_us_east_1a_id" {
  value = aws_subnet.private_subnet_us-east-1a.id
}

output "public_subnet_us-east-1b_id" {
  value = aws_subnet.public_subnet_us-east-1b.id
}

output "private_subnet_us_east_1b_id" {
  value = aws_subnet.private_subnet_us-east-1b.id
}