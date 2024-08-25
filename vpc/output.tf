output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"]
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
