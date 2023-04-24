resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${local.eks_cluster_name}-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-Autoscaling-Full-Access" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.eks_nodegroup_role.name
}


resource "aws_eks_node_group" "varnish_ng_private" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.eks_cluster_name}-varnish-ng"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [for subnet in aws_subnet.private_subnets: subnet.id ]
  version = var.cluster_version   
  
  ami_type = "AL2_x86_64"  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = [var.varnish_instance_type]
  
  
  remote_access {
    ec2_ssh_key = aws_key_pair.terraform-key.key_name   
  }
  scaling_config {
    desired_size = var.varnish_desired_instance_count
    min_size     = var.varnish_min_instance_count
    max_size     = var.varnish_max_instance_count
  }
  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    #max_unavailable = 1    
    max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  taint {
    key = "app"
    value = "varnish"
    effect = "NO_SCHEDULE"

  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-Autoscaling-Full-Access,
  ]  
  tags = merge({
    Name = "${local.eks_cluster_name}-Varnish-NG"
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "TRUE"
  },
  local.common_tags
  )
}

resource "aws_eks_node_group" "drupal_ng_private" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.eks_cluster_name}-drupal-ng"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [for subnet in aws_subnet.private_subnets: subnet.id ]
  version = var.cluster_version 
  
  ami_type = "AL2_x86_64"  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = [var.drupal_instance_type]
  
  
  remote_access {
    ec2_ssh_key = aws_key_pair.terraform-key.key_name 
    source_security_group_ids = [aws_security_group.drupal-ng-sg.id]  
  }

  
  scaling_config {
    desired_size = var.drupal_desired_instance_count
    min_size     = var.drupal_min_instance_count
    max_size     = var.drupal_max_instance_count
  }
  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    #max_unavailable = 1    
    max_unavailable_percentage = 50    # ANY ONE TO USE
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-Autoscaling-Full-Access,
  ]  
  tags = merge({
    Name = "${local.eks_cluster_name}-Drupal-NG"
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "TRUE"
  },
  local.common_tags
  )
}