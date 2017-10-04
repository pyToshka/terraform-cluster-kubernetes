variable "provider" {
    type = "map"
    default = {
        access_key = "your_access_key"
        secret_key = "your_secret_key"
        region     = "us-east-1"
    }
}

variable "aws_key_name" {
  default = "air"
}

variable "images" {
    type    = "map"
    default = {
        eu-west-1      = "ami-17d11e6e"
        ap-southeast-2 = "ami-391ff95b"
        us-east-1      = "ami-d651b8ac"
        us-west-1      = "ami-2d5c6d4d"
        us-west-2      = "ami-ecc63a94"
    }
}
variable vpc_cidr_block {
    default = "172.30.0.0/16"
}

variable container_cidr_block {
    default = "10.216.0.0/16"
}

variable "publicly_accessible" {
  description = "Determines if database can be publicly available (NOT recommended)"
  default     = true
}
variable "num_masters"{
  default = "1"
}
variable "num_slaves" {
  default = "2"
}
variable "master_instance_type"{
  default = "t2.micro"
}
variable "slave_instance_type" {
  default = "t2.micro"
}

variable iam_suffix {
	default = ""
}
variable "cluster_name" {
  default = "k8-cl"
}
variable num_azs {
    default = "1"
}
variable "azs" {
    type = "map"
    default = {
        "ap-southeast-2" = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
        "eu-west-1"      = "eu-west-1a,eu-west-1b,eu-west-1c"
        "us-west-1"      = "us-west-1b,us-west-1c"
        "us-west-2"      = "us-west-2a,us-west-2b,us-west-2c"
        "us-east-1"      = "us-east-1a,us-east-1b,us-east-1c,us-east-1d"
    }
}
variable enable_extra_slave_security_group {
    default = false
}

variable extra_slave_security_group {
    description = "Extra security groups that will be allow to talk to the slaves"
    default = ""
}

variable extra_slave_security_group_port {
    description = "Port on which the extra security groups that will be allow to talk to the slaves"
    default = 80
}
variable elb_name {
  type = "string"
  default = "k8s-master"
}
variable "domain_name" {
  type        = "string"
  description = "The suffix domain name to use by default when resolving non Fully Qualified Domain Names"
  default     = "k8s.cloud"
}

variable "name_servers" {
  type        = "list"
  description = "List of name servers to configure in '/etc/resolv.conf'"
  default     = ["AmazonProvidedDNS"]
}

variable "netbios_name_servers" {
  type        = "list"
  description = "List of NETBIOS name servers"
  default     = []
}

variable "netbios_node_type" {
  type        = "string"
  description = "The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network."
  default     = ""
}

variable "ntp_servers" {
  type        = "list"
  description = "List of NTP servers to configure"
  default     = []
}
