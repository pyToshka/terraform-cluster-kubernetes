output "Kubernetes Master Public Ip " {
  value = "${aws_instance.master.*.public_ip}"
}
output "Kubernetes Slaves Public Ip " {
  value = "${aws_instance.slave.*.public_ip}"
}
output "Kubernetes Master Public DNS " {
  value = "${aws_instance.master.*.public_dns}"
}
output "Kubernetes Slaves Public DNS " {
  value = "${aws_instance.slave.*.public_dns}"
}