import os


S3_DOCUMENT_BUCKET = os.getenv("S3_DOCUMENT_BUCKET", "")
DYNAMO_RESULTS_TABLE = os.getenv("DYNAMO_RESULTS_TABLE", "")
BEDROCK_LLM_ID = os.getenv("BEDROCK_LLM_ID", "")
BEDROCK_LLM_TEMPERATURE = (
    float(os.getenv("BEDROCK_LLM_TEMPERATURE", ""))
    if os.getenv("BEDROCK_LLM_TEMPERATURE")
    else 0.4
)
BEDROCK_EMBEDDING_ID = os.getenv("BEDROCK_EMBEDDING_ID", "")
AWS_REGION = os.getenv("AWS_REGION")

if S3_DOCUMENT_BUCKET == "":
    key = "S3_DOCUMENT_BUCKET"
    print(f"Warning: missing {key}")

if DYNAMO_RESULTS_TABLE == "":
    key = "DYNAMO_RESULTS_TABLE"
    print(f"Warning: missing {key}")

if BEDROCK_LLM_ID == "":
    key = "BEDROCK_LLM_ID"
    print(f"Warning: missing {key}")

if BEDROCK_EMBEDDING_ID == "":
    key = "BEDROCK_EMBEDDING_ID"
    print(f"Warning: missing {key}")
