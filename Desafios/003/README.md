# Site Estático AWS - Free Tier

Este projeto cria um site estático usando apenas recursos do **AWS Free Tier**.

## 🆓 Recursos Free Tier Utilizados

### Amazon S3
- **5 GB** de armazenamento padrão
- **20.000** solicitações GET
- **2.000** solicitações PUT/COPY/POST/LIST
- **15 GB** de transferência de dados

### AWS CloudFormation
- **1.000** chamadas de API por mês (gratuito)

## 📁 Arquivos do Projeto

```
003/
├── template.yaml    # Template CloudFormation
├── index.html      # Página inicial
├── error.html      # Página de erro 404
├── deploy.sh       # Script de deploy
└── README.md       # Este arquivo
```

## 🚀 Como Fazer o Deploy

### Pré-requisitos
- AWS CLI configurado
- Conta AWS com Free Tier ativo

### Deploy Manual

1. **Criar a stack:**
```bash
aws cloudformation create-stack \
    --stack-name site-estatico-stack \
    --template-body file://template.yaml
```

2. **Aguardar criação:**
```bash
aws cloudformation wait stack-create-complete \
    --stack-name site-estatico-stack
```

3. **Obter nome do bucket:**
```bash
aws cloudformation describe-stacks \
    --stack-name site-estatico-stack \
    --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
    --output text
```

4. **Upload dos arquivos:**
```bash
# Substitua BUCKET_NAME pelo nome obtido acima
aws s3 cp index.html s3://BUCKET_NAME/
aws s3 cp error.html s3://BUCKET_NAME/
```

5. **Obter URL do site:**
```bash
aws cloudformation describe-stacks \
    --stack-name site-estatico-stack \
    --query 'Stacks[0].Outputs[?OutputKey==`SiteURL`].OutputValue' \
    --output text
```

### Deploy Automático
```bash
./deploy.sh
```

## 💰 Custos (Free Tier)

- **S3 Storage**: Gratuito até 5GB
- **S3 Requests**: Gratuito até 20k GET + 2k PUT
- **Data Transfer**: Gratuito até 15GB/mês
- **CloudFormation**: Gratuito

## 🔒 Segurança

O template configura:
- Acesso público apenas para leitura
- Bucket policy restritiva
- Bloqueio de ACLs públicas desabilitado apenas para website

## 🧹 Limpeza

Para deletar todos os recursos:
```bash
# Esvaziar bucket primeiro
aws s3 rm s3://BUCKET_NAME --recursive

# Deletar stack
aws cloudformation delete-stack --stack-name site-estatico-stack
```

## 📝 Notas Importantes

- O nome do bucket é único globalmente
- URLs do S3 website têm formato: `http://bucket-name.s3-website-region.amazonaws.com`
- Não há HTTPS nativo (apenas HTTP)
- Para HTTPS, seria necessário CloudFront (tem Free Tier também)