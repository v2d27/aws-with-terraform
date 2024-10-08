# Create S3 bucket 
resource "aws_s3_bucket" "ssm-bucket-0001" {
    provider = aws.region_singapore
    bucket = "ssm-bucket-0001"
    force_destroy = true # To allow Terraform to delete non-empty buckets
    tags = {
        Name = "ssm-bucket-0001"
    }
} # => Default s3 ACL is private

# Create logs folder in S3 bucket
resource "aws_s3_object" "logs" {
    provider = aws.region_singapore
    bucket = aws_s3_bucket.ssm-bucket-0001.id
    force_destroy = true
    key = "logs/"
    acl = "private"
}









