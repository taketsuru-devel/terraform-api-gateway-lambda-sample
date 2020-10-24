variable "project_name" {
  description = "to name of resource"
}

variable "source_file" {
  description = "source path of lambda, single file"
}

variable "output_path" {
  description = "output path and filename of code of lambda, must be .zip"
}

variable "runtime" {
  description = "runtime name, e.g. python3.6"
}

variable "handler" {
  description = "entrypoint of source code, e.g. index.lambda_handler"
}
