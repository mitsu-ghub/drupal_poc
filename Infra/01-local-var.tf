locals {
  id_gen = "${var.project}-${var.environment}"
  id_low = lower("${local.id_gen}-openserch")
  az_names = data.aws_availability_zones.az.names
  eks_cluster_name = "${local.id_gen}-${var.cluster_name}"
  oidc_connector = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)

  common_tags = {
    Owner = "${var.project}"
    Environment = "${var.environment}"
    Deployed = "terraform"
  }

}