terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
/*comando para criar bucket antes 
aws s3 mb s3://bucket-dede-tf
*/
#backend onde o arquivo terraform.tfstate sera armazenado
terraform {
  backend "s3" {
    bucket = "bucket-dede-tf"
    region = "us-east-1"
    key    = "terraform.tfstate"
  }
} 