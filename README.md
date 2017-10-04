# terraform-kubernetes

A terraform module for provisioning AWS resources (VMs, VPC, route table etc) for running a Kubernetes cluster.  Builds a multi-master, multi-AZ cluster for Kubernetes.

### This is test for creating infrastructure for k8s

To use:

```shell
git clone this repo
cd erraform-kubernetes
change Your vars in variables.tf
Don't forget change this
variable "provider" {
    type = "map"
    default = {
        access_key = "your_access_key"
        secret_key = "your_secret_key"
        region     = "us-east-1"
    }
}
terraformt init 
terraform plan
terraform apply
```
