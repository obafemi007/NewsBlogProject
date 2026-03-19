# Stop script on any error
$ErrorActionPreference = "Stop"

# Variables
$KeyName = "aws_key"
$SecGroup = "newsblog-sg"
$InstanceType = "t3.micro"  # t3 is usually more reliable for Free Tier in us-east-1 now
$Region = "us-east-1"
# Hardcoded Ubuntu 22.04 LTS AMI
$AmiId = "ami-0e2c8ccd4e022c147"

Write-Host "Using Ubuntu 22.04 AMI: $AmiId" -ForegroundColor Cyan

# 1. Handle Security Group (Delete if exists, then Create)
Write-Host "Checking if security group '$SecGroup' exists..."
$ExistingSg = aws ec2 describe-security-groups --group-names $SecGroup --region $Region --query "SecurityGroups[0].GroupId" --output text 2>$null

if ($null -ne $ExistingSg -and $ExistingSg -ne "None") {
    Write-Host "Existing Security Group found ($ExistingSg). Deleting..." -ForegroundColor Yellow
    aws ec2 delete-security-group --group-id $ExistingSg --region $Region
}

Write-Host "Creating security group..."
$SgId = aws ec2 create-security-group --group-name $SecGroup --description "News Blog SG" --region $Region --query "GroupId" --output text

# Add inbound rules
Write-Host "Adding inbound rules (SSH, HTTP, HTTPS)..."
aws ec2 authorize-security-group-ingress --group-id $SgId --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $Region
aws ec2 authorize-security-group-ingress --group-id $SgId --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $Region
aws ec2 authorize-security-group-ingress --group-id $SgId --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $Region

# 2. Launch EC2 Instance
Write-Host "Launching EC2 instance..." -ForegroundColor Cyan
$InstanceId = aws ec2 run-instances `
    --image-id $AmiId `
    --count 1 `
    --instance-type $InstanceType `
    --key-name $KeyName `
    --security-group-ids $SgId `
    --region $Region `
    --user-data "#!/bin/bash
        apt update -y
        apt install -y nginx
        systemctl enable nginx
        systemctl start nginx
        echo '<h1>News Blog Infrastructure Ready!</h1>' > /var/www/html/index.html" `
    --query "Instances[0].InstanceId" `
    --output text

Write-Host "Instance launched with ID: $InstanceId"

# 3. Wait until running
Write-Host "Waiting for instance to start..."
aws ec2 wait instance-running --instance-ids $InstanceId --region $Region

# 4. Get Public IP
$PublicIp = aws ec2 describe-instances --instance-ids $InstanceId --region $Region --query "Reservations[0].Instances[0].PublicIpAddress" --output text

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "SUCCESS: Your EC2 is ready!"
Write-Host "Public IP: $PublicIp"
Write-Host "Web URL: http://$PublicIp"
Write-Host "========================================"