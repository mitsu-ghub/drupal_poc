resource "random_password" "rds_password" {
  length           = 16
  numeric          = true
  upper            = true
  lower            = true
  min_upper        = 1

}

resource "random_password" "opensearch_password" {
  length           = 16
  numeric          = true
  special          = true
  upper            = true
  lower            = true
  min_upper        = 1
  min_special      = 1  
  override_special = "@"

}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}