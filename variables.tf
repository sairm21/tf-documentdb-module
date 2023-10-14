variable "component" {}
variable "env" {}
variable "engine" {}
variable "engine_version" {}
variable "subnet_ids" {}
variable "tags" {}
variable "kms_key_id" {}
variable "vpc_id" {}
variable "sg_subnet_cidr" {}
variable "port" {
  default = 27017
}
variable "db_instance_count" {}
variable "db_instance_class" {}
