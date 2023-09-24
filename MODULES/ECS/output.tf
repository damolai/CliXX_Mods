output "target_group_arn" {
  description = "Target Group arn"
  value       = aws_lb_target_group.stack-tg.arn
}

output "asg_id" {
  description = "Auto Scaling Goup ID"
  value       = aws_autoscaling_group.stack-asg.id
}

output "key_pair_name" {
  description = "Key Pair Name"
  value       = aws_key_pair.Stack_KP_mod.key_name
}

output "lb_dns_name" {
  description = "Load Balancer DNS name"
  value       = aws_lb.stack_nlb.dns_name
}

output "lb_zone_id" {
  description = "Load Balancer Zone ID"
  value       = aws_lb.stack_nlb.zone_id
}