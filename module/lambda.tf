resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"


  # The /*/*/* part allows invocation from any stage, method and resource path within API Gateway REST API.
  source_arn = format("%s/*/*/*", aws_api_gateway_rest_api.this.execution_arn)
}

data "archive_file" "source_code" {
  type        = "zip"
  #source_file = "./src/index.py"
  #output_path = "./dist/source.zip"
  source_file = var.source_file
  output_path = var.output_path
}

resource "aws_lambda_function" "this" {
  function_name    = format("%s-lambda", var.project_name)
  role             = aws_iam_role.this.arn
  runtime          = var.runtime
  handler          = var.handler
  timeout          = 10
  layers           = var.lambda_layers
  vpc_config {
    subnet_ids = var.lambda_subnet_ids
    security_group_ids = var.lambda_security_group_ids
  }
  filename         = data.archive_file.source_code.output_path
  source_code_hash = data.archive_file.source_code.output_base64sha256
}
