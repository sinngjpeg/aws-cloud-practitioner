#!/bin/bash

# Script para limpeza completa dos recursos
STACK_NAME="site-estatico-stack"

echo "🧹 Limpeza dos recursos AWS"
echo "=========================="

# Verificar se a stack existe
if aws cloudformation describe-stacks --stack-name $STACK_NAME &>/dev/null; then
    echo "📦 Stack encontrada: $STACK_NAME"
    
    # Obter nome do bucket antes de deletar a stack
    BUCKET_NAME=$(aws cloudformation describe-stacks \
        --stack-name $STACK_NAME \
        --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
        --output text)
    
    if [ "$BUCKET_NAME" != "None" ] && [ "$BUCKET_NAME" != "" ]; then
        echo "🗑️  Esvaziando bucket: $BUCKET_NAME"
        
        # Verificar se bucket existe e tem objetos
        OBJECT_COUNT=$(aws s3api list-objects-v2 --bucket $BUCKET_NAME \
            --query 'length(Contents)' --output text 2>/dev/null || echo "0")
        
        if [ "$OBJECT_COUNT" != "None" ] && [ "$OBJECT_COUNT" != "0" ] && [ "$OBJECT_COUNT" != "" ]; then
            echo "📄 Removendo $OBJECT_COUNT objetos..."
            aws s3 rm s3://$BUCKET_NAME --recursive
            echo "✅ Bucket esvaziado"
        else
            echo "📭 Bucket já está vazio"
        fi
    fi
    
    echo "🗂️  Deletando stack CloudFormation..."
    aws cloudformation delete-stack --stack-name $STACK_NAME
    
    echo "⏳ Aguardando exclusão da stack..."
    aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME
    
    if [ $? -eq 0 ]; then
        echo "✅ Stack deletada com sucesso!"
        echo "💰 Todos os recursos foram removidos - sem custos"
    else
        echo "❌ Erro ao deletar a stack"
        echo "Verifique o console AWS para mais detalhes"
    fi
    
else
    echo "❌ Stack não encontrada: $STACK_NAME"
    echo "Nada para limpar"
fi

echo ""
echo "🔍 Para verificar se tudo foi removido:"
echo "aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE"