region = "us-west-1"
project = "techm"
environment = "dev"
vpc_Cidr = "10.1.0.0/16"
bastion-instance-type = "t2.micro"
varnish_instance_type = "r4.large"
varnish_desired_instance_count = "1"
varnish_max_instance_count = "1"
varnish_min_instance_count = "1"
drupal_instance_type = "t3.large"
drupal_desired_instance_count = "1"
drupal_max_instance_count = "1"
drupal_min_instance_count = "1"
cluster_version = "1.23"
cluster_endpoint_private_access = true
cluster_endpoint_public_access = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0","182.72.157.210/32"]
rds_engine = "mariadb"
rds_engine_version = "10.6.8"
rds_instance_type = "db.t3.small"
rds_multi_azs = "false"
rds_storage_alloc = "20"
rds_max_storage_alloc = "50"
rds_user_name = "drupal"
memcache_instance_type = "cache.t2.medium"
memcache_engine_version = "1.6.12"
memcache_node_count = "1"
elastisearch_instance_type = "cache.t2.medium"
elastisearch_node_count = "1"
elastisearch_engine_version = "6.2"








