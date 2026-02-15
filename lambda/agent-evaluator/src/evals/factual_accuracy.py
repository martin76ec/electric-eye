from typing import cast
from src.evals.eval_interface import Eval
from src.evals.agent_response import AgentResponse
from src.providers.bedrock import llm
from ragas import SingleTurnSample
from ragas.metrics._factual_correctness import FactualCorrectness
from numpy import float64


class FactualAccuracy(Eval):
    def __init__(self):
        super().__init__()
        self.name = "factual_accuracy"

    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        sample = SingleTurnSample(
            response=response.answer, reference=ground_truth.answer
        )

        scorer = FactualCorrectness(llm=llm)
        score = cast(float64, scorer.single_turn_score(sample))
        return score.item()
