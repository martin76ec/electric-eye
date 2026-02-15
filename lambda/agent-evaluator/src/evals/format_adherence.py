from src.evals.eval_interface import Eval
from src.evals.agent_response import AgentResponse
from src.providers.bedrock import llm
from ragas import SingleTurnSample
from ragas.metrics import SimpleCriteriaScore


class FormatAdherence(Eval):
    def __init__(self):
        super().__init__()
        self.name = "format_adherence"

    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        sample = SingleTurnSample(
            user_input=ground_truth.question,
            response=response.answer,
            reference=ground_truth.answer,
        )

        scorer = SimpleCriteriaScore(
            name="format_adherence",
            definition="Score 0 to 5 based on how the response adheres to the requested format",
            llm=llm,
        )

        return scorer.single_turn_score(sample)
