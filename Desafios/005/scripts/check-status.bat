@echo off
echo === STATUS DO PROJETO 005 ===
echo.

echo Verificando status da stack...
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --query "Stacks[0].StackStatus" --output text --region us-east-1 2>nul
if %errorlevel% neq 0 (
    echo Stack nao encontrada ou erro na consulta
    exit /b 1
)

echo.
echo Recursos criados:
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --query "Stacks[0].Outputs" --output table --region us-east-1 2>nul

echo.
echo Para testar apos CREATE_COMPLETE: test-simple.bat