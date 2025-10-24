# Diretrizes de Segurança

## 🔒 Notas Importantes de Segurança

### Antes de Usar Este Projeto

1. **Substitua os Placeholders**: Este repositório contém valores de placeholder que devem ser substituídos pelos seus recursos AWS reais:
   - `SEU-NOME-DO-BUCKET` - Substitua pelo nome do seu bucket S3
   - `SUA-CONTA-ID` - Substitua pelo ID da sua conta AWS
   - `SEU-OBJECT-LAMBDA-AP` - Substitua pelo nome do seu Object Lambda Access Point

2. **Nunca Faça Commit de Dados Sensíveis**: 
   - IDs de conta AWS
   - Nomes de buckets (se contiverem informações sensíveis)
   - Chaves de acesso ou credenciais
   - Nomes de recursos específicos da empresa ou pessoais

### Configuração Automatizada

Use o script fornecido para obter os nomes reais dos seus recursos:
```bash
scripts/setup-variables.bat
```

### Configuração Manual

Após o deploy, obtenha os nomes dos seus recursos a partir dos outputs do CloudFormation:
```bash
aws cloudformation describe-stacks \
  --stack-name s3-object-lambda-demo \
  --query "Stacks[0].Outputs" \
  --region us-east-1
```

### Melhores Práticas

- ✅ Use roles IAM com permissões mínimas necessárias
- ✅ Habilite CloudTrail para logs de auditoria
- ✅ Use nomes únicos para buckets
- ✅ Teste em ambiente de desenvolvimento primeiro
- ✅ Revise todo o código antes do deploy
- ❌ Nunca codifique credenciais diretamente no código fonte
- ❌ Não use dados de produção para testes
- ❌ Evite políticas IAM excessivamente permissivas

### Reportando Problemas de Segurança

Se você encontrar vulnerabilidades de segurança neste projeto, por favor reporte-as de forma responsável criando uma issue no repositório.