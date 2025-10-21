#!/bin/bash

# Script para monitorar uso dos recursos AWS
source .env 2>/dev/null || true

STACK_NAME=${STACK_NAME:-"site-estatico-stack"}

echo "📊 Monitor de Recursos AWS - Free Tier"
echo "====================================="

# Verificar se AWS CLI está configurado
if ! aws sts get-caller-identity &>/dev/null; then
    echo "❌ AWS CLI não configurado ou sem permissões"
    echo "Configure com: aws configure"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=$(aws configure get region)

echo "🔐 Conta AWS: $ACCOUNT_ID"
echo "🌍 Região: $REGION"
echo ""

# Verificar stack
if aws cloudformation describe-stacks --stack-name $STACK_NAME &>/dev/null; then
    echo "✅ Stack ativa: $STACK_NAME"
    
    BUCKET_NAME=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
        --output text)
    
    echo "📦 Bucket: $BUCKET_NAME"
    
    # Análise detalhada do bucket
    echo ""
    echo "📈 Análise de uso atual:"
    echo "----------------------"
    
    # Listar objetos com detalhes
    echo "📄 Objetos no bucket:"
    aws s3api list-objects-v2 --bucket $BUCKET_NAME \
        --query 'Contents[].{Nome:Key,Tamanho:Size,Modificado:LastModified}' \
        --output table 2>/dev/null || echo "   Nenhum objeto encontrado"
    
    # Calcular uso total
    TOTAL_SIZE=$(aws s3api list-objects-v2 --bucket $BUCKET_NAME \
        --query 'sum(Contents[].Size)' --output text 2>/dev/null || echo "0")
    
    if [ "$TOTAL_SIZE" = "None" ] || [ "$TOTAL_SIZE" = "" ]; then
        TOTAL_SIZE=0
    fi
    
    TOTAL_SIZE_KB=$(echo "scale=2; $TOTAL_SIZE / 1024" | bc -l 2>/dev/null || echo "0")
    TOTAL_SIZE_MB=$(echo "scale=2; $TOTAL_SIZE / 1024 / 1024" | bc -l 2>/dev/null || echo "0")
    
    echo ""
    echo "💾 Uso de armazenamento:"
    echo "   Total: $TOTAL_SIZE bytes (${TOTAL_SIZE_KB} KB / ${TOTAL_SIZE_MB} MB)"
    echo "   Limite Free Tier: 5 GB (5,368,709,120 bytes)"
    
    PERCENTAGE=$(echo "scale=4; $TOTAL_SIZE * 100 / 5368709120" | bc -l 2>/dev/null || echo "0")
    echo "   Uso: ${PERCENTAGE}% do Free Tier"
    
    # Status do site
    SITE_URL=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`SiteURL`].OutputValue' \
        --output text)
    
    echo ""
    echo "🌐 Status do site:"
    echo "   URL: $SITE_URL"
    
    # Testar conectividade
    if curl -s --head "$SITE_URL" | head -n 1 | grep -q "200 OK"; then
        echo "   Status: ✅ Online"
    else
        echo "   Status: ⚠️  Verificar conectividade"
    fi
    
else
    echo "❌ Stack não encontrada: $STACK_NAME"
    echo ""
    echo "Para criar a stack:"
    echo "   ./deploy.sh"
fi

echo ""
echo "🎯 Próximos passos:"
echo "- Monitorar uso mensal no AWS Billing Dashboard"
echo "- Configurar alertas de billing (opcional)"
echo "- Considerar CloudFront para HTTPS (também tem Free Tier)"

echo ""
echo "📚 Links úteis:"
echo "- S3 Console: https://console.aws.amazon.com/s3/"
echo "- CloudFormation: https://console.aws.amazon.com/cloudformation/"
echo "- Billing: https://console.aws.amazon.com/billing/"