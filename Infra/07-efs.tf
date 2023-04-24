resource "aws_security_group" "efs-sg" {
  name        = lower("${local.id_gen}-efs")
  description = "Allow Inbound NFS Traffic from EKS VPC CIDR"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_Cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${local.eks_cluster_name}-EFS"
  },
  local.common_tags
  )
}

resource "aws_efs_file_system" "efs_file_system" {
  creation_token = lower("${local.id_gen}-efs-fs")
  tags = merge({
    Name = "${local.eks_cluster_name}-EFS-FS"
  },
  local.common_tags
  )
}


resource "aws_efs_mount_target" "efs_mount_target" {
  depends_on = [
    aws_subnet.private_subnets
  ]
  for_each = toset([for subnet in aws_subnet.private_subnets: subnet.id])
  file_system_id = aws_efs_file_system.efs_file_system.id
  subnet_id      = each.key
  security_groups = [ aws_security_group.efs-sg.id ]
}



resource "kubernetes_storage_class_v1" "efs_sc" {  
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"  
}

resource "kubernetes_persistent_volume_v1" "efs_pv" {
  metadata {
    name = "efs-pv" 
  }
  spec {
    capacity = {
      storage = "50Gi"
    }
    volume_mode = "Filesystem"
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = kubernetes_storage_class_v1.efs_sc.metadata[0].name    
    persistent_volume_source {
      csi {
      driver = "efs.csi.aws.com"
      volume_handle = aws_efs_file_system.efs_file_system.id
      }
    }
  } 
}