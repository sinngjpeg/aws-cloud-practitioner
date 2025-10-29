#!/bin/bash

# Script para validar uso do Free Tier
STACK_NAME="site-estatico-stack"

echo "🔍 Validando uso do Free Tier AWS"
echo "=================================="

# Verificar se a stack existe
if aws cloudformation describe-stacks --stack-name $STACK_NAME &>/dev/null; then
    echo "✅ Stack encontrada: $STACK_NAME"
    
    # Obter informações do bucket
    BUCKET_NAME=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
        --output text)
    
    echo "📦 Bucket: $BUCKET_NAME"
    
    # Verificar tamanho dos objetos
    echo ""
    echo "📊 Análise de uso do Free Tier:"
    echo "------------------------------"
    
    # Tamanho total do bucket
    TOTAL_SIZE=$(aws s3api list-objects-v2 --bucket $BUCKET_NAME \
        --query 'sum(Contents[].Size)' --output text 2>/dev/null || echo "0")
    
    if [ "$TOTAL_SIZE" = "None" ] || [ "$TOTAL_SIZE" = "" ]; then
        TOTAL_SIZE=0
    fi
    
    TOTAL_SIZE_MB=$(echo "scale=2; $TOTAL_SIZE / 1024 / 1024" | bc -l 2>/dev/null || echo "0")
    FREE_TIER_GB=5
    FREE_TIER_BYTES=$((FREE_TIER_GB * 1024 * 1024 * 1024))
    
    echo "🗂️  Armazenamento usado: ${TOTAL_SIZE_MB} MB de 5 GB (Free Tier)"
    
    if [ "$TOTAL_SIZE" -lt "$FREE_TIER_BYTES" ]; then
        echo "✅ Dentro do limite do Free Tier"
    else
        echo "⚠️  Acima do limite do Free Tier"
    fi
    
    # Contar objetos
    OBJECT_COUNT=$(aws s3api list-objects-v2 --bucket $BUCKET_NAME \
        --query 'length(Contents)' --output text 2>/dev/null || echo "0")
    
    if [ "$OBJECT_COUNT" = "None" ] || [ "$OBJECT_COUNT" = "" ]; then
        OBJECT_COUNT=0
    fi
    
    echo "📄 Número de objetos: $OBJECT_COUNT"
    echo "📈 Requests estimados por mês:"
    echo "   - PUT/POST: $OBJECT_COUNT (limite: 2.000)"
    echo "   - GET: Depende do tráfego (limite: 20.000)"
    
    # URL do site
    SITE_URL=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`SiteURL`].OutputValue' \
        --output text)
    
    echo ""
    echo "🌐 Site disponível em: $SITE_URL"
    echo "💰 Custo estimado: $0.00 (Free Tier)"
    
else
    echo "❌ Stack não encontrada: $STACK_NAME"
    echo "Execute primeiro: ./deploy.sh"
fi

echo ""
echo "📋 Limites do Free Tier S3:"
echo "- Armazenamento: 5 GB"
echo "- Requests GET: 20.000/mês"
echo "- Requests PUT/COPY/POST/LIST: 2.000/mês"
echo "- Transferência de dados: 15 GB/mês"