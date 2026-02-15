import os

os.environ["S3_DOCUMENT_BUCKET"] = "aws-native-evals"

import unittest
from src.evals.agent_response import AgentResponse
from .mock_data import ground_1
from src.evals.context_relevance import ContextRelevance


class TestContextRelevance(unittest.TestCase):

    def test(self):
        ground_truth = AgentResponse(ground_1.ground_truth)
        agent_response = AgentResponse(ground_1.agent_response)
        context_relevance = ContextRelevance()

        result = context_relevance.run(ground_truth, agent_response)
        print(f"{context_relevance.name}: {result}")


if __name__ == "__main__":
    unittest.main()
