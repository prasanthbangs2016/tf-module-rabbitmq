#creating security group for db

resource "aws_security_group" "main" {
  name        = "roboshop-${var.env}-rabbitmq"
  description = "roboshop-${var.env}-rabbitmq"
  vpc_id      = var.vpc_id
#to instance
  ingress {
    description      = "rabbitmq"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block,var.WORKSTATION_IP]

  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block,var.WORKSTATION_IP]

  }
#outbound from instance
  egress {
    description      = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  tags = {
    Name = "Roboshop-${var.env}-rabbitmq"
  }
}

resource aws_spot_instance_request "rabbitmq" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  subnet_id     = element(var.db_subnet_ids, 0)
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "rabbitmq-${var.env}"

  }

}

resource "aws_ec2_tag" "name" {
  resource_id = aws_spot_instance_request.rabbitmq.spot_instance_id
  key = "Name"
  value = "Roboshop-${var.env}-rabbitmq"
}

resource "null_resource" "ansible_apply" {
  provisioner "remote-exec" {
    connection {
      host = aws_spot_instance_request.rabbitmq.private_ip
      user = "centos"
      #user = local.username
      #password = local.ssh_password
      password = "DevOps321"

    }
    inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -U https://github.com/prasanthbangs2016/roboshop-mutable-ansible--v2 roboshop.yml -e HOSTS=localhost -e APP_COMPONENT_ROLE=rabbitmq -e ENV=${var.env} -e RABBITMQ_PASSWORD=${local.password} &>/tmp/rabbitmq.log"
    ]
  }
}



