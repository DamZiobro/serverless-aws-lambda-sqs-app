"""Test_lambda_function2."""

import unittest

from app import lambda_function2


class TestHelloModule(unittest.TestCase):
    """TestsHelloModules."""

    def test_lambda_function1_returns_success(self):
        """Check that lambda_function1 returns success."""
        test_message = "test_message_text"
        event = {"Records": [{"body": test_message}]}
        result = lambda_function2.lambda_handler(event, None)
        self.assertEqual(test_message, result)
