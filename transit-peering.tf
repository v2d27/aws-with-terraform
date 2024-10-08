#################################################################################################
# The Transit Gateway itself does not directly support DNS resolution across VPCs or regions.
# However, you can still achieve DNS resolution between VPCs connected to a Transit Gateway 
# by configuring your VPC settings and using Route 53 for cross-VPC DNS resolution.
#################################################################################################


#------------------------------------------------------------------------------------------------
# Region Singapore: Requester
#------------------------------------------------------------------------------------------------
# Create Transit Gateway Peering Attachment
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
    provider = aws.region_singapore
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id

    # Target transit gateway
    peer_account_id = data.aws_caller_identity.target.account_id  # for intra-region peering, please remove it or make it empty string
    peer_region = var.region_virginia  
    peer_transit_gateway_id = aws_ec2_transit_gateway.my-tgw-2.id

    tags = {
        Name = "tgw_peering"
    }
}

# update TGW route table to TGW peering
resource "aws_ec2_transit_gateway_route" "tgw1_rt_route_peering" {
    provider = aws.region_singapore
    # Routing to VPC5
    destination_cidr_block = var.cidr_block_vpc5 
    transit_gateway_route_table_id = aws_ec2_transit_gateway.my-tgw-1.association_default_route_table_id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
}


#------------------------------------------------------------------------------------------------
# Region Virginia: Accepter
#------------------------------------------------------------------------------------------------
# Create TGW peering accepter
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peering_accepter" {
    provider = aws.region_virginia

    # Poiting to TGW requester
    transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id

    tags = {
        Name = "tgw_peering_accepter"
    }
}

# update TGW route table to TGW peering
resource "aws_ec2_transit_gateway_route" "tgw2_rt_route_peering" {
    provider = aws.region_virginia
    # Routing to all VPCs which are connected to Transit Gateway
    destination_cidr_block = var.cidr_block_allvpc  
    transit_gateway_route_table_id = aws_ec2_transit_gateway.my-tgw-2.association_default_route_table_id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accepter.id
}

# update TGW route table to TGW peering
resource "aws_ec2_transit_gateway_route" "tgw2_rt_route_onpremise" {
    provider = aws.region_virginia
    # Routing to on-premise
    destination_cidr_block = var.cidr_block_onpremise
    transit_gateway_route_table_id = aws_ec2_transit_gateway.my-tgw-2.association_default_route_table_id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_peering_accepter.id
}

