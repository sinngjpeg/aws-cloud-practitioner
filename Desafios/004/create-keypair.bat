@echo off
echo 🔑 Criando KeyPair para acesso SSH...

set AWS_CLI="[CAMINHO-DO-AWS-CLI]"  # Ex: "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

set /p KEYPAIR_NAME="Digite o nome para a KeyPair: "

echo.
echo 📝 Criando KeyPair '%KEYPAIR_NAME%'...
%AWS_CLI% ec2 create-key-pair --key-name %KEYPAIR_NAME% --query 'KeyMaterial' --output text --region [SUA-REGIAO] > %KEYPAIR_NAME%.pem

if %errorlevel% equ 0 (
    echo ✅ KeyPair criada com sucesso!
    echo 📁 Arquivo salvo: %KEYPAIR_NAME%.pem
    echo.
    echo ⚠️  IMPORTANTE:
    echo - Guarde este arquivo em local seguro
    echo - Use este nome no deploy: %KEYPAIR_NAME%
    echo - Para Linux/Mac: chmod 400 %KEYPAIR_NAME%.pem
) else (
    echo ❌ Erro ao criar KeyPair
)

pause