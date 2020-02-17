#ELB does not give out a public address, only DNS names (from my experience it's only possible in the new alb)
output "elb-dns-name" {
  description = "The DNS name of the ELB"
  value       = aws_elb.bs-elb.dns_name
}

output "db_username" {
  description = "MySQL username"
  value       = var.db_username
}

output "db_password" {
  description = "MySQL password"
  value       = var.db_password
}

output "instance_address" {
  value       = aws_db_instance.bs_mysql.*.address
  description = "Address of the instance"
}

output "instance_endpoint" {
  value       = aws_db_instance.bs_mysql.*.endpoint
  description = "DNS Endpoint of the instance"
}