output "efs_csi_iam_role_arn" {
  description = "EFS CSI IAM Role ARN"
  value = aws_iam_role.efs_csi_iam_role.arn
}

output "efs_csi_iam_policy_arn" {
  value = aws_iam_policy.efs_csi_iam_policy.arn 
}

output "efs_file_system_id" {
  description = "EFS File System ID"
  value = aws_efs_file_system.efs_file_system.id 
}

output "efs_file_system_dns_name" {
  description = "EFS File System DNS Name"
  value = aws_efs_file_system.efs_file_system.dns_name
}

# EFS Mounts Info
output "efs_mount_target_id" {
  description = "EFS File System Mount Target ID"
  value = [for target in aws_efs_mount_target.efs_mount_target: target.id]
}

output "efs_mount_target_dns_name" {
  description = "EFS File System Mount Target DNS Name"
  value = [for target in aws_efs_mount_target.efs_mount_target: target.mount_target_dns_name] 
}

output "efs_mount_target_availability_zone_name" {
  description = "EFS File System Mount Target availability_zone_name"
  value = [for target in aws_efs_mount_target.efs_mount_target: target.availability_zone_name] 
}