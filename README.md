# 環境
- amazon linux2
- terraform v0.13.0

# terraform勉強中
- api-gateway&lambdaのsnippet
- いわゆるlambda proxy
- 単一ソースファイルからのみの対応

# コマンド
- terraform init
- terraform plan
- terraform apply
- terraform destroy

# input
- project_name
- source_file
- output_path
- runtime
- handler
- stage_name
- logging_level
- deta_trace_enabled

# output
- 必要になったら考える

- 既存構成を参考にする場合
    - terraform import resource_type.resource_name aws_resoure_id(not arn)

# memo
- 何故か一発で成功しない
    - 初回はこんなエラーが出る
    - Error: Error creating API Gateway Deployment: BadRequestException: The REST API doesn't contain any methods 
- log_groupの名前は指定できないっぽい
    - API-Gateway-Execution-Logs_(apigwのリソース名:apigw生成時に発番される10桁英数字)

# todo
- cloudwatchとか
- コンソールで手動デプロイが必要
    - /v1とかでhttps://~.amazonaws.com/v1/apになる

# 必要に応じてコンソールからapiのデプロイ


### 以下昔から残ってたメモ

# lambdaを特定のvpc(subnet)で実行し、vpcピアリング接続をしたい場合
## 以下例はec2のデフォルトvpcに対しlambda->vpcの一方通行で満足しているので最小限だと思う
## 必要に応じてec2側のセキュリティグループにもlambdaを実行するサブネットのcidrを許可する


```
# ec2のvpc読み込み
data "aws_vpc" "ec2_vpc" {
  id = "vpc-of-ec2"
}

# ピアリング接続設定
resource "aws_vpc_peering_connection" "this_to_ec2" {
  peer_vpc_id = aws_vpc.this.id
  vpc_id = data.aws_vpc.ec2_vpc.id
  auto_accept = true
  tags = {
    Name = ...
  }
}

# lambdaを実行するサブネットのルートテーブル
# その他のvpc系リソース定義は省略
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = data.aws_vpc.ec2_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.this_to_ec2.id
  }
  tags = {
    Name = format("%s-rtb", var.project_name)
  }
}

# lambdaにvpc設定
resource "aws_lambda_function" "this" {
  ...
  vpc_config {
    subnet_ids = [aws_subnet.this.id]
    security_group_ids = [aws_security_group.this.id]
  }
}

# lambda実行権限に必要なpolicyを追加
resource "aws_iam_role_policy_attachment" "vpc_policy_attach" {
  role = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

```
