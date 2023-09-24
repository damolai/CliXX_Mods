resource "aws_subnet" "subnets" {
  for_each = { for subnet in var.subnets : "${subnet.cidr}-${subnet.az}" => subnet }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  
  tags = merge(var.required_tags, {"Name" = each.value.name} )
}