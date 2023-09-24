variable "vpc_id" {}
variable "required_tags" {}
variable "sg_name" {}
# variable "inbound_rules"{}
# variable "outbound_rules" {}
variable "sg_description" {
   type        = string
}

variable "inbound_rules" {
  description = "List of inbound rules with ports, protocols and CIDR blocks/security groups"
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
}

variable "outbound_rules" {
  description = "List of outbound rules with ports, protocols and CIDR blocks/security groups"
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
}