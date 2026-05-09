resource "aws_docdb_subnet_group" "this" {
  name       = "docdb-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "docdb_sg" {
  name   = "docdb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [var.allowed_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier      = "app-docdb"
  engine                  = "docdb"

  master_username         = var.master_username
  master_password         = var.master_password

  db_subnet_group_name    = aws_docdb_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.docdb_sg.id]

  skip_final_snapshot     = true
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count

  identifier         = "app-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class
}