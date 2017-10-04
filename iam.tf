resource "aws_iam_instance_profile" "slaves" {
    name = "${replace("${var.cluster_name}-kubernetes-slave", "_", "-")}"
    role = "${aws_iam_role.slave.name}"
}

resource "aws_iam_instance_profile" "master" {
    name = "kubernetes-master${var.iam_suffix}"
    role = "${aws_iam_role.master.name}"
}

resource "aws_iam_role" "slave" {
    name               = "${replace("${var.cluster_name}-kubernetes-slave", "_", "-")}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "master" {
    name = "kubernetes-master${var.iam_suffix}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "slave" {
    name = "kubernetes-slave"
    role = "${aws_iam_role.slave.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::kubernetes-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:AttachVolume",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DetachVolume",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "master" {
    name = "kubernetes-master"
    role = "${aws_iam_role.master.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": ["elasticloadbalancing:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::kubernetes-*"
      ]
    }
  ]
}
EOF
}