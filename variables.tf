variable "cidr_subnet" {
  type    = list(string)
  //default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "zones" {
  type    = list(string)
  //default = ["us-east-1a", "us-east-1b"]
}

variable "instance-type" {
  //default = "t2.micro"
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

