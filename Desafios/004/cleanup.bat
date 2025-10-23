@echo off
echo 🧹 Removendo Sistema de Monitoramento...

set AWS_CLI="[CAMINHO-DO-AWS-CLI]"  # Ex: "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

echo ⚠️  Isso irá remover TODOS os recursos criados:
echo - Instância EC2
echo - Security Group
echo - Tópico SNS
echo - Alarme CloudWatch
echo.
set /p CONFIRM="Tem certeza? (S/N): "

if /i "%CONFIRM%"=="S" (
    echo.
    echo 🗑️  Deletando stack...
    %AWS_CLI% cloudformation delete-stack --stack-name [NOME-DA-STACK] --region [SUA-REGIAO]
    
    echo ⏳ Aguardando exclusão completa...
    %AWS_CLI% cloudformation wait stack-delete-complete --stack-name [NOME-DA-STACK] --region [SUA-REGIAO]
    
    echo ✅ Todos os recursos foram removidos com sucesso!
) else (
    echo ❌ Operação cancelada.
)

pause