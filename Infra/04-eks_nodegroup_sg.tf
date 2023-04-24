resource "aws_security_group" "drupal-ng-sg" {
  name        = "${local.id_gen}-drupal-ng-SG"
  description = "Drupal Worker nodes security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
        Name = "${local.id_gen}-Drupal-ng-SG"
    },
    local.common_tags) 
}

resource "aws_security_group_rule" "drupal-ng-sg-rules" {
  for_each = toset((var.drupal_port_sg))
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_Cidr]
  security_group_id = aws_security_group.drupal-ng-sg.id
}