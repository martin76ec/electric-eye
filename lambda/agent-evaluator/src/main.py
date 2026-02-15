from typing import Any, List, Dict, Tuple
from src.providers.utils import json_safeload
from src.evals.context_recall import ContextRecall
from src.evals.eval_chain import EvalChain
from src.evals.agent_response import AgentResponse
from src.evals.retrieval_precision import RetrievalPrecision
from src.evals.retrieval_recall import RetrievalRecall
from src.evals.context_relevance import ContextRelevance
from src.evals.factual_accuracy import FactualAccuracy
from src.evals.instruction_following import InstructionFollowing
from src.evals.format_adherence import FormatAdherence
from src.evals.semantic_similarity import SemanticSimilarity
from src.evals.eval_interface import Eval
from src.providers.dynamo import DynamoConnection
from src.providers.envs import DYNAMO_RESULTS_TABLE
import json


dynamo_client = DynamoConnection().get_client()


def handler(event, _):
    data = handle_sqs_event(event)
    [ground_truth, response, data_id] = data_extract(data)

    evals = evals_setup()
    chain = chain_build(ground_truth, response, evals)

    scores = chain.run()
    dynamo_insert(data_id, scores)

    return scores


def handle_sqs_event(event: Any) -> Dict[str, Any]:
    record = event.get("Records", [])[0]
    body = json.loads(record.get("body", ""))
    dynaevent = body.get("dynamodb", {})
    image = dynaevent.get("NewImage", {})
    return image


def data_extract(data: Dict[str, Any]) -> Tuple[AgentResponse, AgentResponse, str]:
    ground_truth = AgentResponse(json_safeload(data["ground_truth"]["S"]))
    response = AgentResponse(json_safeload(data["response"]["S"]))
    data_id = data["id"]["S"]
    return ground_truth, response, data_id


def chain_build(
    ground_truth: AgentResponse, response: AgentResponse, evals: List[Eval]
) -> EvalChain:
    chain = EvalChain(ground_truth, response)
    for e in evals:
        chain.eval_add(e)

    return chain


def dynamo_insert(id: str, scores: Dict[str, Any]):
    dynamo_client.put_item(
        TableName=DYNAMO_RESULTS_TABLE,
        Item={"id": {"S": id}, "score": {"S": json.dumps(scores)}},
    )


def evals_setup() -> List[Eval]:
    return [
        RetrievalPrecision(),
        RetrievalRecall(),
        ContextRelevance(),
        ContextRecall(),
        InstructionFollowing(),
        FormatAdherence(),
        FactualAccuracy(),
        SemanticSimilarity(),
    ]

