variable "ami" {}
variable "subnet_ids" {}
variable "EC2_DETAILS" {}
variable "EBS_DETAILS" {}

variable "required_tags" {}

variable "bootstrap_file" {}

variable "security_group" {
  type = string
}

variable "TG_DETAILS" {}
variable "ASG_DETAILS" {}
variable "ASG_SP" {}
variable "vpc_id" {}