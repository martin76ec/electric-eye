import boto3
import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')
sqs_client = boto3.client('sqs')

S3_BUCKET_NAME = os.environ.get('S3_BUCKET_NAME')
QUEUE_URL = os.environ.get('EVALUATION_QUEUE_URL')

def handler(event, _):
    if not S3_BUCKET_NAME:
        logger.error("Missing environment variables: S3_BUCKET_NAME")
        return {'statusCode': 500, 'body': 'Configuration error'}
    if not QUEUE_URL:
        logger.error("QUEUE_URL environment variable is not set.")
        return {
            'statusCode': 500,
            'body': json.dumps('Configuration error: SQS Queue URL missing.')
        }

    logger.info(f"Processing {len(event['Records'])} records.")
    records_process(event["Records"]) 

    return {
        'statusCode': 200,
        'body': json.dumps(f"Successfully processed {len(event['Records'])} records.")
    }

def records_process(records):
    for record in records:
        if record['eventName'] not in ['INSERT']:
            logger.info(f"Skipping event of type: {record['eventName']}")
            continue

        try:
            record_s3 = record_create_s3(record)
            evaluation_queue_send(record_s3)
        except KeyError as e:
            logger.error(f"Record is missing expected key: {e}. Record: {record}")
        except json.JSONDecodeError as e:
            logger.error(f"Failed to parse groundtruth JSON for item ID {record}: {e}")
        except Exception as e:
            logger.error(f"An error occurred processing record {record.get('dynamodb', {}).get('Keys')}: {e}")

def record_create_s3(record):
    data = record['dynamodb']['NewImage']

    item_id = data['id']['S']
    s3_key = f"{item_id}.json"

    groundtruth_json = json.loads(data['groundtruth']['S'])
    s3_client.put_object(
        Bucket=S3_BUCKET_NAME,
        Key=s3_key,
        Body=json.dumps(groundtruth_json, indent=4),
        ContentType='application/json'
    )

    logger.info(f"Successfully saved {s3_key} to bucket {S3_BUCKET_NAME}.")
    return {
        "id": item_id,
        "object_arn": f"arn:aws:s3:::{S3_BUCKET_NAME}/{s3_key}",
        "groundtruth": groundtruth_json
    }

def evaluation_queue_send(record):
    response = sqs_client.send_message(
        QueueUrl=QUEUE_URL,
        MessageBody=json.dumps(record)
    )

    logger.info(f"Message sent to SQS: {response['MessageId']}")
