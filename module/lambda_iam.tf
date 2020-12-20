data "aws_iam_policy_document" "lambda_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "this" {
  name = format("%s-lambda-role", var.project_name)

  assume_role_policy = data.aws_iam_policy_document.lambda_role.json 
}

resource "aws_iam_role_policy_attachment" "vpc_policy_attach" {
  count = length(var.addditional_policy_for_lambda_iam)
  role = aws_iam_role.this.name
  policy_arn = element(var.addditional_policy_for_lambda_iam, count.index)
}

data "aws_iam_policy_document" "apigw_log" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "apigw_log" {
  name = format("%s-apigw-log-role", var.project_name)

  assume_role_policy = data.aws_iam_policy_document.apigw_log.json 
}

resource "aws_iam_role_policy_attachment" "apigw_log" {
  role       = aws_iam_role.apigw_log.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

