variable "s3_bucket" {
  default = "terraform-static-site-s3"
  description = "The name of S3 bucket"
}
variable "dynamodb_table" {
  description = "Name table to DynamoDB"
  default     = "terraform_stake_lock"

}

variable "state_backet" {
  description = "Name backet for S3"
  default     = "terraform-state-backet"
}