# create private security group for VPC4
resource "aws_security_group" "VPC4-SG-Private" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC4.id
    name = "VPC4-SG-Private"
    description = "Allow all traffic from singapore-VPC3"

    ingress {
        description = "Allow all traffic from singapore-VPC3"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_vpc3]
    }

    egress {
        description = "Allow all connection to outside"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_anywhere]
    }
    
    tags = {
        Name = "VPC4-SG-Private"
    }
}


# create private security group for VPC5
resource "aws_security_group" "VPC5-SG-Private" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC5.id
    name = "VPC5-SG-Private"
    description = "Allow all traffic from all VPCs and on-premise"

    ingress {
        description = "Allow all traffic from on-premise"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_onpremise]
    }

    ingress {
        description = "Allow all traffic from all VPCs"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_allvpc]
    }

    egress {
        description = "Allow all connection to outside"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    tags = {
        Name = "VPC5-SG-Private"
    }
}


# create public security group for VPC6
resource "aws_security_group" "VPC6-SG-Public" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC6.id
    name = "VPC6-SG-Public"
    description = "Allow inbound ICMP-IPv4, SSH traffic from anywhere"

    ingress {
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    ingress {
        description = "ICMP (IPv4) from anywhere"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    ingress {
        description = "Allow all traffic from all VPCs"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_allvpc]
    }

    egress {
        description = "Allow all connection to outside"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    tags = {
        Name = "VPC6-SG-Public"
    }
}
