resource "aws_elb" "master" {
    name = "${var.elb_name}"
    subnets = ["${aws_subnet.main.*.id}"]
    security_groups = ["${aws_security_group.master-elb.id}"]

    tags {
        KubernetesCluster = "${var.cluster_name}"
    }

    listener {
        instance_port = 443
        instance_protocol = "tcp"
        lb_port = 443
        lb_protocol = "tcp"
    }

    health_check {
       healthy_threshold = 2
       unhealthy_threshold = 6
       timeout = 5
       interval = 10
       target = "TCP:443"
    }

    instances = ["${aws_instance.master.*.id}"]
}