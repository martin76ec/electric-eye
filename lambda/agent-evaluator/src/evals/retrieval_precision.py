from typing import Any, List, cast
from src.evals.eval_interface import Eval
from src.evals.agent_response import AgentResponse
from ragas import SingleTurnSample
from ragas.metrics import IDBasedContextPrecision


class RetrievalPrecision(Eval):
    def __init__(self):
        super().__init__()
        self.name = "retrieval_precision"

    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        sample = SingleTurnSample(
            retrieved_context_ids=cast(List[Any], response.documents),
            reference_context_ids=cast(List[Any], ground_truth.documents),
        )

        id_precision = IDBasedContextPrecision()
        return id_precision.single_turn_score(sample)
