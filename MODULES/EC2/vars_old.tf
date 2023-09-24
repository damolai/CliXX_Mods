# variable "AWS_REGION" {
#   default = "us-east-1"
# }
# variable "server" {
#   default="serv"
# }
# variable "ami" {}

# variable "vpc_id" {}

# variable "availability_zone" {
#   default = "us-east-1c"
# }
# variable "instance_type" {
#   default = "t2.micro"
# }
# # variable "PATH_TO_PUBLIC_KEY" {}

# variable "subnet_ids" {}

# #Tags
# # variable "environment" {}
# # variable "OwnerEmail" {}
# # variable "Session" {}
# # variable "Subsystem" {}
# # variable "Backup" {}
# # variable "Organization" {}

# # variable "AMIS"{
# #   type = map(string)
# #   default = {
# #       us-east-1 = "ami-08f3d892de259504d"
# #       us-east-2 = "ami-06b94666"
# #       us-west-1 = "ami-844e0bf7"
# #   }
# # }

# # variable "email_addresses"{
# #   default = [
# #       "damola.iyiola1@gmail.com",
# #       "stackcloud10@mkitconsulting.net"
# #   ]
# # }
# variable "availability_zones_list" {
#   default = [
#     "us-east-1a", 
#     "us-east-1b", 
#     "us-east-1c", 
#     "us-east-1d", 
#     "us-east-1e", 
#     "us-east-1f"
#   ]
# }
# variable "wp_path"{
#   default = "/var/www/html/wp-config.php"
# }
# variable "web_path"{
#   default = "/var/www/html"
# }
# variable "mount_point"{
#   default = "/var/www/html"
# }
# variable "git_clone"{
#   default = "https://github.com/stackitgit/CliXX_Retail_Repository.git"
# }

# variable "EC2_DETAILS" {}
# variable "EBS_DETAILS" {}

# variable "required_tags" {}

# variable "bootstrap_file" {}

# variable "security_group" {
#   type = string
# }

# #Target Group Variables:
# # variable "target_group_name" {}
# # variable "tg_port" {}
# # variable "tg_protocol" {}
# variable "TG_DETAILS" {}

# #ASG Variables:
# # variable "desired_capacity" {}
# # variable "min_size" {}
# # variable "max_size" {}
# # variable "default_cooldown" {}
# # variable "health_check_grace_period" {}

# variable "ASG_DETAILS" {}
# variable "ASG_SP" {}