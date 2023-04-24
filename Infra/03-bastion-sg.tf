resource "aws_security_group" "bastion-sg" {
  name        = "${local.id_gen}-bastion-SG"
  description = "Bastion server security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
        Name = "${local.id_gen}-bastion-SG"
    },
    local.common_tags) 
}

resource "aws_security_group_rule" "bastion-sg-rules" {
  for_each = (var.port_sg)
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.bastion-sg.id
}