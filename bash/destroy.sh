#!/bin/bash

TAG_NAME="aws-101-cli-vpc"

echo "Destroying VPC resources..."

vpc_id="$(aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=$TAG_NAME |
    jq -r '.Vpcs[0].VpcId')"

aws ec2 delete-vpc \
    --vpc-id "$vpc_id"

echo "Deleted VPC $vpc_id!"