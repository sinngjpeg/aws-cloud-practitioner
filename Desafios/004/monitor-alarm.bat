@echo off
echo 📊 Monitorando alarme em tempo real...

set AWS_CLI="[CAMINHO-DO-AWS-CLI]"  # Ex: "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

REM Obter ID da instância
for /f "tokens=*" %%i in ('%AWS_CLI% cloudformation describe-stacks --stack-name [NOME-DA-STACK] --query "Stacks[0].Outputs[?OutputKey==`InstanceId`].OutputValue" --output text --region [SUA-REGIAO]') do set INSTANCE_ID=%%i

:loop
cls
echo 🚨 Status do Alarme CloudWatch:
echo ================================

%AWS_CLI% cloudwatch describe-alarms --alarm-names "[NOME-DO-ALARME]" --region [SUA-REGIAO] --query "MetricAlarms[0].[StateValue,StateReason]" --output table

echo.
echo 🔎 Instância: %INSTANCE_ID%
echo.
echo 📈 Última métrica de CPU:
if not "%INSTANCE_ID%"=="" (
    %AWS_CLI% cloudwatch get-metric-statistics ^
      --namespace AWS/EC2 ^
      --metric-name CPUUtilization ^
      --dimensions Name=InstanceId,Value=%INSTANCE_ID% ^
      --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ) ^
      --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) ^
      --period 300 ^
      --statistics Average ^
      --region [SUA-REGIAO] ^
      --query "Datapoints[-1].[Timestamp,Average]" ^
      --output table
) else (
    echo ❌ Não foi possível obter ID da instância
)

echo.
echo 🔄 Atualizando em 30 segundos... (Ctrl+C para sair)
timeout /t 30 /nobreak >nul
goto loop