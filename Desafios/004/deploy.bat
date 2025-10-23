@echo off
echo 🚀 Deploy do Sistema de Monitoramento EC2...

set AWS_CLI="[CAMINHO-DO-AWS-CLI]"  # Ex: "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

REM Solicitar parâmetros do usuário
set /p EMAIL="Digite seu email para receber alertas: "
set /p KEYPAIR="Digite o nome da sua KeyPair (sem .pem): "

echo.
echo 📦 Fazendo deploy da stack...
%AWS_CLI% cloudformation deploy ^
  --template-file template.yaml ^
  --stack-name [NOME-DA-STACK]  # Ex: ec2-monitoring ^
  --parameter-overrides EmailAddress=%EMAIL% KeyPairName=%KEYPAIR% ^
  --region [SUA-REGIAO]  # Ex: us-east-1, sa-east-1, eu-west-1

if %errorlevel% equ 0 (
    echo.
    echo ✅ Deploy concluído com sucesso!
    echo.
    echo 📧 IMPORTANTE: Verifique seu email e confirme a inscrição no SNS
    echo.
    echo 📊 Informações da infraestrutura:
    %AWS_CLI% cloudformation describe-stacks --stack-name [NOME-DA-STACK] --query "Stacks[0].Outputs" --output table --region [SUA-REGIAO]
    echo.
    echo 🔧 Próximos passos:
    echo 1. Confirme a inscrição no email recebido
    echo 2. Execute: test-cpu.bat para testar o alarme
    echo 3. Ou conecte via SSH e execute: ./test-cpu.sh
) else (
    echo.
    echo ❌ Erro no deploy. Verificando detalhes...
    %AWS_CLI% cloudformation describe-stack-events --stack-name [NOME-DA-STACK] --region [SUA-REGIAO] --query "StackEvents[?ResourceStatus=='CREATE_FAILED'].[LogicalResourceId,ResourceStatusReason]" --output table
)

pause