output "vpc1_instance_public" {
    description = "The public IP address of the vpc1_instance"
    value = aws_instance.vpc1_instance.public_ip
}

output "vpc1_instance_private" {
    description = "The private IP address of the vpc1_instance"
    value = aws_instance.vpc1_instance.private_ip
}

output "vpc2_instance_private" {
    description = "The private IP address of the vpc2_instance"
    value = aws_instance.vpc2_instance.private_ip
}

output "vpc3_instance_private" {
    description = "The private IP address of the vpc3_instance"
    value = aws_instance.vpc3_instance.private_ip
}

output "vpc3_instance_public" {
    description = "The public IP address of the vpc3_instance"
    value = aws_instance.vpc3_instance.public_ip
}

output "vpc4_instance_private" {
    description = "The private IP address of the vpc4_instance"
    value = aws_instance.vpc4_instance.private_ip
}

output "vpc5_instance_private" {
    description = "The private IP address of the vpc5_instance"
    value = aws_instance.vpc5_instance.private_ip
}

output "vpc6_instance_private" {
    description = "The private IP address of the vpc6_instance"
    value = aws_instance.vpc6_instance.private_ip
}

output "on_premise_public_ip" {
    description = "The public IP address of on_premise server"
    value = aws_eip.on_premise.public_ip
}

output "tunnel1_public_ip" {
    description = "The public ip of tunnel 1 on AWS side for vpn connection"
    value = aws_vpn_connection.transit_vpn.tunnel1_address
}

output "tunnel2_public_ip" {
    description = "The public ip of tunnel 2 on AWS side for vpn connection"
    value = aws_vpn_connection.transit_vpn.tunnel2_address
}


