# Create EC2 for VPC4
resource "aws_instance" "vpc4_instance" {
    provider = aws.region_virginia

    ami = "ami-0ebfd941bbafe70c6"  # Amazon Linux AMI 2023
    instance_type = "t2.micro"
    subnet_id = aws_subnet.VPC4-Subnet-Private.id
    security_groups = [aws_security_group.VPC4-SG-Private.id]
    associate_public_ip_address = false
    key_name = "aws-lab-us"

    tags = {
        Name = "vpc4_instance"
    }
}

# Create EC2 for VPC5
resource "aws_instance" "vpc5_instance" {
    provider = aws.region_virginia

    ami = "ami-0ebfd941bbafe70c6"  # Amazon Linux AMI 2023
    instance_type = "t2.micro"
    subnet_id = aws_subnet.VPC5-Subnet-Private.id
    security_groups = [aws_security_group.VPC5-SG-Private.id]
    associate_public_ip_address = false
    key_name = "aws-lab-us"

    tags = {
        Name = "vpc5_instance"
    }
}


#########################################################################################################
# Create on-premise server for vpn connection
#########################################################################################################
# create static ip
resource "aws_eip" "on_premise" {provider = aws.region_virginia}
# associate static ip with ec2 instance
resource "aws_eip_association" "on_premise" {
    provider = aws.region_virginia
    instance_id = aws_instance.vpc6_instance.id
    allocation_id = aws_eip.on_premise.id
}

# collect all needed data
locals {
    on_premise_public_ip = aws_eip.on_premise.public_ip
    tunnel1_public_ip = aws_vpn_connection.transit_vpn.tunnel1_address
    tunnel2_public_ip = aws_vpn_connection.transit_vpn.tunnel2_address
    cidr_cloud = var.cidr_block_allvpc
    cidr_on_premise = var.cidr_block_onpremise
}

# create server
resource "aws_instance" "vpc6_instance" {
    provider = aws.region_virginia

    ami = "ami-0866a3c8686eaeeba"  # Ubuntu Server 24.04 LTS
    instance_type = "t2.micro"
    subnet_id = aws_subnet.VPC6-Subnet-Public.id
    security_groups = [aws_security_group.VPC6-SG-Public.id]
    associate_public_ip_address = true
    key_name = "aws-lab-us"

    tags = {
        Name = "vpc6_instance"
    }

    # Run Shell script to install LibreSwan
    user_data = <<-EOF
    #!/bin/bash
    sudo -i
    apt update -y && apt install libreswan net-tools -y
    
    file="/etc/sysctl.conf"
    [[ -z "$(grep '^\s*net\.ipv4\.ip_forward' $file)" ]] && echo 'net.ipv4.ip_forward = 1' >> $file
    [[ -z "$(grep '^\s*net\.ipv4\.conf\.default\.rp_filter' $file)" ]] && echo 'net.ipv4.conf.default.rp_filter = 0' >> $file
    [[ -z "$(grep '^\s*net\.ipv4\.conf\.default\.accept_source_route' $file)" ]] && echo 'net.ipv4.conf.default.accept_source_route = 0' >> $file
    sysctl -p # applying new change

    file="/etc/ipsec.conf"
    [[ -z "$(grep '^\s*include\s*\/etc\/ipsec.d\/\*\.conf' $file)" ]] && echo 'include /etc/ipsec.d/*.conf' >> $file

    file="/etc/ipsec.d/aws.conf"
    echo '
    conn Tunnel1
        authby=secret
        auto=start
        left=%defaultroute
        leftid=${local.on_premise_public_ip}
        right=${local.tunnel1_public_ip}
        type=tunnel
        ikelifetime=8h
        keylife=1h
        phase2alg=aes128-sha1;modp2048
        ike=aes128-sha1;modp2048
        keyingtries=%forever
        keyexchange=ike
        leftsubnet=${local.cidr_on_premise}
        rightsubnet=${local.cidr_cloud}
        dpddelay=10
        dpdtimeout=30
        dpdaction=restart_by_peer

    conn Tunnel2
        authby=secret
        auto=start
        left=%defaultroute
        leftid=${local.on_premise_public_ip}
        right=${local.tunnel2_public_ip}
        type=tunnel
        ikelifetime=8h
        keylife=1h
        phase2alg=aes128-sha1;modp2048
        ike=aes128-sha1;modp2048
        keyingtries=%forever
        keyexchange=ike
        leftsubnet=${local.cidr_on_premise}
        rightsubnet=${local.cidr_cloud}
        dpddelay=10
        dpdtimeout=30
        dpdaction=restart_by_peer

    ' > $file

    file="/etc/ipsec.d/aws.secrets"
    echo '
    ${local.on_premise_public_ip} ${local.tunnel1_public_ip}: PSK "${var.psk[0]}"
    ${local.on_premise_public_ip} ${local.tunnel2_public_ip}: PSK "${var.psk[1]}"
    ' > $file

    netplan apply
    systemctl enable ipsec
    systemctl start ipsec
    systemctl status ipsec

    ipsec status

    EOF
}





