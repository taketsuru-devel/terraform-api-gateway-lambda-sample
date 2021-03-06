terraform {
  backend "s3" {
    bucket = "terraform-tfstate-s3"
    region = "ap-northeast-1"
    key = "api-gateway-lambda-sample"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  profile = "default"
}

module "apigw-lambda" {
  source = "../module/"

  project_name = "api-gateway-lambda-sample"
  source_file = "src/index.py"
  output_path = "dist/lambda.zip"
  runtime = "python3.6"
  handler = "index.lambda_handler"
  # addditional_policy_for_lambda_iam = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
  stage_name = "v1"
}
