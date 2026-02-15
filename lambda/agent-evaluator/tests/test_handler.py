import os
import json
import unittest

os.environ["S3_DOCUMENT_BUCKET"] = "aws-native-evals"
os.environ["DYNAMO_RESULTS_TABLE"] = "dev_evaluation-results"
os.environ["BEDROCK_LLM_ID"] = "amazon.nova-micro-v1:0"
os.environ["BEDROCK_EMBEDDING_ID"] = "amazon.titan-embed-text-v2:0"
os.environ["AWS_REGION"] = "us-east-1"

from src.main import handler
from .mock_data import ground_1, ground_2, ground_3, ground_4


class TestHandler(unittest.TestCase):

    def test_case_1(self):
        event = {"Records": [ground_1.record]}
        response = handler(event, {})
        print(json.dumps(response, indent=4))

    def test_case_2(self):
        event = {"Records": [ground_2.record]}
        response = handler(event, {})
        print(json.dumps(response, indent=4))

    def test_case_3(self):
        event = {"Records": [ground_3.record]}
        response = handler(event, {})
        print(json.dumps(response, indent=4))

    def test_case_4(self):
        event = {"Records": [ground_4.record]}
        response = handler(event, {})
        print(json.dumps(response, indent=4))


if __name__ == "__main__":
    unittest.main()
