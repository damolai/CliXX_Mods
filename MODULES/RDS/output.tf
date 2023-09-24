output "rds_instance_endpoint" {
  description = "RDS Instance Endpoint"
  value       = split(":", aws_db_instance.restore-rds.endpoint)[0]
}