###########################################################################################################
# I will use "alias" in both two accounts to easily distinguish
# Settings bellow will set default provider for terraform, so you won't be worry about missing "provider"
#
# provider "aws" {
#     access_key = var.access_key_1
#     secret_key = var.secret_key_1
#     region = var.region_singapore
# }
###########################################################################################################

# Account 1, Region: Singapore
provider "aws" {
    access_key = var.access_key_1
    secret_key = var.secret_key_1
    region = var.region_singapore
    alias = "region_singapore"
}

# Account 2, Region: Virginia
provider "aws" {
    access_key = var.access_key_2
    secret_key = var.secret_key_2
    region = var.region_virginia
    alias = "region_virginia"
}




#----------------------------------------------------------------------------------------------------------
# use caller to get target AWS AccountID
#----------------------------------------------------------------------------------------------------------
data "aws_caller_identity" "target" {
    provider = aws.region_virginia
}













