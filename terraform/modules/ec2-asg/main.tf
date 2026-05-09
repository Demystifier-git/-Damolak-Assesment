resource "aws_launch_template" "this" {
  name_prefix   = "app-lt-"
  image_id      = var.ec2_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(<<EOF
#!/bin/bash
echo "App starting..."
EOF
  )
}

resource "aws_autoscaling_group" "this" {
  name                = "app-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}