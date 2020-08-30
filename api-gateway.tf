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

