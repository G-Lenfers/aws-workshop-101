#!/bin/bash

TAG_NAME="aws-101-cli"

echo "Creating VPC resources..."

vpc_id="$(aws ec2 create-vpc \
    --cidr-block '10.1.0.0/24' \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$TAG_NAME-vpc}]" \
    --output json |
    jq -r '.Vpc.VpcId')"
echo "VPC Id: $vpc_id"

subnet_1a_public1_id="$(aws ec2 create-subnet \
    --vpc-id "$vpc_id" \
    --cidr-block '10.1.0.0/28' \
    --availability-zone 'us-east-1a' \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$TAG_NAME-subnet-public1}]" \
    --output json |
    jq -r '.Subnet.SubnetId')"  &&
echo "Subnet 1a public1 ID: $subnet_1a_public1_id"

# TODO Create subnets
# TODO Create route tables
# TODO Create NAT Gateways

echo "Successfully created VPC resources!"
