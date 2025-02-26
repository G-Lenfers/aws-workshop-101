#!/bin/bash

TAG_NAME="aws-101-cli-vpc"

echo "Creating VPC resources..."

vpc_id="$(aws ec2 create-vpc \
    --cidr-block '10.1.0.0/24' \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --output json |
    jq -r '.Vpc.VpcId')"
echo "VPC Id: $vpc_id"

aws ec2 create-subnet \
    --vpc-id "$vpc_id" \
    --cidr-block '10.1.0.0/28' \
    --availability-zone 'us-east-1a' \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$TAG_NAME}]"

# TODO Create subnets
# TODO Create route tables
# TODO Create NAT Gateways

echo "Successfully created VPC resources!"
