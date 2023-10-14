data "aws_ssm_parameter" "docdb_username" {
  name = "roboshop.${var.env}.docdb.username"
}

data "aws_ssm_parameter" "docdb_password" {
  name = "roboshop.${var.env}.docdb.password"
}