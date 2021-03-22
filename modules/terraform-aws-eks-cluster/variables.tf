# EKS Cluster
variable "cluster_name" {
  description = "Name of the EKS cluster"

  type = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes that will be deployed on top of EKS"

  type = string
}

variable "ingress_443_cidrs" {
  description = "CIDRs for 443 tcp ingress rule"

  default = ["10.0.0.0/8"]

  type = list(string)
}

# OIDC
variable "thumbprint" {
  description = "Server certificate thumbprint for the OpenID Connect (OIDC) identity provider's server certificate(s)"

  default = "123default456"
  type    = string
}

# VPC/Subnets
variable "subnet_ids" {
  description = "List of subnet IDs that will be attached to EKS cluster"

  type = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC in which EKS will be deployed"

  type = string
}

variable "endpoint_private_access" {
  description = "Enable private access"

  default = true
  type    = bool
}

variable "endpoint_public_access" {
  description = "Enable public access"

  default = false
  type    = bool
}

variable "additional_tags" {
  description = "Additional tags for resources"

  default = {}
  type    = map(string)
}

variable "application" {
  description = "Workload running on the EKS cluster"

  default = ""
  type    = string
}

variable "bounded_context" {
  description = "Bounded context of the EKS cluster"

  default = ""
  type    = string
}

variable "cost_center" {
  description = "Cost center of the EKS cluster"

  default = ""
  type    = string
}

variable "data_class" {
  description = "Data class of the EKS cluster"

  default = ""
  type    = string
}

variable "environment" {
  description = "Name of the environment"

  default = ""
  type    = string
}

variable "owner" {
  description = "Name of the team responsible for these resources"

  default = "application-foundation"
  type    = string
}

variable "site" {
  description = "site of the EKS cluster"

  default = "secondary"
  type    = string
}
