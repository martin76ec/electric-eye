from typing import List
from src.evals.eval_interface import Eval
from src.evals.agent_response import AgentResponse
from src.providers.s3 import S3Client
from src.providers.envs import S3_DOCUMENT_BUCKET
from src.providers.bedrock import llm
from ragas.metrics import LLMContextPrecisionWithoutReference
from ragas import SingleTurnSample
import os


class ContextRelevance(Eval):
    def __init__(self):
        super().__init__()
        self.name = "context_relevance"

    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        context_precision = LLMContextPrecisionWithoutReference(llm=llm)
        documents_content = self.documents_read(response.documents)
        sample = SingleTurnSample(
            user_input=ground_truth.question,
            response=response.answer,
            retrieved_contexts=documents_content,
        )

        return context_precision.single_turn_score(sample)

    def documents_read(self, docs: List[str]):
        return [self.document_content_get(doc) for doc in docs]

    def document_content_get(self, doc: str):
        _, ext = os.path.splitext(doc)
        ext = ext.lower()

        if ext not in [".txt", ".md"]:
            print(f"Warning: Unsupported file type '{ext}' for S3 document: {doc}.")
            return ""

        s3_client = S3Client().get_client()
        response = s3_client.get_object(Bucket=S3_DOCUMENT_BUCKET, Key=doc)
        content_bytes = response["Body"].read()

        return content_bytes.decode("utf-8")
