module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "1.60.0"
  name = "achmat-bastion"

  cidr = "10.21.0.0/16"

  subnetid= [
    "10.21.101.0/24"
  ]
}

resource "aws_iam_instance_profile" "default" {
  name = "achmatBastion"
  role = "${aws_iam_role.default.name}"
}

resource "aws_iam_role" "default" {
  name = "BastionRole"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}


resource "aws_security_group" "bastion-sg" {
  name   = "bastion-security-group"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0c10fa5f3930d0d31"
  key_name                    = "${aws_key_pair.main.key_name}"
  instance_type               = "t3.nano"
  security_groups             = ["${aws_security_group.bastion-sg.name}"]
  subnet_id                   = "${module.vpc.subnetid}"
  iam_instance_profile        = "${aws_iam_instance_profile.default.name}"
  associate_public_ip_address = true

}

resource "aws_key_pair" "main" {
  key_name   = "${var.key_name}"
  public_key = "${var.key_pair}"
}

output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}
