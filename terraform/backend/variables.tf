variable "dynamodb_table" {
  description = "Name table to DynamoDB"
  default     = "terraform_stake_lock"

}

variable "state_backet" {
  description = "Name backet for S3"
  default     = "terraform-state-backet"
}