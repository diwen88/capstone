# create launch template 
resource "aws_launch_template" "lt" {
  name                   = "${var.env}-lt"
  image_id               = var.ami_amz_l2
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  lifecycle {
    create_before_destroy = true
  }
}

# create autoscaling group 
resource "aws_autoscaling_group" "asg" {
  name                   = "${var.env}-asg"
  max_size               = 4
  min_size               = 2
  desired_capacity       = 2
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

# create autoscaling policy 
resource "aws_autoscaling_policy" "asg_policy" {
  name           = "${var.env}-asg-policy"
  policy_type    = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  estimated_instance_warmup = 180
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}