"""Test_lambda_function1."""

import unittest
from unittest.mock import patch

from app import lambda_function1


class TestHelloModule(unittest.TestCase):
    """Tests of HelloModule."""

    @patch("boto3.client")
    def test_lambda_function1_returns_success(self, sqs_mock):
        """Tests of lambda_function1."""
        _ = lambda_function1.lambda_handler("test", None)
        sqs_mock.assert_called_once()
