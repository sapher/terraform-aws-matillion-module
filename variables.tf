variable "profile" {
  type        = string
  default     = "default"
  description = "AWS profile"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "instance_type" {
  type        = string
  default     = "m5.large"
  description = "Matillion instance type"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs"
}

variable "whitelist_ips" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Whitelisted IPs"
}

variable "matillion_sg_ids" {
  type        = list(string)
  default     = []
  description = "Matillion instance security groups"
}

variable "matillion_log_group" {
  type        = string
  default     = "/matillion"
  description = "Matillion instance log group"
}
