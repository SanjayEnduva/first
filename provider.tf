terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "AKIA2V47Z6XOJZLEXCJF"
  secret_key = "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"
}