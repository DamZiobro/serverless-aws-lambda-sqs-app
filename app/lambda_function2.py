#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8


def lambda_handler(event, context):
    """
    Second Lambda function. Triggered by the SQS.
    :param event: AWS event data (this time will be the SQS's data)
    :param context: AWS function's context
    :return: ''
    """
    message = event.get('Records')[0].get('body')
    print(f"Received message: {message}")
    return message
