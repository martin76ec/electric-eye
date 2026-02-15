from typing import List, Dict, Any


class AgentResponse:
    question: str
    answer: str
    documents: List[str]

    def __init__(self, data: Dict[str, Any]):
        self.question: str = data["question"]
        self.answer: str = data["answer"]
        self.documents: List[str] = data["documents"]
