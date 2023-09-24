variable "ami" {}
variable "subnet_ids" {}
variable "lb_subnet_ids" {}
variable "EC2_DETAILS" {}
variable "EBS_DETAILS" {}

variable "required_tags" {}

variable "bootstrap_file" {}

variable "security_group" {
  type = string
}
variable "LB_security_group" {
  type = string
}
variable "TG_DETAILS" {}
variable "ASG_DETAILS" {}
variable "ASG_SP" {}
variable "vpc_id" {}
variable "NLB_DETAILS" {}
variable "NLB_LS_DETAILS" {}
variable "ecs_cluster_name" {}
variable "ECS_TD_DETAILS" {}
variable "ECS_SERVICE_DETAILS" {}
variable "iam_instance_profile_name" {}