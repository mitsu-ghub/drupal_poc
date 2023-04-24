variable "region" {
    description = "AWS region were environment is hoted"
    type = string
    default = "ca-central-1"
}

variable "profile" {
    description = "AWS profile details"
    type = string
    default = "BORN"
  
}

variable "project" {
    description = "Name of the project"
    type = string
    default = "TechM"
  
}

variable "environment" {
    description = "Name of the Environment"
    type = string
    default = "dev"
  
}