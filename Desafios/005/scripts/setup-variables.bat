@echo off
REM Setup script to configure your specific AWS resources
REM Replace these values with your actual AWS resources after deployment

REM Get values from CloudFormation stack outputs
echo Getting stack outputs...
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --region us-east-1 --query "Stacks[0].Outputs[?OutputKey=='SourceBucketName'].OutputValue" --output text > bucket_name.txt
aws cloudformation describe-stacks --stack-name s3-object-lambda-demo --region us-east-1 --query "Stacks[0].Outputs[?OutputKey=='ObjectLambdaAccessPointArn'].OutputValue" --output text > object_lambda_arn.txt

set /p BUCKET_NAME=<bucket_name.txt
set /p OBJECT_LAMBDA_ARN=<object_lambda_arn.txt

echo.
echo Your AWS Resources:
echo Bucket Name: %BUCKET_NAME%
echo Object Lambda ARN: %OBJECT_LAMBDA_ARN%
echo.
echo Update your scripts with these values or use the automated test script.

del bucket_name.txt object_lambda_arn.txt 2>nul