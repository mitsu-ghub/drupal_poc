output "rds_hostname" {
    description = "RDS instance host name"
    value = aws_db_instance.rds.address 
}

output "rds_read_replica_hostname" {
    description = "RDS instance host name"
    value = aws_db_instance.rds.address 
}


output "rds_arn" {
    description = "RDS instance arn"
    value = aws_db_instance.rds.arn
}

output "rds_db_name" {
    description = "RDS DB_name"
    value = aws_db_instance.rds.db_name
}

output "rds_db_username" {
    description = "RDS DB_username"
    value = aws_db_instance.rds.username
}

output "rds_db_password" {
    description = "RDS DB_password"
    value = random_password.rds_password.result
    sensitive = true
}

output "rds_db_status" {
    description = "RDS DB_status"
    value = aws_db_instance.rds.status
}

output "rds_db_mutiaz" {
    description = "RDS DB_status"
    value = aws_db_instance.rds.multi_az
}

output "memcached_cluster_address" {
    description = "DNS name of memcached"
    value = aws_elasticache_cluster.memchached.cluster_address
  
}

output "memcached_cluster_arn" {
    description = "memcached cluster arn"
    value = aws_elasticache_cluster.memchached.arn
  
}

/*
output "elastisearch_cluster_address" {
    description = "DNS name of elastisearch"
    value = aws_elasticache_cluster.elastiserch.cache_nodes[0].address
  
}

output "elastisearch_cluster_arn" {
    description = "elastisearch cluster arn"
    value = aws_elasticache_cluster.elastiserch.arn
  
}
*/

output "opensearch_endpoint" {
  description = "Opensearch Endpoint"
  value = aws_opensearch_domain.opensearch.endpoint
}

output "opensearch_kibana_endpoint" {
  description = "Opensearch Kibana Endpoint"
  value = aws_opensearch_domain.opensearch.kibana_endpoint
}

output "opensearch_arn" {
  description = "Opensearch ARN"
  value = aws_opensearch_domain.opensearch.arn
}

output "opensearch_username" {
  description = "Opensearch ARN"
  value = var.opensearch_user
}

output "opensearch_password" {
  description = "Opensearch ARN"
  value = random_password.opensearch_password
  sensitive = true
}