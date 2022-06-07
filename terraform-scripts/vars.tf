variable "MYIP" {
  default = "183.82.176.27/32"
}
variable "VPC_NAME" {
  default = "VPC_NEW"
}
variable "VPC_CIDR" {
  default = "172.30.0.0/16"
}
variable "PRIV1_CIDR" {
  default = "172.30.1.0/24"
}
variable "PRIV2_CIDR" {
  default = "172.30.2.0/24"
}
variable "PRIV3_CIDR" {
  default = "172.30.3.0/24"
}
variable "PUB1_CIDR" {
  default = "172.30.4.0/24"
}
variable "PUB2_CIDR" {
  default = "172.30.5.0/24"
}
variable "PUB3_CIDR" {
  default = "172.30.6.0/24"
}
variable "rmquser" {
  default = "rabbit"
}
variable "rmqpass" {
  default = "Manypass@3098"
}
variable "dbname" {
  default = "accounts"
}
variable "dbuser" {
  default = "admin"
}
variable "dbpass" {
  default = "admin123"
}
variable "private_key" {
  default = "project_key"
}
variable "public_key" {
  default = "project_key.pub"
}
variable "user" {
  default = "ubuntu"
}
variable "instance_count" {
  default = "1"
}
variable "ZONE1" {
  default = "us-east-1a"
}
variable "ZONE2" {
  default = "us-east-1b"
}
variable "ZONE3" {
  default = "us-east-1c"
}
variable "region" {
  default = "us-east-1"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-09d56f8956ab235b3"
    us-east-2 = "ami-08d56f8956ab235b2"
    us-east-3 = "ami-07d56f89776ab2353"
  }
}