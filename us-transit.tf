###########################################################################################################
# Transit Gateway
###########################################################################################################
resource "aws_ec2_transit_gateway" "my-tgw-2" {
    provider = aws.region_virginia
    description = "my-tgw-2"
    default_route_table_association = "enable"
    default_route_table_propagation = "enable"
    tags = {
        Name = "my-tgw-2"
    }
}


# ----------------------------------------------------------------------------------------------------------
# Transit Gateway for VPC5
# ----------------------------------------------------------------------------------------------------------
# Attach Transit Gateway to VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "TGW-Attach-VPC5" {
    provider = aws.region_virginia
    subnet_ids = [aws_subnet.VPC5-Subnet-Private.id]
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-2.id
    vpc_id = aws_vpc.VPC5.id
    tags = {
        "Name" = "transit gateway attachment vpc5"
    }
}

# Update route table routing to all VPC
resource "aws_route" "vpc5_route_vpcs" {
    provider = aws.region_virginia
    route_table_id = aws_route_table.VPC5-RT-Private.id
    destination_cidr_block = var.cidr_block_allvpc
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-2.id
}

# Update route table routing to on-premise
resource "aws_route" "vpc5_route_onpremise" {
    provider = aws.region_virginia
    route_table_id = aws_route_table.VPC5-RT-Private.id
    destination_cidr_block = var.cidr_block_onpremise
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-2.id
}
