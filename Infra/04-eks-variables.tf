variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "eks-cluster"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (for example 1.21)"
  type = string
  default     = "1.22"
}
variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. When it's set to `false` ensure to have a proper private access with `cluster_endpoint_private_access = true`."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["182.72.157.210/32","0.0.0.0/0"]
}

variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

variable "varnish_instance_type" {
    description = "Instance type for EKS worker nodes"
    type = string
    default = "r4.large"   
}

variable "varnish_desired_instance_count" {
    description = "Desired number of instance on EKS Node-group"
    type = string
    default = "1"  
}

variable "varnish_min_instance_count" {
    description = "Desired number of instance on EKS Node-group"
    type = string
    default = "1"  
}

variable "varnish_max_instance_count" {
    description = "Desired number of instance on EKS Node-group"
    type = string
    default = "2"  
}

variable "drupal_instance_type" {
    description = "Instance type for EKS worker nodes"
    type = string
    default = "t3a.medium"   
}

variable "drupal_desired_instance_count" {
    description = "Desired number of instance on EKS Node-group"
    type = string
    default = "1"  
}

variable "drupal_min_instance_count" {
    description = "Desired number of instance on EKS Node-group"
    type = string
    default = "1"  
}

variable "drupal_max_instance_count" {
    description = "Desired number of instance on EKS Node-group"
    type = string
    default = "2"  
}

variable "drupal_port_sg" {
    description = "Port required to be opened for Bastion servers"
    type = list(string)
    default = [ "22","3306","11211","2049","6379" ]
   
}