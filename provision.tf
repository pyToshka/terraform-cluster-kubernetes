resource "null_resource" "ansible-provision" {

  depends_on = ["aws_instance.master","aws_instance.slave"]

  provisioner "local-exec" {
    command =  "echo \"[kube-master]\n${aws_instance.master.tags.Name} ansible_ssh_host=${aws_instance.master.public_ip}\" > kargo/inventory/inventory"
  }

  provisioner "local-exec" {
    command =  "echo \"\n[etcd]\n${aws_instance.master.tags.Name} ansible_ssh_host=${aws_instance.master.public_ip}\" >> kargo/inventory/inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"\n[kube-node]\" >> kargo/inventory/inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", aws_instance.slave.*.tags.Name,aws_instance.slave.*.public_ip))}\" >> kargo/inventory/inventory"
  }

  provisioner "local-exec" {
    command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> kargo/inventory/inventory"
  }
}