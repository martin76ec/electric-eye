from typing import List
from src.evals.agent_response import AgentResponse
from src.evals.eval_interface import Eval


class EvalChain:
    evals: List[Eval]
    ground_truth: AgentResponse
    response: AgentResponse

    def __init__(self, ground_truth: AgentResponse, response: AgentResponse):
        self.evals = []
        self.ground_truth = ground_truth
        self.response = response

    def eval_add(self, eval: Eval):
        self.evals.append(eval)

    def run(self):
        results = {}

        for e in self.evals:
            try:
                score = e.run(self.ground_truth, self.response)
                results[e.name] = round(score, 2)
            except Exception as ex:
                print(f"Evaluation '{e.name}' failed with exception: {ex}")
                results[e.name] = 0

        return results
