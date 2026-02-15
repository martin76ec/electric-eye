from ragas.llms import LangchainLLMWrapper
from ragas.embeddings import LangchainEmbeddingsWrapper
from langchain_aws import ChatBedrock, BedrockEmbeddings
from src.providers.envs import BEDROCK_EMBEDDING_ID, BEDROCK_LLM_ID, BEDROCK_LLM_TEMPERATURE


bedrock_model = ChatBedrock(
    model=BEDROCK_LLM_ID, model_kwargs={"temperature": BEDROCK_LLM_TEMPERATURE}
)

bedrock_embeddings_model = BedrockEmbeddings(model_id=BEDROCK_EMBEDDING_ID)

llm = LangchainLLMWrapper(bedrock_model)
embedding_model = LangchainEmbeddingsWrapper(bedrock_embeddings_model)
