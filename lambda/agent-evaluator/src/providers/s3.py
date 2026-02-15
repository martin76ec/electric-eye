import boto3
from typing import Optional, Any


class S3Client:
    _instance: Optional["S3Client"] = None
    client: Any

    def __new__(cls) -> "S3Client":
        if cls._instance is not None:
            return cls._instance

        cls._instance = super(S3Client, cls).__new__(cls)

        cls._instance.client = boto3.client("s3")
        return cls._instance

    def get_client(self) -> Any:
        return self.client
