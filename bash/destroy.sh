#!/bin/bash

TAG_NAME="aws-101-cli-vpc"  # TODO 'vpc' shouldn't be here

echo "Destroying VPC resources..."

vpc_id="$(aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=$TAG_NAME |
    jq -r '.Vpcs[0].VpcId')"

subnet_1a_id="$(aws ec2 describe-subnets \
    --filters Name=vpc-id,Values="$vpc_id" Name=tag:Name,Values=$TAG_NAME Name=availability-zone,Values=us-east-1a |
    jq -r '.Subnets[0].SubnetId')"

aws ec2 delete-subnet \
    --subnet-id "$subnet_1a_id"
echo "Deleted Subnet: $subnet_1a_id!"

aws ec2 delete-vpc \
    --vpc-id "$vpc_id"

echo "Deleted VPC: $vpc_id!"