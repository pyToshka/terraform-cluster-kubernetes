#!/bin/bash
version=`terraform -v|grep 'Terraform'|grep -v 'Your'|sed 's/Terraform //g'` > /dev/null 2>&1
version_min="v0.10"
if [ $version \> $version_min ]
then
  echo "Getting terraform providers and provisioners"
  terraform init > /dev/null 2>&1
fi
echo "Planning infrastructure"
terraform plan > /dev/null 2>&1
echo "Creating infrastructure"
terraform apply
echo "Quick sleep while instances spin up"
sleep 60
echo "Ansible provisioning"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i kargo/inventory/inventory -u ubuntu -b kargo/cluster.yml
echo "Terraform output"
terraform output