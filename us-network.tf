###########################################################################################################
# VPC4: 
###########################################################################################################
resource "aws_vpc" "VPC4" {
    provider = aws.region_virginia
    cidr_block = var.cidr_block_vpc4
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "VPC4"
    }
}

# Create a private subnet
resource "aws_subnet" "VPC4-Subnet-Private" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC4.id
    cidr_block = var.subnet_private_vpc4
    map_public_ip_on_launch = false
    availability_zone = "${var.region_virginia}a"
    tags = {
        Name = "VPC4-Subnet-Private"
    }
}

# Route Table
resource "aws_route_table" "VPC4-RT-Private" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC4.id

    tags = {
        Name = "VPC4-RT-Private"
    }
}

# Associate Route Table
resource "aws_route_table_association" "VPC4-Private-Associate" {
    provider = aws.region_virginia
    subnet_id = aws_subnet.VPC4-Subnet-Private.id
    route_table_id = aws_route_table.VPC4-RT-Private.id
}




###########################################################################################################
# VPC5: 
###########################################################################################################
resource "aws_vpc" "VPC5" {
    provider = aws.region_virginia
    cidr_block = var.cidr_block_vpc5
    tags = {
        Name = "VPC5"
    }
}

# Create a private subnet
resource "aws_subnet" "VPC5-Subnet-Private" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC5.id
    cidr_block = var.subnet_private_vpc5
    map_public_ip_on_launch = false
    availability_zone = "${var.region_virginia}a"
    tags = {
        Name = "VPC5-Subnet-Private"
    }
}

# Route Table
resource "aws_route_table" "VPC5-RT-Private" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC5.id

    tags = {
        Name = "VPC5-RT-Private"
    }
}

# Associate Route Table
resource "aws_route_table_association" "VPC5-Private-Associate" {
    provider = aws.region_virginia
    subnet_id = aws_subnet.VPC5-Subnet-Private.id
    route_table_id = aws_route_table.VPC5-RT-Private.id
}


###########################################################################################################
# VPC6: 
###########################################################################################################
resource "aws_vpc" "VPC6" {
    provider = aws.region_virginia
    cidr_block = var.cidr_block_onpremise
    tags = {
        Name = "VPC6"
    }
}

# Create a public subnet
resource "aws_subnet" "VPC6-Subnet-Public" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC6.id
    cidr_block = var.subnet_public_vpc6
    map_public_ip_on_launch = true
    availability_zone = "${var.region_virginia}a"
    tags = {
        Name = "VPC6-Subnet-Public"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "VPC6-IGW" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC6.id
}

# Route Table
resource "aws_route_table" "VPC6-RT-Public" {
    provider = aws.region_virginia
    vpc_id = aws_vpc.VPC6.id

    route {
        cidr_block = var.cidr_block_anywhere
        gateway_id = aws_internet_gateway.VPC6-IGW.id
    }

    tags = {
        Name = "VPC6-RT-Public"
    }
}

# Associate subnet to route table
resource "aws_route_table_association" "VPC6-Public-Associate" {
    provider = aws.region_virginia
    subnet_id = aws_subnet.VPC6-Subnet-Public.id
    route_table_id = aws_route_table.VPC6-RT-Public.id
}


