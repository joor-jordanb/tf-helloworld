# tf-helloworld-singleserver

Follows [this tutorial](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180).

Use terraform to deploy a single EC2 instance

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
