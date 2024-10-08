# Create EC2 for VPC1
resource "aws_instance" "vpc1_instance" {
    provider = aws.region_singapore
    ami = "ami-0aa097a5c0d31430a"  # Amazon Linux AMI 2023
    instance_type = "t2.micro"
    subnet_id = aws_subnet.VPC1-Subnet-Public.id
    security_groups = [aws_security_group.VPC1-SG-Public.id]
    associate_public_ip_address = true
    key_name = "aws-lab"

    tags = {
        Name = "vpc1_instance"
    }
}

# Create EC2 for VPC2
resource "aws_instance" "vpc2_instance" {
    provider = aws.region_singapore
    ami = "ami-0aa097a5c0d31430a"  # Amazon Linux AMI 2023
    instance_type = "t2.micro"
    subnet_id = aws_subnet.VPC2-Subnet-Private.id
    security_groups = [aws_security_group.VPC2-SG-Private.id]
    associate_public_ip_address = false
    key_name = "aws-lab"

    iam_instance_profile = aws_iam_instance_profile.SessionManager-Profile.name

    tags = {
        Name = "vpc2_instance"
    }
}


# Create EC2 for VPC3
resource "aws_instance" "vpc3_instance" {
    provider = aws.region_singapore
    ami = "ami-0aa097a5c0d31430a"  # Amazon Linux AMI 2023
    instance_type = "t2.micro"
    subnet_id = aws_subnet.VPC3-Subnet-Public.id
    security_groups = [aws_security_group.VPC3-SG-Public.id]
    associate_public_ip_address = true
    key_name = "aws-lab"
    
    tags = {
        Name = "vpc3_instance"
    }
}


# # Key Pair => Uncomment this line to define your key-perm
# resource "aws_key_pair" "aws-lab" {
#     provider = aws.region_singapore
#     key_name = "aws-lab"
#     public_key = file("../../aws-lab.pem") # put your public key here
# }



