#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json

def lambda_handler(event, context):
    # event.queryStringParameters
    # event.body
    ret = {
        'isBase64Encoded': False,
        'statusCode': 200,
        'headers': {"Content-Type": "application/json", "Access-Control-Allow-Origin":"*"},
        'body': '{"message": "Hello from AWS Lambda"}'
    }
    return ret

if __name__ == "__main__":
    with open('./test.json', 'r') as f:
        lambda_handler(json.load(f), None)
