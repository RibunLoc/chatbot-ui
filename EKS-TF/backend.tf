terraform {
  backend "s3" {
    bucket         = "terraform-cicd-chatbox-1206"
    region         = "ap-northeast-1"
    key            = "Chatbot-UI/EKS-TF/terraform.tfstate"
    dynamodb_table = "My-Dynamodb-1206"
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}
