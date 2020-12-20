variable "project_name" {
  description = "to name of resource"
}

variable "source_file" {
  description = "source path of lambda, single file"
}

variable "output_path" {
  description = "output path and filename of code of lambda, must be .zip"
}

variable "lambda_subnet_ids" {
  description = "array of subnet id for lambda"
  type = list(string)
  default = []
}

variable "lambda_security_group_ids" {
  description = "array of security group id for lambda"
  type = list(string)
  default = []
}

variable "addditional_policy_for_lambda_iam" {
  description = "array of policy_arn for lambda_iam"
  type = list(string)
  default = []
}

variable "runtime" {
  description = "runtime name, e.g. python3.6"
}

variable "handler" {
  description = "entrypoint of source code, e.g. index.lambda_handler"
}

variable "stage_name" {
  description = "deploy stage name, e.g. v1"
}

variable "logging_level" {
  description = "logging level, 'INFO' or 'ERROR'"
  type = string
  default = "ERROR"
}
variable "data_trace_enabled" {
  description = "logging all request/response, true or false"
  type = bool
  default = false
}
