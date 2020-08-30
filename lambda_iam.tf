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
  name = "${var.project_name}-lambda-role"

  assume_role_policy = "${data.aws_iam_policy_document.lambda_role.json}" 
}
