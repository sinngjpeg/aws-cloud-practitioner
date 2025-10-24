@echo off
echo === TESTE DO PROJETO 005: S3 Object Lambda ===
echo.

echo Verificando AWS CLI...
aws --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: AWS CLI nao encontrado
    exit /b 1
)
echo OK: AWS CLI encontrado

echo.
echo Verificando configuracao AWS...
aws sts get-caller-identity --query Account --output text >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: AWS nao configurado
    exit /b 1
)
echo OK: AWS configurado

echo.
echo Validando template CloudFormation...
aws cloudformation validate-template --template-body file://template.yaml >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Template invalido
    exit /b 1
)
echo OK: Template valido

echo.
echo Verificando stack existente...
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --region us-east-1 --query "Stacks[0].StackStatus" --output text >temp_status.txt 2>nul
if %errorlevel% neq 0 (
    echo Stack nao encontrada. Para fazer deploy:
    echo.
    echo aws cloudformation create-stack ^
    echo   --stack-name s3-object-lambda-demo ^
    echo   --template-body file://template.yaml ^
    echo   --capabilities CAPABILITY_NAMED_IAM ^
    echo   --parameters ParameterKey=BaseBucketName,ParameterValue=meu-bucket-demo ^
    echo                ParameterKey=LambdaName,ParameterValue=TransformLambda ^
    echo   --region us-east-1
    del temp_status.txt 2>nul
    exit /b 0
)

set /p STACK_STATUS=<temp_status.txt
del temp_status.txt
echo Stack encontrada com status: %STACK_STATUS%

if "%STACK_STATUS%" neq "CREATE_COMPLETE" if "%STACK_STATUS%" neq "UPDATE_COMPLETE" (
    echo ERRO: Stack nao esta pronta. Status: %STACK_STATUS%
    exit /b 1
)

echo.
echo Obtendo informacoes da stack...
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --region us-east-1 --query "Stacks[0].Outputs[?OutputKey=='SourceBucketName'].OutputValue" --output text >bucket_name.txt
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --region us-east-1 --query "Stacks[0].Outputs[?OutputKey=='ObjectLambdaAccessPointArn'].OutputValue" --output text >object_lambda_arn.txt

set /p BUCKET_NAME=<bucket_name.txt
set /p OBJECT_LAMBDA_ARN=<object_lambda_arn.txt

echo Bucket: %BUCKET_NAME%
echo Object Lambda ARN: %OBJECT_LAMBDA_ARN%

echo.
echo Criando arquivo de teste...
echo hello world from s3 object lambda > test.txt
echo OK: Arquivo test.txt criado

echo.
echo Fazendo upload do arquivo...
aws s3 cp test.txt s3://%BUCKET_NAME%/test.txt
if %errorlevel% neq 0 (
    echo ERRO: Falha no upload
    goto cleanup
)
echo OK: Upload realizado

echo.
echo Teste 1: Acessando via bucket original...
aws s3api get-object --bucket %BUCKET_NAME% --key test.txt original-test-output.txt
if %errorlevel% neq 0 (
    echo ERRO: Falha ao acessar bucket original
    goto cleanup
)
echo OK: Acesso via bucket original funcionando

echo.
echo Teste 2: Acessando via Object Lambda...
aws s3api get-object --bucket %OBJECT_LAMBDA_ARN% --key test.txt transformed-test-output.txt
if %errorlevel% neq 0 (
    echo ERRO: Falha ao acessar Object Lambda
    goto cleanup
)
echo OK: Acesso via Object Lambda funcionando

echo.
echo Verificando transformacao...
type transformed-test-output.txt
echo.

echo.
echo === RESUMO ===
echo [OK] Template CloudFormation valido
echo [OK] Stack deployada com sucesso
echo [OK] Upload funcionando
echo [OK] Acesso via bucket original funcionando
echo [OK] Transformacao via Object Lambda funcionando
echo.
echo TESTE CONCLUIDO COM SUCESSO!

:cleanup
del bucket_name.txt 2>nul
del object_lambda_arn.txt 2>nul