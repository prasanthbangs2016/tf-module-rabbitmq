#creating security group for db

resource "aws_security_group" "main" {
  name        = "roboshop-${var.env}-rabbitmq"
  description = "roboshop-${var.env}-rabbitmq"
  vpc_id      = var.vpc_id

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

#resource "null_resource" "ansible_apply" {
#  provisioner "remote-exec" {
#    connection {
#      host = aws_spot_instance_request.rabbitmq.private_ip
#      user = "centos"
#      //password = local.ssh_password
#      password = "DevOps321"
#
#    }
#    inline = [
#      "ansible-pull -i localhost, -U https://github.com/prasanthbangs2016/roboshop-mutable-ansible   -e HOST=localhost -e APP_COMPONENT_ROLE=rabbitmq -e ENV=${var.env} -e RABBITMQ_PASSWORD=${local.password}"
#      #"echo Prashanth"
#    ]
#  }
#}



