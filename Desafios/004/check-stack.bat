@echo off
echo 🔍 Verificando status da stack...

set AWS_CLI="[CAMINHO-DO-AWS-CLI]"  # Ex: "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

echo 📊 Status da stack [NOME-DA-STACK]:
%AWS_CLI% cloudformation describe-stacks --stack-name [NOME-DA-STACK] --region [SUA-REGIAO] --query "Stacks[0].StackStatus" --output text

echo.
echo 📋 Outputs da stack:
%AWS_CLI% cloudformation describe-stacks --stack-name [NOME-DA-STACK] --region [SUA-REGIAO] --query "Stacks[0].Outputs" --output table

pause