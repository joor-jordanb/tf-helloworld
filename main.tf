provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jordan_example" {
  ami = ""
  instance_type = "t2.micro"
}

tags {
  Name = "terraform-example"
}
