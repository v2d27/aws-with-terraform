# create public security group for VPC1
resource "aws_security_group" "VPC1-SG-Public" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC1.id
    name = "VPC1-SG-Public"
    description = "config icmp-ipv4, ssh and other vpcs"

    ingress {
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    ingress {
        description = "ICMP - IPv4 from anywhere"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    ingress {
        description = "All traffic from VPCs"
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
        Name = "VPC1-SG-Public"
    }
}

# create private security group for VPC2
resource "aws_security_group" "VPC2-SG-Private" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    name = "VPC2-SG-Private"
    description = "config https for SessionManager, all traffic from on-premises"

    ingress {
        description = "Allow all traffic from all VPCs 10.0.0.0/8"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_allvpc]
    }

    ingress {
        description = "Allow all traffic from on-premises vpn"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_onpremise]
    }

    egress {
        description = "Outbound rule for SessionManager"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_anywhere]
    } # => you can remove it if allowing all outbound rule
    
    egress {
        description = "Allow all connection to outside"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_anywhere]
    } # => allow other protocols in this lab, not only SessionManager

    tags = {
        Name = "VPC2-SG-Private"
    }
}


# create security group for VPC2-Endpoint interface
resource "aws_security_group" "VPC2-Endpoint" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    name = "VPC2-Endpoint"
    description = "Allow HTTPS from anywhere"

    ingress {
        description = "Allow HTTPS from anywhere"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    egress {
        description = "Allow all connection to outside"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    tags = {
        Name = "VPC2-Endpoint"
    }
}


# create public security group for VPC3
resource "aws_security_group" "VPC3-SG-Public" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC3.id
    name = "VPC3-SG-Public"
    description = "Allow all traffic from VPC4, ping and ssh from anywhere"

    ingress {
        description = "Allow all traffic from VPC4"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_vpc4]
    }

    ingress {
        description = "Allow SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    ingress {
        description = "Allow ICMP - IPv4 from anywhere"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    egress {
        description = "Allow all connection to outside"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.cidr_block_anywhere]
    }

    tags = {
        Name = "VPC3-SG-Public"
    }
}








