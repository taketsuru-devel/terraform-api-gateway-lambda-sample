resource "aws_api_gateway_rest_api" "this" {
  name = format("%s-apigw", var.project_name)
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = "ap"
}

resource "aws_api_gateway_method" "any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.any.http_method

  # Lambda プロキシ統合
  type = "AWS_PROXY"

  # バックエンドアクセスの話をしているらしい
  # Lambda proxyの場合は実質POST固定
  integration_http_method = "POST"

  uri = aws_lambda_function.this.invoke_arn

}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = format("%s_deploy",var.stage_name)
}

resource "aws_api_gateway_stage" "this" {
  stage_name    = var.stage_name
  rest_api_id = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
}

resource "aws_api_gateway_account" "cw" {
  cloudwatch_role_arn = aws_iam_role.apigw_log.arn
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  #method_path = format("%s/%s", aws_api_gateway_resource.root.path_part, aws_api_gateway_method.any.http_method)
  method_path = "*/*"
  depends_on = [
    aws_api_gateway_account.cw,
  ]

  settings {
    metrics_enabled = false
    logging_level   = var.logging_level
    data_trace_enabled = var.data_trace_enabled
  }
}

