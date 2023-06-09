output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive = true
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.version
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster."
  value       = aws_iam_role.eks_master_role.name 
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = aws_iam_role.eks_master_role.arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console."
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

# EKS Node Group Outputs - Public
/*
output "node_group_public_id" {
  description = "Public Node Group ID"
  value       = aws_eks_node_group.eks_ng_public.id
}

output "node_group_public_arn" {
  description = "Public Node Group ARN"
  value       = aws_eks_node_group.eks_ng_public.arn
}

output "node_group_public_status" {
  description = "Public Node Group status"
  value       = aws_eks_node_group.eks_ng_public.status 
}

output "node_group_public_version" {
  description = "Public Node Group Kubernetes Version"
  value       = aws_eks_node_group.eks_ng_public.version
}
*/
# EKS Node Group Outputs - Private

output "varnish_node_group_id" {
  description = "Varnish Node Group ID"
  value       = aws_eks_node_group.varnish_ng_private.id
}
output "varnish_node_group_arn" {
  description = "Varnish Node Group ARN"
  value       = aws_eks_node_group.varnish_ng_private.arn
}
output "varnish_node_group_status" {
  description = "Varnish Node Group status"
  value       = aws_eks_node_group.varnish_ng_private.status 
}
output "varnish_node_group_version" {
  description = "Varnish Node Group Kubernetes Version"
  value       = aws_eks_node_group.varnish_ng_private.version
}

output "drupal_node_group_id" {
  description = "Drupal Node Group ID"
  value       = aws_eks_node_group.varnish_ng_private.id
}
output "drupal_node_group_arn" {
  description = "Drupal Node Group ARN"
  value       = aws_eks_node_group.varnish_ng_private.arn
}
output "drupal_node_group_status" {
  description = "Drupal Node Group status"
  value       = aws_eks_node_group.varnish_ng_private.status 
}
output "drupal_node_group_version" {
  description = "Drupal Node Group Kubernetes Version"
  value       = aws_eks_node_group.varnish_ng_private.version
}
# EKS OIDC providers 
output "OIDC_connector_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value = aws_iam_openid_connect_provider.oidc_provider.arn 
}

output "OIDC_connector" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
   value = local.oidc_connector
}
