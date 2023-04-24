variable "rds_engine" {
    description = "RDS Database Engine name"
    type = string
    default = "mariadb" 
}

variable "rds_engine_version" {
    description = "RDS Database Engine Version"
    type = string
    default = "10.6.8" 
}

variable "rds_instance_type" {
    description = "RDS instance type"
    type = string
    default = "db.t3.small"
  
}

variable "rds_multi_azs" {
    description = "To enable Mutiple AZ on RDS instance"
    type = bool
    default = true  
}

variable "rds_indentifier" {
    description = "DB Indentifier name in AWS_RDS"
    type = string
    default = "drupal" 
}

variable "rds_storage_alloc" {
    description = "Storage size of DB"
    type = string
    default = "20" 
}

variable "rds_max_storage_alloc" {
    description = "Storage size of DB"
    type = string
    default = "50" 
}

variable "rds_user_name" {
    description = "DB User name"
    type = string
    default = "drupal" 
}

variable "memcache_instance_type" {
    description = "Memchace instance type"
    type = string
    default = "cache.t2.medium"
  
}

variable "memcache_engine_version" {
    description = "Memchache Database Engine Version"
    type = string
    default = "1.6.12" 
}

variable "memcache_node_count" {
    description = "Memchache node count"
    type = string
    default = "1" 
}

variable "elastisearch_instance_type" {
    description = "Memchace instance type"
    type = string
    default = "cache.t2.medium"
  
}

variable "elastisearch_node_count" {
    description = "Memchache node count"
    type = string
    default = "1" 
}

variable "elastisearch_engine_version" {
    description = "Memchache Database Engine Version"
    type = string
    default = "6.2" 
}

variable "db_ports" {
    description = "DB ports need to be opened on security group"
    type = map(string)
    default = {
      "rds"      = "3306",
      "memcache" = "11211",
      "redis"    = "6379",
      "opensearch" = "443"
      
    }
  
}

variable "openserach_engine" {
    description = "Opensearch Engine version"
    type = string
    default = "Elasticsearch_7.1"
  
}

variable "opensearch_inst_count" {
    description = "Opensearch Instance count"
    type = string
    default = "2"  
}

variable "opensearch_inst_type" {
    description = "Opensearch Instance type"
    type = string
    default = "t3.medium.search"  
}

variable "opensearch_storage_size" {
    description = "Opensearch Instance Storage size"
    type = string
    default = "10"  
}

variable "opensearch_user" {
    description = "Opensearch Master user name"
    type = string
    default = "opensearch"  
}

