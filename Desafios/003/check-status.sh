#!/bin/bash

echo "🔍 Verificando status do deploy..."
echo ""

# Verificar se AWS CLI está configurado
if ! aws sts get-caller-identity &>/dev/null; then
    echo "❌ AWS CLI não configurado"
    echo "Execute: aws configure"
    echo "Ou defina as variáveis:"
    echo "  export AWS_ACCESS_KEY_ID=sua_key"
    echo "  export AWS_SECRET_ACCESS_KEY=sua_secret"
    echo "  export AWS_DEFAULT_REGION=us-east-1"
    exit 1
fi

STACK_NAME="site-estatico-stack"

# Verificar se a stack existe
if aws cloudformation describe-stacks --stack-name $STACK_NAME &>/dev/null; then
    echo "✅ Stack encontrada!"
    
    # Status da stack
    STATUS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].StackStatus' --output text)
    echo "📊 Status: $STATUS"
    
    if [ "$STATUS" = "CREATE_COMPLETE" ] || [ "$STATUS" = "UPDATE_COMPLETE" ]; then
        echo "✅ Stack está funcionando!"
        
        # Obter outputs
        BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' --output text)
        SITE_URL=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`SiteURL`].OutputValue' --output text)
        
        echo "📦 Bucket: $BUCKET_NAME"
        echo "🌐 Site: $SITE_URL"
        
        # Verificar se arquivos existem no bucket
        echo ""
        echo "📁 Arquivos no bucket:"
        aws s3 ls s3://$BUCKET_NAME/
        
        # Testar acesso ao site
        echo ""
        echo "🌐 Testando acesso ao site..."
        if curl -s -o /dev/null -w "%{http_code}" $SITE_URL | grep -q "200"; then
            echo "✅ Site está acessível!"
        else
            echo "⚠️  Site pode não estar acessível ainda"
        fi
        
    else
        echo "⚠️  Stack em estado: $STATUS"
    fi
else
    echo "❌ Stack não encontrada"
    echo "Execute: ./deploy.sh"
fi