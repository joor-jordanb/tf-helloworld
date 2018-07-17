# tf-eks-cluster
---
Use terraform to deploy an EKS cluster
--- 

### Quickstart

#### Prerequisites
- [install terraform](https://www.terraform.io/intro/getting-started/install.html)

- you must have your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY set as environment variables! Do:
  - `export AWS_ACCESS_KEY_ID=<your access key id>`
  - `export AWS_SECRET_ACCESS_KEY=<your secret access key>`
- you must grant the user above the following permissions:
  - IAM : [] <-- TODO: get specific roles (stuck on PassRole error, for some reason IAM is blocking)
  - EKS : [] <-- TODO: get specific roles
  - Quickstart : (not the best option) grant admin access to the IAM user
- `cd` into the desired project and run `tf init`
- run `tf plan` to see what terraform interprets and intends to deploy in AWS
- run `tf apply` to spin up the servers!
