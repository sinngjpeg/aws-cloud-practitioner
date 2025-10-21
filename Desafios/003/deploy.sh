#!/bin/bash

# Script para deploy do site estático - FREE TIER ONLY
STACK_NAME="site-estatico-stack"

echo "🆓 Deploy do site estático (Free Tier)"
echo "📊 Recursos utilizados:"
echo "   - S3: ~2KB de storage (bem abaixo do limite de 5GB)"
echo "   - CloudFormation: 1 stack (limite: ilimitado no Free Tier)"
echo ""

# Criar stack CloudFormation
echo "🚀 Criando stack CloudFormation..."
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://template.yaml

echo "⏳ Aguardando criação da stack..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

if [ $? -eq 0 ]; then
    echo "✅ Stack criada com sucesso!"
    
    # Obter nome do bucket
    BUCKET_NAME=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
        --output text)
    
    echo "📦 Upload dos arquivos HTML (2 arquivos = 2 PUT requests)"
    aws s3 cp index.html s3://$BUCKET_NAME/
    aws s3 cp error.html s3://$BUCKET_NAME/
    
    # Obter URL do site
    SITE_URL=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`SiteURL`].OutputValue' \
        --output text)
    
    echo ""
    echo "🌐 Site disponível em: $SITE_URL"
    echo "💰 Custo: $0.00 (dentro do Free Tier)"
else
    echo "❌ Erro no deploy da stack"
fi