#!/bin/bash

TAG_NAME="aws-101-cli"

echo "Destroying VPC resources..."

vpc_id="$(aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values="$TAG_NAME-vpc" |
    jq -r '.Vpcs[0].VpcId')"

subnet_1a_public1_id="$(aws ec2 describe-subnets \
    --filters \
        Name=vpc-id,Values="$vpc_id" \
        Name=tag:Name,Values="$TAG_NAME-subnet-public1" \
        Name=availability-zone,Values=us-east-1a |
    jq -r '.Subnets[0].SubnetId')"
aws ec2 delete-subnet \
    --subnet-id "$subnet_1a_public1_id"
echo "Deleted Subnet: $subnet_1a_public1_id!"

aws ec2 delete-vpc \
    --vpc-id "$vpc_id"
echo "Deleted VPC: $vpc_id!"