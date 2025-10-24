@echo off
echo === VERIFICACAO RAPIDA ===
echo.

echo 1. Testando bucket original...
aws s3api get-object --bucket YOUR-BUCKET-NAME --key test.txt original.txt --region us-east-1 >nul 2>&1
if %errorlevel% equ 0 (
    echo OK: Bucket original funcionando
    type original.txt
) else (
    echo ERRO: Bucket original nao funciona
)

echo.
echo 2. Testando Object Lambda...
aws s3api get-object --bucket arn:aws:s3-object-lambda:us-east-1:YOUR-ACCOUNT-ID:accesspoint/YOUR-OBJECT-LAMBDA-AP --key test.txt transformado.txt --region us-east-1 >nul 2>&1
if %errorlevel% equ 0 (
    echo OK: Object Lambda funcionando!
    echo Conteudo transformado:
    type transformado.txt
    echo.
    echo === SUCESSO! PROJETO 100%% FUNCIONAL ===
) else (
    echo ERRO: Object Lambda nao funciona ainda
    echo Verificando logs...
    aws logs filter-log-events --log-group-name "/aws/lambda/TransformLambda" --start-time 1729740000000 --region us-east-1 --query "events[-2:].message" --output text
)

echo.
echo 3. Comparacao:
if exist original.txt if exist transformado.txt (
    echo Original: 
    type original.txt
    echo Transformado:
    type transformado.txt
)