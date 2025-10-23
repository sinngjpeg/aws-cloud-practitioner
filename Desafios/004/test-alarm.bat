@echo off
echo 🧪 Testando alarme manualmente...

set AWS_CLI="[CAMINHO-DO-AWS-CLI]"  # Ex: "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

echo 🚨 Forçando estado de alarme para teste...
%AWS_CLI% cloudwatch set-alarm-state ^
  --alarm-name "[NOME-DO-ALARME]" ^
  --state-value ALARM ^
  --state-reason "Teste manual do sistema de alertas" ^
  --region [SUA-REGIAO]

if %errorlevel% equ 0 (
    echo ✅ Alarme ativado manualmente!
    echo 📧 Você deve receber um email em alguns segundos
    echo.
    echo 🔄 Aguarde 30 segundos e depois restaure o estado:
    timeout /t 30 /nobreak
    
    echo 🔄 Restaurando estado normal...
    %AWS_CLI% cloudwatch set-alarm-state ^
      --alarm-name "[NOME-DO-ALARME]" ^
      --state-value OK ^
      --state-reason "Teste finalizado" ^
      --region [SUA-REGIAO]
    
    echo ✅ Estado restaurado para OK
) else (
    echo ❌ Erro ao ativar alarme
)

pause