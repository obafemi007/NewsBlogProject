#!/bin/bash

# Stop script on any error
set -e

# Variables
KEY_NAME="aws_key"
SEC_GROUP="newsblog-sg"
INSTANCE_TYPE="t3.micro"
REGION="us-east-1"
# Hardcoded Ubuntu 22.04 LTS AMI for us-east-1
AMI_ID="ami-0030e4319cbf4dbf2"

echo "Using Ubuntu 22.04 AMI: $AMI_ID"

# 1. Handle Security Group (Delete if exists, then Create)
echo "Checking if security group '$SEC_GROUP' exists..."
EXISTING_SG_ID=$(aws ec2 describe-security-groups \
  --group-names $SEC_GROUP \
  --region $REGION \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null || echo "None")

if [ "$EXISTING_SG_ID" != "None" ]; then
    echo "Existing Security Group found ($EXISTING_SG_ID). Deleting to start fresh..."
    # Note: This might fail if an existing EC2 is currently using this SG.
    aws ec2 delete-security-group --group-id $EXISTING_SG_ID --region $REGION || echo "Warning: Could not delete SG (it might be in use). Using existing one."
fi

echo "Creating security group..."
SG_ID=$(aws ec2 create-security-group \
  --group-name $SEC_GROUP \
  --description "News Blog SG" \
  --region $REGION \
  --query "GroupId" \
  --output text)

echo "Security Group ID: $SG_ID"

# Add inbound rules (SSH, HTTP, HTTPS)
echo "Adding inbound rules..."
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $REGION

# 2. Launch EC2 Instance
echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SG_ID \
  --region $REGION \
  --user-data '#!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>News Blog Infrastructure Ready!</h1><p>Next step: Run your GitHub Actions Deployment.</p>" > /var/www/html/index.html
  ' \
  --query "Instances[0].InstanceId" \
  --output text)

echo "Instance launched with ID: $INSTANCE_ID"

# 3. Wait until running
echo "Waiting for instance to reach 'running' state..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

# 4. Get Public IP
echo "Fetching public IP..."
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --region $REGION \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "========================================"
echo "SUCCESS: Your EC2 is being built!"
echo "Public IP: $PUBLIC_IP"
echo "SSH Command: ssh -i $KEY_NAME.pem ubuntu@$PUBLIC_IP"
echo "Web URL: http://$PUBLIC_IP"
echo "========================================"
echo "IMPORTANT: Copy this IP to your GitHub Secrets as 'EC2_HOST'"