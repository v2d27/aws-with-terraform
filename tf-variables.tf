# account 1
variable "access_key_1" {}
variable "secret_key_1" {}

# account 2
variable "access_key_2" {}
variable "secret_key_2" {}

# region 1
variable "region_singapore" {
  type = string
  default = "ap-southeast-1"
}

# region 2
variable "region_virginia" {
  type = string
  default = "us-east-1"
}

# custom psk for vpn connection
variable "psk" {
  description = "Optional preshared_key for vpn tunnel 1 and vpn tunnel 2"
  type = list(string)
  default = [ "TT1KRlvnxbk8Hy8SG3m8Cj.zebPvCQ40cPTtqCC2mmPfh6y37XkFXRBft0RF", "2fDfA535eW4Av7dApfpMhyh6WR7CfOvaiGOSDTuCcb5DjuCr6_chWHIzVFHA" ]
}

variable "cidr_block_onpremise" {
  type = string
  default = "192.168.0.0/16"
}

variable "cidr_block_allvpc" {
  type = string
  default = "10.0.0.0/8"
}

variable "cidr_block_anywhere" {
  type = string
  default = "0.0.0.0/0"
}

variable "cidr_block_vpc1" {
  type = string
  default = "10.11.0.0/16"
}

variable "subnet_public_vpc1" {
  type = string
  default = "10.11.1.0/24"
}

variable "cidr_block_vpc2" {
  type = string
  default = "10.12.0.0/16"
}

variable "subnet_private_vpc2" {
  type = string
  default = "10.12.1.0/24"
}

variable "cidr_block_vpc3" {
  type = string
  default = "10.13.0.0/16"
}

variable "subnet_public_vpc3" {
  type = string
  default = "10.13.1.0/24"
}

variable "cidr_block_vpc4" {
  type = string
  default = "10.22.0.0/16"
}

variable "subnet_private_vpc4" {
  type = string
  default = "10.22.1.0/24"
}

variable "cidr_block_vpc5" {
  type = string
  default = "10.25.0.0/16"
}

variable "subnet_private_vpc5" {
  type = string
  default = "10.25.1.0/24"
}

variable "subnet_public_vpc6" {
  type = string
  default = "192.168.1.0/24"
}











