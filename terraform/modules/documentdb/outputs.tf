output "cluster_endpoint" {
  value = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_docdb_cluster.this.reader_endpoint
}

output "security_group_id" {
  value = aws_security_group.docdb_sg.id
}