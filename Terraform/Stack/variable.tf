variable "environment" {
  type = "string"
}

variable "db_username" {
  type = "string"
}

variable "db_password" {
  type = "string"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type    = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type    = "list"
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "db_subnets_cidr" {
  type    = "list"
  default = ["10.0.200.0/24", "10.0.201.0/24"]
}

variable "azs" {
  type    = "list"
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "ami" {
  type    = "string"
}


variable "instance_type" {
  type    = "string"
}

variable "db_instance" {
  type    = "string"
}

variable "storage_volume" {
  type    = "string"
}

variable "db_volume" {
  type    = "string"
}