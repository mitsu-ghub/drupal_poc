resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "${local.eks_cluster_name}-ALBC-IAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy = data.http.lbc_iam_policy.response_body
}


# Resource: Create IAM Role 
resource "aws_iam_role" "lbc_iam_role" {
  name = "${local.eks_cluster_name}-ALBC-IAM-ROLE"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${local.oidc_connector}:aud": "sts.amazonaws.com",            
            "${local.oidc_connector}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }        
      },
    ]
  })

  tags = merge({
    Name = "${local.eks_cluster_name}-ALBC-IAM-ROLE"
  },
  local.common_tags
  )
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn 
  role       = aws_iam_role.lbc_iam_role.name
}

resource "helm_release" "loadbalancer_controller" {
  depends_on = [aws_iam_role.lbc_iam_role]            
  name       = "${var.environment}-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace = "kube-system"     

  set {
    name = "image.repository"
    value = "${var.Image_repo["${var.region}"]}/amazon/aws-load-balancer-controller" 
  }       

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.lbc_iam_role.arn}"
  }

  set {
    name  = "vpcId"
    value = "${aws_vpc.vpc.id}"
  }  

  set {
    name  = "region"
    value = "${var.region}"
  }    

  set {
    name  = "clusterName"
    value = "${local.eks_cluster_name}"
  }    
    
}

resource "kubernetes_ingress_class_v1" "ingress_class_default" {
  depends_on = [helm_release.loadbalancer_controller]
  metadata {
    name = "${var.environment}-ingress-class"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }  
  spec {
    controller = "ingress.k8s.aws/alb"
  }
}