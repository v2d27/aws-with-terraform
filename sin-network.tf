###########################################################################################################
# VPC1: 
###########################################################################################################
resource "aws_vpc" "VPC1" {
    provider = aws.region_singapore
    cidr_block = var.cidr_block_vpc1
    tags = {
        Name = "VPC1"
    }
}

# Create a public subnet
resource "aws_subnet" "VPC1-Subnet-Public" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC1.id
    cidr_block = var.subnet_public_vpc1
    map_public_ip_on_launch = true
    availability_zone = "${var.region_singapore}a"
    tags = {
        Name = "VPC1-Subnet-Public"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "VPC1-IGW" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC1.id
}

# Route Table
resource "aws_route_table" "VPC1-RT-Public" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC1.id

    route {
        cidr_block = var.cidr_block_anywhere
        gateway_id = aws_internet_gateway.VPC1-IGW.id
    }

    tags = {
        Name = "VPC1-RT-Public"
    }
}

# Associate Route Table
resource "aws_route_table_association" "VPC1-Public-Associate" {
    provider = aws.region_singapore
    subnet_id = aws_subnet.VPC1-Subnet-Public.id
    route_table_id = aws_route_table.VPC1-RT-Public.id
}


###########################################################################################################
# VPC2: 
###########################################################################################################
resource "aws_vpc" "VPC2" {
    provider = aws.region_singapore
    cidr_block = var.cidr_block_vpc2
    enable_dns_hostnames = true # enable dns hostnames for SessionManager connection
    tags = {
        Name = "VPC2"
    }
}

# Create a private subnet
resource "aws_subnet" "VPC2-Subnet-Private" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    cidr_block = var.subnet_private_vpc2
    map_public_ip_on_launch = false
    availability_zone = "${var.region_singapore}a"

    tags = {
        Name = "VPC2-Subnet-Private"
    }
}

# Route Table
resource "aws_route_table" "VPC2-RT-Private" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id

    tags = {
        Name = "VPC2-RT-Private"
    }
}

# Associate Route Table
resource "aws_route_table_association" "VPC2-Private-Associate" {
    provider = aws.region_singapore
    subnet_id = aws_subnet.VPC2-Subnet-Private.id
    route_table_id = aws_route_table.VPC2-RT-Private.id
}

# Create VPC Endpoint Interface for Session Manager
resource "aws_vpc_endpoint" "ssm" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    vpc_endpoint_type = "Interface"
    service_name = "com.amazonaws.${var.region_singapore}.ssm"
    subnet_ids = [aws_subnet.VPC2-Subnet-Private.id]
    security_group_ids = [aws_security_group.VPC2-Endpoint.id]
    private_dns_enabled = true

    policy = jsonencode(
        {
            "Statement": [
                {
                "Effect": "Allow",
                "Principal": "*",
                "Action": "ssm:*",
                "Resource": "*"
                }
            ]
        }
    )
}

# Create VPC Endpoint Interface for Session Manager
resource "aws_vpc_endpoint" "ssmmessages" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    vpc_endpoint_type = "Interface"
    service_name = "com.amazonaws.${var.region_singapore}.ssmmessages"
    subnet_ids = [aws_subnet.VPC2-Subnet-Private.id]
    security_group_ids = [aws_security_group.VPC2-Endpoint.id]
    private_dns_enabled = true
}

# Create VPC Endpoint Interface for Session Manager
resource "aws_vpc_endpoint" "ec2messages" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    vpc_endpoint_type = "Interface"
    service_name = "com.amazonaws.${var.region_singapore}.ec2messages"
    subnet_ids = [aws_subnet.VPC2-Subnet-Private.id]
    security_group_ids = [aws_security_group.VPC2-Endpoint.id]
    private_dns_enabled = true
}

# Create VPC Endpoint Gateway for S3 bucket
resource "aws_vpc_endpoint" "s3" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC2.id
    vpc_endpoint_type = "Gateway"
    service_name = "com.amazonaws.${var.region_singapore}.s3"
    route_table_ids = [aws_route_table.VPC2-RT-Private.id] 
}


###########################################################################################################
# VPC3: 
###########################################################################################################
resource "aws_vpc" "VPC3" {
    provider = aws.region_singapore
    cidr_block = var.cidr_block_vpc3
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "VPC3"
    }
}

# Create a public subnet
resource "aws_subnet" "VPC3-Subnet-Public" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC3.id
    cidr_block = var.subnet_public_vpc3
    map_public_ip_on_launch = true
    availability_zone = "${var.region_singapore}a"
    tags = {
        Name = "VPC3-Subnet-Public"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "VPC3-IGW" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC3.id
}

# Route Table
resource "aws_route_table" "VPC3-RT-Public" {
    provider = aws.region_singapore
    vpc_id = aws_vpc.VPC3.id

    route {
        cidr_block = var.cidr_block_anywhere
        gateway_id = aws_internet_gateway.VPC3-IGW.id
    }

    tags = {
        Name = "VPC3-RT-Public"
    }
}

# Associate Route Table
resource "aws_route_table_association" "VPC3-Public-Associate" {
    provider = aws.region_singapore
    subnet_id = aws_subnet.VPC3-Subnet-Public.id
    route_table_id = aws_route_table.VPC3-RT-Public.id
}





