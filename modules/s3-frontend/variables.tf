variable "s3_block_public_access" {
}

variable bucket_name {
  type        = string
  description = "S3 bucket storing static files for website"
}

variable bucket_acl {
  type        = string
  description = "Bucket ACL (Access Control Listing)"
}

variable versioning {
  type        = bool
  description = "Flag to determine whether bucket versioning is enabled or not"
}

variable "environment" {
  type        = string
  description = "Application enviroment"

}
variable "acm_cnd_certificate_arn" {}

variable "domain_aliase" {
}
