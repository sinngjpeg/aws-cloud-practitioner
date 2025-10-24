# AWS S3 Object Lambda - Real-time Text Transformation

Transform S3 objects in real-time without modifying the original data using AWS S3 Object Lambda Access Points.

## 🎯 What This Project Does

This project demonstrates how to use **AWS S3 Object Lambda** to transform text files to uppercase in real-time when accessed through a special access point, while keeping the original files unchanged in S3.

### Key Features
- ✅ **Real-time transformation** - Convert text to uppercase on-the-fly
- ✅ **Original data preserved** - Source files remain untouched
- ✅ **Serverless architecture** - Uses AWS Lambda for processing
- ✅ **Cost-effective** - No data duplication needed
- ✅ **Infrastructure as Code** - Complete CloudFormation template

## 🏗️ Architecture

```
┌─────────────┐    ┌──────────────────┐    ┌─────────────┐
│   Client    │───▶│ Object Lambda    │───▶│   Lambda    │
│             │    │  Access Point    │    │  Function   │
└─────────────┘    └──────────────────┘    └─────────────┘
                            │                       │
                            ▼                       ▼
                   ┌──────────────────┐    ┌─────────────┐
                   │  S3 Access Point │───▶│  S3 Bucket  │
                   │                  │    │             │
                   └──────────────────┘    └─────────────┘
```

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with appropriate permissions
- AWS account with access to S3, Lambda, and CloudFormation
- Region: `us-east-1` (recommended)

### 1. Deploy Infrastructure

```bash
# Clone this repository
git clone <repository-url>
cd aws-s3-object-lambda

# Deploy the CloudFormation stack
aws cloudformation create-stack \
  --stack-name s3-object-lambda-demo \
  --template-body file://template.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=BaseBucketName,ParameterValue=my-demo-bucket \
               ParameterKey=LambdaName,ParameterValue=TransformLambda \
  --region us-east-1
```

### 2. Wait for Deployment

```bash
# Monitor deployment progress
aws cloudformation wait stack-create-complete \
  --stack-name s3-object-lambda-demo \
  --region us-east-1
```

### 3. Test the Transformation

```bash
# Run the automated test
cd scripts
./test-simple.bat
```

## 📁 Project Structure

```
├── src/
│   └── transform_lambda.py     # Lambda function source code
├── scripts/
│   ├── deploy.bat             # Deployment script
│   ├── test-simple.bat        # Complete test script
│   ├── check-status.bat       # Check stack status
│   └── verificar.bat          # Quick verification
├── examples/
│   ├── test.txt               # Sample input file
│   ├── original-test-output.txt   # Original content
│   └── transformed-test-output.txt # Transformed content
├── images/
│   └── infrastructure-compose-desafio-005.png
├── template.yaml              # CloudFormation template
└── README.md                  # This file
```

## 🧪 Testing

### Automated Testing
```bash
# Run complete test suite
scripts/test-simple.bat

# Quick verification
scripts/verificar.bat
```

### Manual Testing

1. **Upload a test file:**
```bash
echo "hello world from s3 object lambda" > test.txt
aws s3 cp test.txt s3://YOUR-BUCKET-NAME/test.txt
```

2. **Access via original bucket (unchanged):**
```bash
aws s3api get-object \
  --bucket YOUR-BUCKET-NAME \
  --key test.txt \
  original-output.txt

cat original-output.txt
# Output: hello world from s3 object lambda
```

3. **Access via Object Lambda (transformed):**
```bash
aws s3api get-object \
  --bucket arn:aws:s3-object-lambda:us-east-1:ACCOUNT:accesspoint/OBJECT-LAMBDA-AP \
  --key test.txt \
  transformed-output.txt

cat transformed-output.txt
# Output: HELLO WORLD FROM S3 OBJECT LAMBDA
```

## 🔧 Configuration

### Parameters
- **BaseBucketName**: Base name for the S3 bucket (default: `object-lambda-demo`)
- **LambdaName**: Name for the Lambda function (default: `TransformLambda`)

### Customization
Modify `src/transform_lambda.py` to implement different transformations:
- Text filtering
- Format conversion (JSON to CSV)
- Data redaction
- Content encryption

## 💰 Cost Considerations

### AWS Free Tier Included
- **S3**: 5GB storage + 20,000 GET requests
- **Lambda**: 1M requests + 400,000 GB-seconds
- **CloudWatch**: Basic logs included

### Estimated Costs (after free tier)
- **S3 Object Lambda**: $0.0005 per request
- **Lambda**: Based on execution time and memory
- **S3 Storage**: $0.023/GB per month

## 🧹 Cleanup

To avoid ongoing charges, delete all resources:

```bash
# Empty the S3 bucket first
aws s3 rm s3://YOUR-BUCKET-NAME --recursive

# Delete the CloudFormation stack
aws cloudformation delete-stack \
  --stack-name s3-object-lambda-demo \
  --region us-east-1

# Wait for deletion to complete
aws cloudformation wait stack-delete-complete \
  --stack-name s3-object-lambda-demo \
  --region us-east-1
```

## 📚 Learn More

- [AWS S3 Object Lambda Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/transforming-objects.html)
- [CloudFormation S3ObjectLambda::AccessPoint](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-s3objectlambda-accesspoint.html)
- [Lambda Function Examples](https://docs.aws.amazon.com/AmazonS3/latest/userguide/olap-examples.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Important Notes

- This demo uses `us-east-1` region
- **Replace all placeholders** with your actual AWS resource names after deployment
- Use `scripts/setup-variables.bat` to get your resource names automatically
- Ensure your AWS credentials have sufficient permissions
- The Lambda function processes text files only
- Binary files are returned unchanged
- Always test in a development environment first
- See [SECURITY.md](SECURITY.md) for security guidelines

---

**Built with ❤️ for learning AWS S3 Object Lambda**