from src.evals.eval_interface import Eval
from src.evals.agent_response import AgentResponse
from src.providers.bedrock import llm
from ragas.metrics import SimpleCriteriaScore
from ragas import SingleTurnSample


class InstructionFollowing(Eval):
    def __init__(self):
        super().__init__()
        self.name = "instruction_following"

    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        sample = SingleTurnSample(
            user_input=ground_truth.question,
            response=response.answer,
            reference=ground_truth.answer,
        )

        scorer = SimpleCriteriaScore(
            name="instruction_following",
            definition="Score 0 to 5 by instruction following",
            llm=llm,
        )

        return scorer.single_turn_score(sample)
