# Create the IAM Role for EC2
resource "aws_iam_role" "SessionManager-Role" {
    provider = aws.region_singapore
    name = "SessionManager-Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}

# Attach the AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
    provider = aws.region_singapore
    role = aws_iam_role.SessionManager-Role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach the AmazonS3FullAccess
resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
    provider = aws.region_singapore
    role = aws_iam_role.SessionManager-Role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


# Create IAM profile to attach EC2
resource "aws_iam_instance_profile" "SessionManager-Profile" {
    provider = aws.region_singapore
    name = "SessionManager-Profile"
    role = aws_iam_role.SessionManager-Role.name
}
