#!/bin/bash

echo "🔐 Verificação de Credenciais AWS"
echo "================================"

# Verificar se AWS CLI está instalado
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI não está instalado"
    echo "Instale em: https://aws.amazon.com/cli/"
    exit 1
fi

echo "✅ AWS CLI instalado: $(aws --version)"
echo ""

# Verificar configuração
echo "📋 Configuração atual:"
aws configure list

echo ""

# Testar credenciais
echo "🔍 Testando credenciais..."
if aws sts get-caller-identity &>/dev/null; then
    echo "✅ Credenciais válidas"
    
    ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    USER_ARN=$(aws sts get-caller-identity --query Arn --output text)
    REGION=$(aws configure get region)
    
    echo "   Conta: $ACCOUNT"
    echo "   Usuário: $USER_ARN"
    echo "   Região: $REGION"
    
    # Testar permissões S3
    echo ""
    echo "🪣 Testando permissões S3..."
    if aws s3 ls &>/dev/null; then
        echo "✅ Permissões S3 OK"
    else
        echo "❌ Sem permissões S3"
    fi
    
    # Testar permissões CloudFormation
    echo ""
    echo "☁️  Testando permissões CloudFormation..."
    if aws cloudformation list-stacks &>/dev/null; then
        echo "✅ Permissões CloudFormation OK"
    else
        echo "❌ Sem permissões CloudFormation"
    fi
    
    echo ""
    echo "🎉 Configuração completa! Você pode executar:"
    echo "   ./deploy.sh"
    
else
    echo "❌ Credenciais inválidas ou não configuradas"
    echo ""
    echo "Para configurar:"
    echo "   aws configure"
    echo ""
    echo "Ou consulte: setup-aws-credentials.md"
fi