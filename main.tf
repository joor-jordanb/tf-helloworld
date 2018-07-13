# variable to hold port information
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

# configure AWS provider and region
provider "aws" {
  region = "us-east-1"
}

# configure EC2 instance details
resource "aws_instance" "example" {
  ami = "ami-2d39803a"
  instance_type = "t2.micro"

  # testing simple server for now
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  # specify which security group to use
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  # provide a nametag
  tags {
    Name = "terraform-jordan1"
  }
}

# specify a security group to use with the EC2 instance
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# specify an output to get the EC2 IP
output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}

