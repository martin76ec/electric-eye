from abc import ABC, abstractmethod
from src.evals.agent_response import AgentResponse


class Eval(ABC):
    name: str

    def __init__(self):
        self.name = "none"
        pass

    @abstractmethod
    def run(self, ground_truth: AgentResponse, response: AgentResponse) -> float:
        pass
