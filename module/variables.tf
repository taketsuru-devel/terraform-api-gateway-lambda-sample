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

variable "runtime" {
  description = "runtime name, e.g. python3.6"
}

variable "handler" {
  description = "entrypoint of source code, e.g. index.lambda_handler"
}
