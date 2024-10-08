# Requester: VPC3
# Accepter: VPC4

# ----------------------------------------------------------------------------------------------------------
# Create VPC Peering
# ----------------------------------------------------------------------------------------------------------
# create inter-region-vpc-peering connection
resource "aws_vpc_peering_connection" "inter-region-vpc-peering" {
    provider = aws.region_singapore

    # the ID of the requester VPC
    vpc_id = aws_vpc.VPC3.id

    # Target VPC
    peer_owner_id = data.aws_caller_identity.target.account_id
    peer_vpc_id = aws_vpc.VPC4.id
    peer_region = var.region_virginia

    # accept the peering (both VPCs need to be in the same AWS account and region)
    # If two VPCs are in the same region, you only just to enable it, dont need to create accepter
    # auto_accept = true 

    tags = {
        Name = "inter-region-vpc-peering"
    }
}

# create vpc_peering_connection_accepter
resource "aws_vpc_peering_connection_accepter" "inter-region-vpc-peering-accepter" {
    provider = aws.region_virginia
    vpc_peering_connection_id = aws_vpc_peering_connection.inter-region-vpc-peering.id
    
    # whether or not to accept the peering request, defaults to false.
    auto_accept = true

    tags = {
        Name = "inter-region-vpc-peering-accepter"
    }
}



# ----------------------------------------------------------------------------------------------------------
# Enable DNS resolution
# ----------------------------------------------------------------------------------------------------------
# enable DNS resolution for the requester VPC
resource "aws_vpc_peering_connection_options" "options_requester" {
    provider = aws.region_singapore
    vpc_peering_connection_id = aws_vpc_peering_connection.inter-region-vpc-peering.id

    requester {
        allow_remote_vpc_dns_resolution = true  # enable DNS resolution for the requester VPC
    }
}

# enable DNS resolution for the accepter VPC
resource "aws_vpc_peering_connection_options" "options_accepter" {
    provider = aws.region_virginia
    vpc_peering_connection_id = aws_vpc_peering_connection.inter-region-vpc-peering.id

    accepter {
        allow_remote_vpc_dns_resolution = true  # enable DNS resolution for the accepter VPC
    }
}


# ----------------------------------------------------------------------------------------------------------
# Update necessary route table
# ----------------------------------------------------------------------------------------------------------
# update route table for region_singapore
resource "aws_route" "vpc_peering_route_sin" {
    provider = aws.region_singapore
    route_table_id = aws_route_table.VPC3-RT-Public.id

    # connect to VPC4/us through vpc peering
    destination_cidr_block = var.cidr_block_vpc4
    vpc_peering_connection_id = aws_vpc_peering_connection.inter-region-vpc-peering.id

    depends_on = [ aws_route_table.VPC3-RT-Public ]
}

# update route table for region_virginia
resource "aws_route" "vpc_peering_route_us" {
    provider = aws.region_virginia
    route_table_id = aws_route_table.VPC4-RT-Private.id

    # connect to VPC3 through vpc peering
    destination_cidr_block = var.cidr_block_vpc3
    vpc_peering_connection_id = aws_vpc_peering_connection.inter-region-vpc-peering.id
}




