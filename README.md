# tf-helloworld

Follows [this tutorial](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180).

- tf-helloworld-singleserver (start here) : Use terraform to deploy a single EC2 instance

- tf-helloworld-cluster : Use terraform to deploy a cluster of EC2 instances, specifically:
  - an auto-scaling group of 2-10 EC2 instances
  - a load balancer to distribute traffic between the instances
  - health checks on the EC2 instances to only route traffic if a given instance is running and accepting incoming connections
  - regeneration of downed instances

--- 

### Quickstart

#### Prerequisites
- [install terraform](https://www.terraform.io/intro/getting-started/install.html)

- you must have your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY set as environment variables! Do:
  - `export AWS_ACCESS_KEY_ID=<your access key id>`
  - `export AWS_SECRET_ACCESS_KEY=<your secret access key>`
- `cd` into the desired project and run `tf init`
- run `tf plan` to see what terraform interprets and intends to deploy in AWS
- run `tf apply` to spin up the servers!
