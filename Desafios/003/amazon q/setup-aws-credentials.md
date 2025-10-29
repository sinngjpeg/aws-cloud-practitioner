# 🔐 Configuração de Chaves de Acesso AWS

## 1. Criar Usuário IAM (Console AWS)

### Passo 1: Acessar IAM
1. Faça login no [Console AWS](https://console.aws.amazon.com)
2. Vá para **IAM** (Identity and Access Management)
3. Clique em **Users** → **Create user**

### Passo 2: Configurar Usuário
```
Nome do usuário: aws-cli-user
Tipo de acesso: ✅ Programmatic access
```

### Passo 3: Permissões Mínimas (Free Tier)
Anexe as políticas:
- `AmazonS3FullAccess`
- `CloudFormationFullAccess`

### Passo 4: Baixar Credenciais
- Baixe o arquivo CSV com as chaves
- **IMPORTANTE**: Guarde em local seguro

## 2. Configurar AWS CLI

### Opção 1: Configuração Interativa
```bash
aws configure
```

Insira quando solicitado:
```
AWS Access Key ID: <sua_access_key>
AWS Secret Access Key: <sua_secret_key>
Default region name: us-east-1
Default output format: json
```

### Opção 2: Configuração por Arquivo
Crie o arquivo: `%USERPROFILE%\.aws\credentials`
```ini
[default]
aws_access_key_id = <sua_access_key>
aws_secret_access_key = <sua_secret_key>
```

Crie o arquivo: `%USERPROFILE%\.aws\config`
```ini
[default]
region = us-east-1
output = json
```

## 3. Testar Configuração

Execute o comando:
```bash
aws sts get-caller-identity
```

Resultado esperado:
```json
{
    "UserId": "AIDACKCEVSQ6C2EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/aws-cli-user"
}
```

## 4. Verificar Permissões

Teste S3:
```bash
aws s3 ls
```

Teste CloudFormation:
```bash
aws cloudformation list-stacks
```

## ⚠️ Segurança

### Boas Práticas:
- ✅ Use usuário IAM (não root)
- ✅ Permissões mínimas necessárias
- ✅ Rotacione chaves regularmente
- ❌ Nunca commite chaves no Git
- ❌ Não compartilhe chaves

### Arquivo .gitignore
```
.aws/
*.pem
*.key
.env
credentials
```

## 🆓 Permissões Free Tier

Para este projeto, você precisa apenas de:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "cloudformation:*"
            ],
            "Resource": "*"
        }
    ]
}
```

## 🔧 Solução de Problemas

### Erro: "Unable to locate credentials"
```bash
aws configure list
```

### Erro: "Access Denied"
- Verifique permissões IAM
- Confirme região correta

### Erro: "Invalid security token"
- Chaves podem estar incorretas
- Reconfigure: `aws configure`