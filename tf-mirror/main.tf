terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "null_resource" "test" {
}

data "aws_caller_identity" "current" {}

output "user_id" {
  value = data.aws_caller_identity.current.user_id
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}