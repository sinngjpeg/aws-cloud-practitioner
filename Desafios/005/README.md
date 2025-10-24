# AWS S3 Object Lambda - Transformação de Texto em Tempo Real

Transforme objetos S3 em tempo real sem modificar os dados originais usando AWS S3 Object Lambda Access Points.

## 🎯 O que Este Projeto Faz

Este projeto demonstra como usar **AWS S3 Object Lambda** para transformar arquivos de texto em maiúsculas em tempo real quando acessados através de um access point especial, mantendo os arquivos originais inalterados no S3.

### Principais Funcionalidades

- ✅ **Transformação em tempo real** - Converte texto para maiúsculas instantaneamente
- ✅ **Dados originais preservados** - Arquivos fonte permanecem intocados
- ✅ **Arquitetura serverless** - Usa AWS Lambda para processamento
- ✅ **Custo-efetivo** - Não há necessidade de duplicação de dados
- ✅ **Infraestrutura como Código** - Template CloudFormation completo

## 🏗️ Arquitetura

```
┌─────────────┐    ┌──────────────────┐    ┌─────────────┐
│   Cliente   │───▶│ Object Lambda    │───▶│   Lambda    │
│             │    │  Access Point    │    │  Function   │
└─────────────┘    └──────────────────┘    └─────────────┘
                            │                       │
                            ▼                       ▼
                   ┌──────────────────┐    ┌─────────────┐
                   │  S3 Access Point │───▶│  S3 Bucket  │
                   │                  │    │             │
                   └──────────────────┘    └─────────────┘
```

## 🚀 Guia Rápido

### Pré-requisitos

- AWS CLI configurado com permissões apropriadas
- Conta AWS com acesso ao S3, Lambda e CloudFormation
- Região: `us-east-1` (recomendada)

### 1. Fazer Deploy da Infraestrutura

```bash
# Clone este repositório
git clone <repository-url>
cd desafios/005

# Fazer deploy da stack CloudFormation
aws cloudformation create-stack \
  --stack-name s3-object-lambda-demo \
  --template-body file://template.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=BaseBucketName,ParameterValue=meu-bucket-demo \
               ParameterKey=LambdaName,ParameterValue=TransformLambda \
  --region us-east-1
```

### 2. Aguardar o Deploy

```bash
# Monitorar progresso do deploy
aws cloudformation wait stack-create-complete \
  --stack-name s3-object-lambda-demo \
  --region us-east-1
```

### 3. Testar a Transformação

```bash
# Executar teste automatizado
cd scripts
./test-simple.bat
```

## 📁 Estrutura do Projeto

```
├── src/
│   └── transform_lambda.py     # Código fonte da função Lambda
├── scripts/
│   ├── deploy.bat             # Script de deploy
│   ├── test-simple.bat        # Script de teste completo
│   ├── check-status.bat       # Verificar status da stack
│   └── verificar.bat          # Verificação rápida
├── examples/
│   ├── test.txt               # Arquivo de exemplo
│   ├── original-test-output.txt   # Conteúdo original
│   └── transformed-test-output.txt # Conteúdo transformado
├── images/
│   └── infrastructure-compose-desafio-005.png
├── template.yaml              # Template CloudFormation
└── README.md                  # Este arquivo
```

## 🧪 Testes

### Testes Automatizados

```bash
# Executar suíte completa de testes
scripts/test-simple.bat

# Verificação rápida
scripts/verificar.bat
```

### Teste Manual

1. **Fazer upload de um arquivo de teste:**

```bash
echo "hello world from s3 object lambda" > test.txt
aws s3 cp test.txt s3://SEU-NOME-DO-BUCKET/test.txt
```

2. **Acessar via bucket original (inalterado):**

```bash
aws s3api get-object \
  --bucket SEU-NOME-DO-BUCKET \
  --key test.txt \
  original-output.txt

cat original-output.txt
# Saída: hello world from s3 object lambda
```

3. **Acessar via Object Lambda (transformado):**

```bash
aws s3api get-object \
  --bucket arn:aws:s3-object-lambda:us-east-1:SUA-CONTA:accesspoint/SEU-OBJECT-LAMBDA-AP \
  --key test.txt \
  transformed-output.txt

cat transformed-output.txt
# Saída: HELLO WORLD FROM S3 OBJECT LAMBDA
```

## 🔧 Configuração

### Parâmetros

- **BaseBucketName**: Nome base para o bucket S3 (padrão: `object-lambda-demo`)
- **LambdaName**: Nome para a função Lambda (padrão: `TransformLambda`)

## 💰 Considerações de Custo

### AWS Free Tier Incluído

- **S3**: 5GB de armazenamento + 20.000 requisições GET
- **Lambda**: 1M requisições + 400.000 GB-segundos
- **CloudWatch**: Logs básicos incluídos

### Custos Estimados (após free tier)

- **S3 Object Lambda**: $0.0005 por requisição
- **Lambda**: Baseado no tempo de execução e memória
- **S3 Storage**: $0.023/GB por mês

## 🧹 Limpeza

Para evitar cobranças contínuas, delete todos os recursos:

```bash
# Esvaziar o bucket S3 primeiro
aws s3 rm s3://SEU-NOME-DO-BUCKET --recursive

# Deletar a stack CloudFormation
aws cloudformation delete-stack \
  --stack-name s3-object-lambda-demo \
  --region us-east-1

# Aguardar conclusão da deleção
aws cloudformation wait stack-delete-complete \
  --stack-name s3-object-lambda-demo \
  --region us-east-1
```

## 📚 Saiba Mais

- [Documentação AWS S3 Object Lambda](https://docs.aws.amazon.com/AmazonS3/latest/userguide/transforming-objects.html)
- [CloudFormation S3ObjectLambda::AccessPoint](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-s3objectlambda-accesspoint.html)
- [Exemplos de Funções Lambda](https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-examples.html)

## ⚠️ Notas Importantes

- Esta demonstração usa a região `us-east-1`
- **Substitua todos os placeholders** pelos nomes reais dos seus recursos AWS após o deploy
- Use `scripts/setup-variables.bat` para obter os nomes dos seus recursos automaticamente
- Certifique-se de que suas credenciais AWS têm permissões suficientes
- A função Lambda processa apenas arquivos de texto
- Arquivos binários são retornados inalterados
- Sempre teste em um ambiente de desenvolvimento primeiro
- Veja [SECURITY.md](SECURITY.md) para diretrizes de segurança

---
