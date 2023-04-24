resource "aws_db_subnet_group" "db-sng" {
  name       = lower("${local.id_gen}-db-subnet-group")
  subnet_ids = [for subnet in aws_subnet.private_subnets: subnet.id ]

  tags = merge({
    Name = "${local.eks_cluster_name}-DB-SG"
  },
  local.common_tags
  )
}

resource "aws_elasticache_subnet_group" "cache-sng" {
  name       = lower("${local.id_gen}-cache-subnet-group")
  subnet_ids = [for subnet in aws_subnet.private_subnets: subnet.id ]

  tags = merge({
    Name = "${local.eks_cluster_name}-Cache-SG"
  },
  local.common_tags
  )
}


resource "aws_db_instance" "rds" {
  allocated_storage    = var.rds_storage_alloc
  max_allocated_storage = var.rds_max_storage_alloc
  identifier           = var.rds_indentifier
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_type
  username             = var.rds_user_name
  password             = random_password.rds_password.result
  multi_az             = var.rds_multi_azs
  backup_retention_period = 3
  db_subnet_group_name = aws_db_subnet_group.db-sng.name
  port                 = var.db_ports["rds"]
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot  = true
  apply_immediately = true
  tags = merge({
    Name = "${local.eks_cluster_name}-DB-RDS"
  },
  local.common_tags
  )
}

resource "aws_db_instance" "rds-readreplica" {
  allocated_storage    = var.rds_storage_alloc
  max_allocated_storage = var.rds_max_storage_alloc
  replicate_source_db = aws_db_instance.rds.identifier
  identifier           = "${var.rds_indentifier}-read-replica"
  instance_class       = var.rds_instance_type
  multi_az             = var.rds_multi_azs
  backup_retention_period = 3
  port                 = var.db_ports["rds"]
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot  = true
  apply_immediately = true
  tags = merge({
    Name = "${local.eks_cluster_name}-DB-RDS-READ-Replica"
  },
  local.common_tags
  )
}

resource "aws_elasticache_cluster" "memchached" {
  cluster_id           = lower("${local.id_gen}-memcache")
  engine               = "memcached"
  node_type            = var.memcache_instance_type
  num_cache_nodes      = var.memcache_node_count
  parameter_group_name = "default.memcached1.6"
  port                 = var.db_ports["memcache"]
  engine_version       = var.memcache_engine_version
  subnet_group_name    = aws_elasticache_subnet_group.cache-sng.name
  security_group_ids   = [aws_security_group.memcache-sg.id]
  tags = merge({
    Name = "${local.eks_cluster_name}-memcache"
  },
  local.common_tags
  )
}
/*
resource "aws_elasticache_cluster" "elastiserch" {
  cluster_id           = lower("${local.id_gen}-elastiserch")
  engine               = "redis"
  node_type            = var.elastisearch_instance_type
  num_cache_nodes      = var.elastisearch_node_count
  parameter_group_name = "default.redis6.x"
  engine_version       = var.elastisearch_engine_version
  port                 = var.db_ports["redis"]
  subnet_group_name    = aws_elasticache_subnet_group.cache-sng.name
  security_group_ids   = [aws_security_group.elastisearch-sg.id]
  tags = merge({
    Name = "${local.eks_cluster_name}-elastisearch"
  },
  local.common_tags
  )
}
*/

resource "aws_opensearch_domain" "opensearch" {
  domain_name    = local.id_low
  engine_version = var.openserach_engine

  cluster_config {
    zone_awareness_enabled = true
    instance_count = var.opensearch_inst_count
    instance_type = var.opensearch_inst_type
  }
  ebs_options {
   ebs_enabled = true
   volume_size = var.opensearch_storage_size
   }
    node_to_node_encryption {
    enabled = true
  }
   encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
   advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
     master_user_options {
      master_user_name     = var.opensearch_user
      master_user_password = random_password.opensearch_password.result
    }
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.id_low}/*"
        }
    ]
}
CONFIG
  vpc_options{
  security_group_ids = [aws_security_group.opensearch-sg.id]
  subnet_ids = [for subnet in aws_subnet.private_subnets: subnet.id ]
  }

  tags = merge({
    Name = "${local.eks_cluster_name}-opensearch"
  },
  local.common_tags
  )
}
resource "kubernetes_service_v1" "rds" {
  metadata {
    name = "${var.environment}-mariadb"
  }
  spec {
    type = "ExternalName"
    external_name = aws_db_instance.rds.address
  }
}

resource "kubernetes_service_v1" "memcache" {
  metadata {
    name = "${var.environment}-memcache"
  }
  spec {
    type = "ExternalName"
    external_name = aws_elasticache_cluster.memchached.cluster_address
  }
}

/*
resource "kubernetes_service_v1" "elastisearch" {
  metadata {
    name = "${var.environment}-elastisearch"
  }
  spec {
    type = "ExternalName"
    external_name = aws_elasticache_cluster.elastiserch.cache_nodes[0].address
  }
}
*/

resource "kubernetes_service_v1" "opensearch" {
  metadata {
    name = "${var.environment}-opensearch"
  }
  spec {
    type = "ExternalName"
    external_name = aws_opensearch_domain.opensearch.endpoint
  }
}
