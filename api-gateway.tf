resource "aws_api_gateway_rest_api" "this" {
  name = "${var.project_name}-apigw"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

data "aws_api_gateway_resource" "root" {
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"
  path        = "/"
}

resource "aws_api_gateway_method" "any" {
  rest_api_id   = "${aws_api_gateway_rest_api.this.id}"
  resource_id   = "${data.aws_api_gateway_resource.root.id}"
  http_method   = "ANY"
  authorization = "NONE"
}
