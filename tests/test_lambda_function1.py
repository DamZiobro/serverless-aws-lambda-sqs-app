#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import unittest
from unittest.mock import patch, MagicMock

from app import lambda_function1

class TestHelloModule(unittest.TestCase):

    @patch("boto3.client")
    def test_lambda_function1_returns_success(self, sqs_mock):
        result = lambda_function1.lambda_handler("test", None)
        sqs_mock.assert_called_once()
