from src.evals.eval_interface import Eval
from src.evals.agent_response import AgentResponse
from src.providers.bedrock import embedding_model
from ragas import SingleTurnSample
from ragas.metrics import SemanticSimilarity as SemanticSimilarityRagas


class SemanticSimilarity(Eval):
    def __init__(self):
        super().__init__()
        self.name = "semantic_similarity"

    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        sample = SingleTurnSample(
            response=response.answer, reference=ground_truth.answer
        )

        scorer = SemanticSimilarityRagas(embeddings=embedding_model)
        return scorer.single_turn_score(sample)
