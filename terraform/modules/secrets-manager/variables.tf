variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_string" {
  description = "Secret value (JSON string)"
  type        = string
  sensitive   = true
}

variable "description" {
  description = "Secret description"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Days before permanent deletion"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to the secret"
  type        = map(string)
  default     = {}
}