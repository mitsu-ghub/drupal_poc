resource "aws_security_group" "rds-sg" {
  name        = "${local.id_gen}-rds-SG"
  description = "RDS security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
        Name = "${local.id_gen}-RDS-SG"
    },
    local.common_tags) 
}

resource "aws_security_group_rule" "rds-sg-rules" {
  
  type              = "ingress"
  from_port         = var.db_ports["rds"]
  to_port           = var.db_ports["rds"]
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_Cidr]
  security_group_id = aws_security_group.rds-sg.id
}

resource "aws_security_group" "memcache-sg" {
  name        = "${local.id_gen}-memcache-SG"
  description = "memcache security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
        Name = "${local.id_gen}-memcache-SG"
    },
    local.common_tags) 
}

resource "aws_security_group_rule" "memcache-sg-rules" {
  type              = "ingress"
  from_port         = var.db_ports["memcache"]
  to_port           = var.db_ports["memcache"]
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_Cidr]
  security_group_id = aws_security_group.memcache-sg.id
}

/*
resource "aws_security_group" "elastisearch-sg" {
  name        = "${local.id_gen}-elastisearch-SG"
  description = "Elastisearch  security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
        Name = "${local.id_gen}-elastisearch-SG"
    },
    local.common_tags) 
}

resource "aws_security_group_rule" "elastisearch-sg-rules" {
  type              = "ingress"
  from_port         = var.db_ports["redis"]
  to_port           = var.db_ports["redis"]
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_Cidr]
  security_group_id = aws_security_group.elastisearch-sg.id
}
*/


resource "aws_security_group" "opensearch-sg" {
  name        = "${local.id_gen}-opensearch-SG"
  description = "opensearch security group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
        Name = "${local.id_gen}-opensearch-SG"
    },
    local.common_tags) 
}

resource "aws_security_group_rule" "opensearch-sg-rules" {
  type              = "ingress"
  from_port         = var.db_ports["opensearch"]
  to_port           = var.db_ports["opensearch"]
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_Cidr]
  security_group_id = aws_security_group.opensearch-sg.id
}