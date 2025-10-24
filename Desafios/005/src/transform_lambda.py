import boto3

def lambda_handler(event, context):
    s3_client = boto3.client('s3')
    
    # Extrair informações do evento
    get_context = event['getObjectContext']
    route = get_context['outputRoute']
    token = get_context['outputToken']
    
    # Extrair informações da requisição original
    user_request = event['userRequest']
    
    # Obter bucket e key da configuração do Object Lambda
    key = user_request['url'].split('/')[-1].split('?')[0]
    bucket_name = 'YOUR-BUCKET-NAME'  # Replace with actual bucket name from CloudFormation output
    
    try:
        # Fazer requisição para o objeto original
        response = s3_client.get_object(
            Bucket=bucket_name,
            Key=key
        )
        
        original_content = response['Body'].read()
        
        # Transformar para maiúsculas
        try:
            text_content = original_content.decode('utf-8')
            transformed_content = text_content.upper()
            transformed_bytes = transformed_content.encode('utf-8')
        except UnicodeDecodeError:
            transformed_bytes = original_content
        
        # Retornar conteúdo transformado
        s3_client.write_get_object_response(
            RequestRoute=route,
            RequestToken=token,
            Body=transformed_bytes
        )
        
        return {'statusCode': 200}
        
    except Exception as e:
        s3_client.write_get_object_response(
            RequestRoute=route,
            RequestToken=token,
            StatusCode=500,
            ErrorCode='InternalError',
            ErrorMessage=str(e)
        )
        
        return {'statusCode': 500}