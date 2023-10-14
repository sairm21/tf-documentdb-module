resource "aws_docdb_subnet_group" "doc_db" {
  name       = "${var.component}-${var.env}-cluster-subent-group"
  subnet_ids = var.subnet_ids

  tags = merge({ Name = "${var.env}-${var.component}-subnet-group" }, var.tags)
}

resource "aws_security_group" "docdb_sg" {
  name        = "${var.component}-${var.env}-SG"
  description = "Allow ${var.component}-${var.env}-Traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic for ${var.component}-${var.env}"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.sg_subnet_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.env}-${var.component}-SG"
  },
    var.tags)
}

resource "aws_docdb_cluster" "doc_db" {
  cluster_identifier      = "${var.component}-${var.env}-docdb-cluster"
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = data.aws_ssm_parameter.docdb_username
  master_password         = data.aws_ssm_parameter.docdb_password

  db_subnet_group_name = aws_docdb_subnet_group.doc_db.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  kms_key_id = var.kms_key_id

  skip_final_snapshot     = true
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.db_instance_count
  identifier         = "${var.component}-${var.env}-docdb-cluster-${count.index}"
  cluster_identifier = aws_docdb_cluster.doc_db.id
  instance_class     = var.db_instance_class
}