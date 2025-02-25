#!/bin/bash

# TODO tag name variable

echo "Creating VPC resources..."
aws ec2 create-vpc \
    --cidr-block 10.1.0.0/24 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=aws-101-cli-vpc}]'

# TODO Create subnets
# TODO Create route tables
# TODO Create NAT Gateways

echo "Creating VPC resources... DONE!"
