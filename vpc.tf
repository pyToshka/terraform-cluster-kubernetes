resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
  vpc_id          = "${aws_vpc.main.id}"
}
resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true

    tags {
        Name = "kubernetes-vpc"
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_vpc_dhcp_options" "main" {
    domain_name          = "${var.domain_name}"
    domain_name_servers  = ["${compact(var.name_servers)}"]
    netbios_name_servers = ["${compact(var.netbios_name_servers)}"]
    netbios_node_type    = "${var.netbios_node_type}"
    ntp_servers          = ["${compact(var.ntp_servers)}"]
    tags {
        Name = "kubernetes-dhcp-option-set"
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_network_acl" "main" {
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    egress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "main" {
    count   = "${length(split(",", lookup(var.azs, var.provider["region"])))}"
    vpc_id      = "${aws_vpc.main.id}"
    cidr_block = "${cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)}"
    availability_zone = "${element(split(",", lookup(var.azs, var.provider["region"])), count.index)}"
    tags {
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_route_table" "main" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_route_table_association" "main" {
    count = "${var.num_azs}"
    subnet_id = "${element(aws_subnet.main.*.id, count.index)}"
    route_table_id = "${aws_route_table.main.id}"
}

resource "aws_route" "internet-route" {
    route_table_id = "${aws_route_table.main.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
    depends_on = ["aws_route_table.main"]
}

resource "aws_route" "master-route" {
    count = "${var.num_masters}"
    route_table_id = "${aws_route_table.main.id}"

    destination_cidr_block = "${cidrsubnet(var.container_cidr_block, 8, 100 + count.index)}"
    instance_id = "${element(aws_instance.master.*.id, count.index)}"
}

resource "aws_route" "slaves-route" {
    count = "${var.num_slaves}"
    route_table_id = "${aws_route_table.main.id}"

    destination_cidr_block = "${cidrsubnet(var.container_cidr_block, 8, 254 - (25 * (count.index % var.num_azs)) - (count.index / var.num_azs))}"
    instance_id = "${element(aws_instance.slave.*.id, count.index)}"
}