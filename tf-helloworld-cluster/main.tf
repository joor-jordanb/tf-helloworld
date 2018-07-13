# variable to hold port information
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

# configure AWS provider and region
provider "aws" {
  region = "us-east-1"
}

# specify the AWS launch configuration
resource "aws_launch_configuration" "example" {
  image_id = "ami-2d39803a"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  # ensure replacement exists before destroying
  lifecycle {
    create_before_destroy = true
  }
}

# specify a security group to use with the EC2 instance
resource "aws_security_group" "instance" {
  name = "terraform-asg-example-instance"
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # keeping consistent with launch config
  lifecycle {
    create_before_destroy = true
  }
}

# dynamic data source to get availability zones
data "aws_availability_zones" "all" {}

# create the auto-scaling group (ASG)
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  
  # load the availability zones from dynamic data
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 10

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# we need a load balancer to dist traffic
resource "aws_elb" "example" {
  name = "terraform-asg-example"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  
  # reroute traffic if a node goes down!
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

# security group for load balancer
resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# specify an output to get the EC2 IP
output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}

