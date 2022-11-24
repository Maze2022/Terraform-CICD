#---------compute/main.tf

data "aws_ami" "instance_ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"]
  }
}

# Launch Template
resource "aws_launch_template" "my_template" {
  name                   = "my_template"
  image_id               = data.aws_ami.instance_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.vpc_sg]
  key_name               = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wk24_asg" {
  name                = "wk24-asg"
  vpc_zone_identifier = var.public_subnets
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
}