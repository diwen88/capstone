# create asg 
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.env}-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 40
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.lc.name
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id]
  #target_group_arns         = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.env}-asg"
    propagate_at_launch = true
  }
}

# create launch configuration 
resource "aws_launch_configuration" "lc" {
  name          = "${var.env}-lc"
  image_id      = "XXXXXXXXXXXXXXXXXXXXX"
  instance_type = "${var.ec2_instance_type}"
  key_name     = var.key_name
  lifecycle {
    create_before_destroy = true
  }
  security_groups = [aws_security_group.public_sg.id]
}