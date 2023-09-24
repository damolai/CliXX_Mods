locals {
#  Server_Prefix = "CliXX-"
  # Server_Prefix=""
}

resource "aws_key_pair" "Stack_KP_mod" {
  key_name   = var.EC2_DETAILS["key_name"]
  public_key = file(var.EC2_DETAILS["PATH_TO_PUBLIC_KEY"])
}

#Create Target Group
resource "aws_lb_target_group" "stack-tg" {
  name     = var.TG_DETAILS["target_group_name"]
  port     = var.TG_DETAILS["tg_port"]
  protocol = var.TG_DETAILS["tg_protocol"]
  vpc_id   = var.vpc_id
  deregistration_delay = var.TG_DETAILS["deregistration_delay"]

  health_check {
    enabled             = var.TG_DETAILS["enabled"]
    interval            = var.TG_DETAILS["interval"]
    path                = var.TG_DETAILS["path"]
    port                = var.TG_DETAILS["port"]
    timeout             = var.TG_DETAILS["timeout"]
    healthy_threshold   = var.TG_DETAILS["healthy_threshold"]
    unhealthy_threshold = var.TG_DETAILS["unhealthy_threshold"]
    matcher             = var.TG_DETAILS["matcher"]
  }
}

##Create Launch Template
resource "aws_launch_template" "stack-lt" {
  name_prefix   = var.EC2_DETAILS["LT_name_prefix"]
  description   = var.EC2_DETAILS["LT_description"]

  dynamic "block_device_mappings" {
    for_each = var.EBS_DETAILS
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = block_device_mappings.value.delete_on_termination
      }
    }
  }

  ebs_optimized = var.EC2_DETAILS["ebs_optimized"]

  instance_type = var.EC2_DETAILS["instance_type"]
  key_name      = aws_key_pair.Stack_KP_mod.key_name
  #Monitoring using cloudwatch:
  monitoring {
    enabled = var.EC2_DETAILS["cloudwatch_monitoring_enabled"]
  }

  network_interfaces {
    associate_public_ip_address = var.EC2_DETAILS["associate_public_ip_address"]
    delete_on_termination       = var.EC2_DETAILS["delete_on_termination"]
    security_groups             = [var.security_group]
  }

  image_id      = var.ami
  user_data     = base64encode(var.bootstrap_file)


  tags = merge(var.required_tags, {"Name" = "Stack-App-Server-LT-Mod"} )
}

#Creating Auto Scaling Group
resource "aws_autoscaling_group" "stack-asg" {
  name                 = var.ASG_DETAILS["asg_name"]
  desired_capacity     = var.ASG_DETAILS["desired_capacity"]
  min_size             = var.ASG_DETAILS["min_size"]
  max_size             = var.ASG_DETAILS["max_size"]
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns = [aws_lb_target_group.stack-tg.arn]
  default_cooldown     = var.ASG_DETAILS["default_cooldown"]
  health_check_type         = var.ASG_DETAILS["health_check_type"]
  health_check_grace_period = var.ASG_DETAILS["health_check_grace_period"]
  
  launch_template {
    id      = aws_launch_template.stack-lt.id
    version = var.ASG_DETAILS["LT_version"]
  }

  dynamic "tag" {
    for_each = var.required_tags
    content{
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = var.ASG_DETAILS["instance_name"]
    propagate_at_launch = true
  }
 
}

# Attaching autoscaling scaling policy
resource "aws_autoscaling_policy" "stack-asg-policy" {
  name                   = var.ASG_SP["name"]
  policy_type            = var.ASG_SP["policy_type"]
  autoscaling_group_name = aws_autoscaling_group.stack-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.ASG_SP["predefined_metric_type"]
    }
    target_value         = var.ASG_SP["pmt_target_value"]
    disable_scale_in     = var.ASG_SP["pmt_disable_scale_in"]
  }
}