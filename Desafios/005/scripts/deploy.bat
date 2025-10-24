@echo off
echo === DEPLOY DO PROJETO 005: S3 Object Lambda ===
echo.

echo Fazendo deploy da stack CloudFormation...
echo Isso pode levar alguns minutos...
echo.

aws cloudformation create-stack ^
  --stack-name s3-object-lambda-demo ^
  --template-body file://template.yaml ^
  --capabilities CAPABILITY_NAMED_IAM ^
  --parameters ParameterKey=BaseBucketName,ParameterValue=meu-bucket-demo ^
               ParameterKey=LambdaName,ParameterValue=TransformLambda ^
  --region us-east-1

if %errorlevel% neq 0 (
    echo ERRO: Falha no deploy
    exit /b 1
)

echo.
echo Deploy iniciado com sucesso!
echo.
echo Para monitorar o progresso:
echo aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --query "Stacks[0].StackStatus" --region us-east-1
echo.
echo Para aguardar a conclusao:
echo aws cloudformation wait stack-create-complete --stack-name s3-object-lambda-demo --region us-east-1
echo.
echo Apos a conclusao, execute: test-simple.bat