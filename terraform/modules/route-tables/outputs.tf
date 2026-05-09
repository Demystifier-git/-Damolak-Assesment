output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "public_route_table_association_ids" {
  value = [
    for assoc in aws_route_table_association.public_assoc :
    assoc.id
  ]
}

output "private_route_table_association_ids" {
  value = [
    for assoc in aws_route_table_association.private_assoc :
    assoc.id
  ]
}