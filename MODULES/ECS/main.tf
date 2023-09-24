resource "aws_key_pair" "Stack_KP_mod" {
  key_name   = var.EC2_DETAILS["key_name"]
  public_key = file(var.EC2_DETAILS["PATH_TO_PUBLIC_KEY"])
}


##Create Launch Template
resource "aws_launch_template" "stack-lt" {
  name_prefix   = var.EC2_DETAILS["LT_name_prefix"]
  description   = var.EC2_DETAILS["LT_description"]
  image_id      = var.ami
  user_data     = base64encode(var.bootstrap_file)
  instance_type = var.EC2_DETAILS["instance_type"]
  key_name      = aws_key_pair.Stack_KP_mod.key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

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

  #Monitoring using cloudwatch:
  monitoring {
    enabled = var.EC2_DETAILS["cloudwatch_monitoring_enabled"]
  }

  network_interfaces {
    associate_public_ip_address = var.EC2_DETAILS["associate_public_ip_address"]
    delete_on_termination       = var.EC2_DETAILS["delete_on_termination"]
    security_groups             = [var.security_group]
  }

  tags = merge(var.required_tags, {"Name" = var.EC2_DETAILS["LT_name_prefix"]} )
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

#Network Load Baancer
resource "aws_lb" "stack_nlb" {
  name               = var.NLB_DETAILS["name"]
  internal           = var.NLB_DETAILS["internal"]
  load_balancer_type = var.NLB_DETAILS["load_balancer_type"]
  enable_deletion_protection = var.NLB_DETAILS["enable_deletion_protection"]
  subnets            = var.lb_subnet_ids
  security_groups    = [var.LB_security_group]

  enable_cross_zone_load_balancing = var.NLB_DETAILS["enable_deletion_protection"]
}

resource "aws_lb_listener" "ecs_alb_listener" {
 load_balancer_arn = aws_lb.stack_nlb.arn
 port              = var.NLB_LS_DETAILS["port"]
 protocol          = var.NLB_LS_DETAILS["protocol"]

 default_action {
   type             = var.NLB_LS_DETAILS["default_action_type"]
   target_group_arn = aws_lb_target_group.stack-tg.arn
 }
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

#Create cluster
resource "aws_ecs_cluster" "ecs_cluster" {
 name = var.ecs_cluster_name
}

#Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
 family             = var.ECS_TD_DETAILS["family"]
 network_mode       = var.ECS_TD_DETAILS["network_mode"]
 execution_role_arn = var.ECS_TD_DETAILS["execution_role_arn"]
 task_role_arn      = var.ECS_TD_DETAILS["task_role_arn"]
 memory             = var.ECS_TD_DETAILS["task_memory"]
 cpu                = var.ECS_TD_DETAILS["tak_cpu"]
 requires_compatibilities = var.ECS_TD_DETAILS["requires_compatibilities"]
 container_definitions = jsonencode([
   {
     name      = var.ECS_TD_DETAILS["container_name"]
     image     = var.ECS_TD_DETAILS["image"]
     cpu       = var.ECS_TD_DETAILS["cont_cpu"]
     memory    = var.ECS_TD_DETAILS["cont_memory_hard_limit"]
     memoryReservation = var.ECS_TD_DETAILS["cont_memory_soft_limit"]
     essential = var.ECS_TD_DETAILS["essential"]
     portMappings = [
       {
         containerPort = var.ECS_TD_DETAILS["containerPort"]
         hostPort      = var.ECS_TD_DETAILS["hostPort"]
         protocol      = var.ECS_TD_DETAILS["protocol"]
       }
     ]
   }
 ])
}

#ECS Service
resource "aws_ecs_service" "ecs_service" {
 name            = var.ECS_SERVICE_DETAILS["name"]
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.ecs_task_definition.arn
 desired_count   = var.ECS_SERVICE_DETAILS["desired_count"]

 force_new_deployment = var.ECS_SERVICE_DETAILS["force_new_deployment"]
 placement_constraints {
   type = var.ECS_SERVICE_DETAILS["placement_constraints_type"]
 }

 triggers = {
   redeployment = timestamp()
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.stack-tg.arn
   container_name   = var.ECS_SERVICE_DETAILS["container_name"]
   container_port   = var.ECS_SERVICE_DETAILS["container_port"]
 }

 depends_on = [aws_autoscaling_group.stack-asg]
}