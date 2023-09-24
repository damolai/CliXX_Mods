output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = { for subs in aws_subnet.subnets : subs.tags["Name"] => subs.id }
}