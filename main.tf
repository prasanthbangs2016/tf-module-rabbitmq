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
    cidr_blocks      = [var.vpc_cidr_block]

  }


  tags = {
    Name = "Roboshop-${var.env}-docdb"
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



