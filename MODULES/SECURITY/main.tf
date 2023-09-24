resource "aws_security_group" "stack-sg" {
  vpc_id = var.vpc_id
  description = var.sg_description
  tags = merge(var.required_tags, {"Name" = var.sg_name} )

dynamic "ingress" {
  for_each = var.inbound_rules
  content {
    from_port   = ingress.value.port
    to_port     = ingress.value.port
    protocol    = ingress.value.protocol
    cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : []
    security_groups  = length(ingress.value.security_groups) > 0 ? ingress.value.security_groups : []
  }
}

dynamic "egress" {
  for_each = var.outbound_rules
  content {
    from_port   = egress.value.port
    to_port     = egress.value.port
    protocol    = egress.value.protocol
    cidr_blocks      = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : []
    security_groups  = length(egress.value.security_groups) > 0 ? egress.value.security_groups : []
  }
}
}