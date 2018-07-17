###
# terraform to spin up EKS cluster
###

# variable to hold cluster info
variable "cluster-name" {
  description = "Name of EKS Cluster"
  type = "string"
  default = "eks-example-cluster"
}

# AWS provider
provider "aws" {
  region = "us-east-1"
}

# -------------------------------------------------------
#  create IAM role associated with cluster
# -------------------------------------------------------

resource "aws_iam_role" "eks-example" {
  name = "terraform-eks-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-example.name}"
}

resource "aws_iam_role_policy_attachment" "eks-example-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks-example.name}"
}

# -------------------------------------------------------
# resource to create the actual EKS cluster
# -------------------------------------------------------

resource "aws_eks_cluster" "demo" {
  name            = "terraform-eks-demo"
  role_arn        = "${aws_iam_role.eks-example.arn}"

    vpc_config {
    subnet_ids = ["${module.vpc.public_subnets}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-example-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-example-AmazonEKSServicePolicy",
  ]
}

# --------------------------------------------------------------
# generate the required KUBECONFIG to connect to the EKS cluster
# --------------------------------------------------------------

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}



