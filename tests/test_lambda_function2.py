#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8

import unittest

from app import lambda_function2

class TestHelloModule(unittest.TestCase):

    def test_lambda_function1_returns_success(self):
        test_message = "test_message_text"
        event = {'Records': [{"body": test_message}]}
        result = lambda_function2.lambda_handler(event, None)
        self.assertEqual(test_message, result)
