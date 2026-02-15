import boto3
import os
from threading import Lock


class DynamoConnection:
    _instance = None
    _lock = Lock()

    @classmethod
    def get_client(cls):
        if cls._instance:
            return cls._instance

        with cls._lock:
            if cls._instance is None:
                cls._instance = boto3.client("dynamodb")

        return cls._instance
