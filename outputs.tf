output "matillion_instance_id" {
  value       = aws_instance.this.id
  description = "Matillion instance id"
}

output "matillion_lb_dns_name" {
  value       = aws_alb.this.id
  description = "Matillion DNS name"
}
