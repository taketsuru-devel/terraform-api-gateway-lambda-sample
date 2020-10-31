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
}
