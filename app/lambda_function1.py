#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import os
import boto3


def lambda_handler(event, context):
    """
    First Lambda function. Triggered manually.
    :param event: AWS event data
    :param context: AWS function's context
    :return: ''
    """
    sqs = boto3.client('sqs')
    sqs_result = sqs.send_message(
        QueueUrl=os.getenv('SQS_URL'),
        MessageBody='test_message'
    )
    print(sqs_result)
    return sqs_result
