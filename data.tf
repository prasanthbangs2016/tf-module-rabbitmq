data "aws_ssm_parameter" "credentials" {
  name = "mutable.rabbitmq.${var.env}.credentials"
}

data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "centos-devops-practice"
  owners           = ["self"]

#  filter {
#    name   = "name"
#    values = ["myami-*"]
#  }
#
#  filter {
#    name   = "root-device-type"
#    values = ["ebs"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
}