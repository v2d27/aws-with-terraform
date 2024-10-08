###########################################################################################################
# Transit Gateway
###########################################################################################################
resource "aws_ec2_transit_gateway" "my-tgw-1" {
    provider = aws.region_singapore
    description = "my-tgw-1"

    # use default transit gateway route table 
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    tags = {
        Name = "my-tgw-1"
    }
}

# ----------------------------------------------------------------------------------------------------------
# Transit Gateway for VPC1
# ----------------------------------------------------------------------------------------------------------
# create attachment for vpc1
resource "aws_ec2_transit_gateway_vpc_attachment" "TGW-Attach-VPC1" {
    provider = aws.region_singapore
    subnet_ids = [aws_subnet.VPC1-Subnet-Public.id]
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
    vpc_id = aws_vpc.VPC1.id
    tags = {
        "Name" = "transit gateway attachment vpc1"
    }
}

# update route table for vpc1
resource "aws_route" "VPC1-Route" {
    provider = aws.region_singapore
    route_table_id = aws_route_table.VPC1-RT-Public.id
    destination_cidr_block = var.cidr_block_allvpc
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
}


# ----------------------------------------------------------------------------------------------------------
# Transit Gateway for VPC2
# ----------------------------------------------------------------------------------------------------------
# create attachment for vpc2
resource "aws_ec2_transit_gateway_vpc_attachment" "TGW-Attach-VPC2" {
    provider = aws.region_singapore
    subnet_ids = [aws_subnet.VPC2-Subnet-Private.id]
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
    vpc_id = aws_vpc.VPC2.id
    tags = {
        "Name" = "transit gateway attachment vpc2"
    }
}

# update route table for vpc2
resource "aws_route" "VPC2-Route" {
    provider = aws.region_singapore
    route_table_id = aws_route_table.VPC2-RT-Private.id
    destination_cidr_block = var.cidr_block_allvpc
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
}