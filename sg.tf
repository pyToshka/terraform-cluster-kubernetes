
resource "aws_security_group" "masters" {
    vpc_id = "${aws_vpc.main.id}"
    name = "kubernetes-master-${var.cluster_name}"
    description = "Kubernetes security group applied to master nodes"

    tags {
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_security_group_rule" "masters-allow-elb" {
    security_group_id = "${aws_security_group.masters.id}"

    type = "ingress"
    source_security_group_id = "${aws_elb.master.source_security_group_id}"
    from_port = 443
    to_port = 443
    protocol = "tcp"
}

resource "aws_security_group_rule" "masters-allow-slaves" {
    security_group_id = "${aws_security_group.masters.id}"

    type = "ingress"
    source_security_group_id = "${aws_security_group.slaves.id}"
    from_port = 0
    to_port = 0
    protocol = "-1"
}

resource "aws_security_group_rule" "masters-allow-masters" {
    security_group_id = "${aws_security_group.masters.id}"

    type = "ingress"
    self = true
    from_port = 0
    to_port = 0
    protocol = "-1"
}

resource "aws_security_group_rule" "masters-allow-ssh" {
    security_group_id = "${aws_security_group.masters.id}"

    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "masters-allow-https" {
    security_group_id = "${aws_security_group.masters.id}"

    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "masters-allow-egress" {
    security_group_id = "${aws_security_group.masters.id}"

    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "slaves" {
    vpc_id = "${aws_vpc.main.id}"
    name = "kubernetes-slave-${var.cluster_name}"
    description = "Kubernetes security group applied to slaves nodes"

    tags {
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_security_group_rule" "slaves-allow-slaves" {
    security_group_id = "${aws_security_group.slaves.id}"

    type = "ingress"
    self = true
    from_port = 0
    to_port = 0
    protocol = "-1"
}

resource "aws_security_group_rule" "slaves-allow-masters" {
    security_group_id = "${aws_security_group.slaves.id}"

    type = "ingress"
    source_security_group_id = "${aws_security_group.masters.id}"
    from_port = 0
    to_port = 0
    protocol = "-1"
}

resource "aws_security_group_rule" "slaves-allow-ssh" {
    security_group_id = "${aws_security_group.slaves.id}"

    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "slaves-allow-egress" {
    security_group_id = "${aws_security_group.slaves.id}"

    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "slaves-allow-extra" {
    count = "${var.enable_extra_slave_security_group}"
    security_group_id = "${aws_security_group.slaves.id}"

    type = "ingress"
    source_security_group_id = "${var.extra_slave_security_group}"
    from_port = "${var.extra_slave_security_group_port}"
    to_port = "${var.extra_slave_security_group_port}"
    protocol = "tcp"
}

resource "aws_security_group" "master-elb" {
    vpc_id = "${aws_vpc.main.id}"
    name = "kubernetes-master-elb-${var.cluster_name}"
    description = "Kubernetes security group for master API ELB"

    tags {
        KubernetesCluster = "${var.cluster_name}"
    }
}

resource "aws_security_group_rule" "master-elb-allow-https" {
    security_group_id = "${aws_security_group.master-elb.id}"

    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-elb-allow-egress" {
    security_group_id = "${aws_security_group.master-elb.id}"

    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}