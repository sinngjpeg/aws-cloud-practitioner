#!/bin/bash

# Script para deploy do site estático - FREE TIER ONLY
STACK_NAME="site-estatico-stack"
PROJECT_NAME="meu-site-estatico"
ENVIRONMENT="dev"

echo "🆓 Deploy do site estático (Free Tier)"
echo "📊 Recursos utilizados:"
echo "   - S3: ~2KB de storage (bem abaixo do limite de 5GB)"
echo "   - CloudFormation: 1 stack (limite: ilimitado no Free Tier)"
echo "   - Projeto: $PROJECT_NAME"
echo "   - Ambiente: $ENVIRONMENT"
echo ""

# Verificar se a stack já existe
if aws cloudformation describe-stacks --stack-name $STACK_NAME &>/dev/null; then
    echo "⚠️  Stack já existe. Atualizando..."
    aws cloudformation update-stack \
        --stack-name $STACK_NAME \
        --template-body file://template.yaml \
        --parameters ParameterKey=ProjectName,ParameterValue=$PROJECT_NAME \
                    ParameterKey=Environment,ParameterValue=$ENVIRONMENT
    
    echo "⏳ Aguardando atualização da stack..."
    aws cloudformation wait stack-update-complete --stack-name $STACK_NAME
else
    echo "🚀 Criando nova stack CloudFormation..."
    aws cloudformation create-stack \
        --stack-name $STACK_NAME \
        --template-body file://template.yaml \
        --parameters ParameterKey=ProjectName,ParameterValue=$PROJECT_NAME \
                    ParameterKey=Environment,ParameterValue=$ENVIRONMENT
    
    echo "⏳ Aguardando criação da stack..."
    aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
fi

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
    echo ""
    echo "🎉 Deploy concluído com sucesso!"
    echo "🌐 Site disponível em: $SITE_URL"
    echo "📦 Bucket: $BUCKET_NAME"
    echo "💰 Custo: $0.00 (dentro do Free Tier)"
    echo ""
    echo "🔍 Para validar o uso do Free Tier: ./validate-freetier.sh"
    echo "🧹 Para limpar recursos: ./cleanup.sh"
else
    echo "❌ Erro no deploy da stack"
    echo "Verifique os logs do CloudFormation para mais detalhes"
fi