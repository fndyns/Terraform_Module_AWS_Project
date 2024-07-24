import json
import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    cloudwatch = boto3.client('cloudwatch')
    sns = boto3.client('sns')
    
    # Describe EC2 Instances
    response = ec2.describe_instances()
    
    # Extract instance details and generate billing report
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances.append({
                'InstanceId': instance['InstanceId'],
                'InstanceType': instance['InstanceType'],
                'State': instance['State']['Name']
            })
    
    # Generate report
    report = json.dumps(instances, indent=2)
    
    # Publish to SNS
    sns.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Subject='Billing Report',
        Message=report
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Billing report sent!')
    }
