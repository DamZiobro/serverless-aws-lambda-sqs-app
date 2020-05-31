#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2020 damian <damian@damian-desktop>
#
# Distributed under terms of the MIT license.

import os
import boto3

sqs = boto3.client('sqs')


def lambda_handler(event, context):
    """
    First Lambda function. Triggered manually.
    :param event: AWS event data
    :param context: AWS function's context
    :return: ''
    """
    print(sqs.send_message(
        QueueUrl=os.getenv('SQS_URL'),
        MessageBody='test_message'
    ))
    return ''
