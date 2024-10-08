################################################################################################################
# Create VPN connection
# NOTE: 
#     VPN connection is associated with a Transit Gateway automatically.
#     Don't need to manually attach       
################################################################################################################

# --------------------------------------------------------------------------------------------------------------
# create vpn connection
# --------------------------------------------------------------------------------------------------------------
# create customer gateway
resource "aws_customer_gateway" "cgw" {
    provider = aws.region_singapore
    # ASN of your on-premise network
    bgp_asn = 65000
    # Enter exactly your customer gate public IP address
    ip_address = aws_eip.on_premise.public_ip
    # Only support ipsec.1 now
    type = "ipsec.1"
}

# Make VPN connection from VPN to AWS Transit Gateway
resource "aws_vpn_connection" "transit_vpn" {
    provider = aws.region_singapore
    customer_gateway_id = aws_customer_gateway.cgw.id
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
    type = "ipsec.1"

    # use static route for vpn
    static_routes_only = true

    # limit ip range for vpn connection
    local_ipv4_network_cidr = var.cidr_block_onpremise
    remote_ipv4_network_cidr = var.cidr_block_allvpc
    
    # specific PSK tunnel1 and tunnel2 for VPN connection
    tunnel1_preshared_key = var.psk[0]
    tunnel2_preshared_key = var.psk[1]

    tags = {
        Name = "transit_vpn"
    }
} # => Please wait about 5 minutes after creation to ping successfully


# --------------------------------------------------------------------------------------------------------------
# update necessary route tables
# --------------------------------------------------------------------------------------------------------------
# update transit gateway route table
resource "aws_ec2_transit_gateway_route" "tgw1_rt_route_vpn" {
    provider = aws.region_singapore
    # using default route table of transit gateway
    transit_gateway_route_table_id = aws_ec2_transit_gateway.my-tgw-1.association_default_route_table_id

    # aws_vpn_connection routing for transit gateway
    destination_cidr_block = var.cidr_block_onpremise
    transit_gateway_attachment_id = aws_vpn_connection.transit_vpn.transit_gateway_attachment_id
}
 
# update vpc1 route table for vpn connection
resource "aws_route" "vpc1_on_premise_route" {
    provider = aws.region_singapore
    route_table_id = aws_route_table.VPC1-RT-Public.id
    destination_cidr_block = local.cidr_on_premise # connect to on-premises
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
}

# update vpc2 route table for vpn connection
resource "aws_route" "vpc2_on_premise_route" {
    provider = aws.region_singapore
    route_table_id = aws_route_table.VPC2-RT-Private.id
    destination_cidr_block = local.cidr_on_premise # connect to on-premises
    transit_gateway_id = aws_ec2_transit_gateway.my-tgw-1.id
}
