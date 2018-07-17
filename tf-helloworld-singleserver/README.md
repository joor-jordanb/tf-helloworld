# tf-helloworld-singleserver

Follows [this tutorial](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180).

Use terraform to deploy a single EC2 instance.

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

---

So you want to learn how to user terraform to create and manage infrastructure with code? This is the place to start-- diagram time! Below shows (more or less) how you can use a simple `main.tf` file to spin up a simple EC2 server. The code in this repo simply loops for http requests and responds with a simple "Hello world!" message. You can use the `outputs` of the `main.tf` file to grab the public IP of the EC2 instance. 
![terraform single ec2 instance](https://user-images.githubusercontent.com/41012778/42830670-221084de-89ba-11e8-9d7d-902675d626ee.png "Terraform Single EC2 instance")

--- 
