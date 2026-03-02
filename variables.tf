variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  type = map(string)
  default = {}
}

variable "igw_tags" {
  type = map(string)
  default = {}
}

variable "public_subnet_cidr" {
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24" ]
}

variable "private_subnet_cidr" {
  type = list(string)
  default = [ "10.0.11.0/24","10.0.12.0/24" ]
}

variable "database_subnet_cidr" {
  type = list(string)
  default = [ "10.0.21.0/24","10.0.22.0/24" ]
}
variable "subnet_tags" {
  type = map(string)
  default = {}
}

variable "public_route_table_tags" {
  type = map(string)
  default = {}
}

variable "private_route_table_tags" {
  type = map(string)
  default = {}
}

variable "database_route_table_tags" {
  type = map(string)
  default = {}
}

variable "nat_route_table_tags" {
  type = map(string)
  default = {}
}