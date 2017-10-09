resource "aws_instance" "master" {
    count = "${var.num_masters}"
    lifecycle {
        prevent_destroy = false
    }
    disable_api_termination = false
    ami  = "${lookup(var.images, var.provider["region"])}"
    instance_type = "${var.master_instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.master.name}"
    key_name = "${var.aws_key_name}"
    tags {
        KubernetesCluster = "${var.cluster_name}"
        Name = "${var.cluster_name}-master-${count.index}"
        Role = "${var.cluster_name}-master"
    }
    associate_public_ip_address = true
    source_dest_check = false
    subnet_id = "${element(aws_subnet.main.*.id, count.index % var.num_azs)}"
    vpc_security_group_ids = ["${aws_security_group.masters.id}"]
    provisioner "remote-exec" {
        connection {
			user = "ubuntu"
            private_key = "${file("${var.private_key}")}"
        }
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y python2.7"
        ]
    }
    provisioner "remote-exec" {
        connection {
			user = "ubuntu"
            private_key = "${file("${var.private_key}")}"
        }
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y python-minimal",
            "sudo ln -sf /usr/bin/python2.7 /usr/bin/python"

        ]
    }
}

resource "aws_instance" "slave" {
    count = "${var.num_slaves}"
    lifecycle {
        prevent_destroy = false
    }
    disable_api_termination = false
    ami = "${lookup(var.images, var.provider["region"])}"
    instance_type = "${var.slave_instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.slaves.name}"
    key_name = "${var.aws_key_name}"

    tags {
        KubernetesCluster = "${var.cluster_name}"
        Name = "${var.cluster_name}-slave-${count.index}"
        Role = "${var.cluster_name}-slave"
    }
    associate_public_ip_address = true
    source_dest_check = false
    subnet_id = "${element(aws_subnet.main.*.id, count.index % var.num_azs)}"
    vpc_security_group_ids = ["${aws_security_group.slaves.id}"]
    depends_on = ["aws_subnet.main"]
     provisioner "remote-exec" {
        connection {
			user = "ubuntu"
            private_key = "${file("${var.private_key}")}"
        }
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y python2.7",
            "sudo ln -sf /usr/bin/python2.7 /usr/bin/python"


        ]
    }


}
