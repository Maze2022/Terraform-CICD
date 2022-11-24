#--------networking/outputs.tf

output "public_subnets" {
  value = aws_subnet.luit_public_subnets.*.id
}

output "vpc_sg" {
    value = aws_security_group.vpc_sg.id
}