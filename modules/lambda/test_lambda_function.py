import json
from hello_world.hello import say_hello

def lambda_handler(event, context):
    message = say_hello()
    return {
        'statusCode': 200,
        'body': json.dumps({'message': message})
    }