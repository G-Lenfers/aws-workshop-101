#!/bin/bash

echo "Destroying VPC resources..."

vpc_id="$(aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values=aws-101-cli-vpc |
    jq -r '.Vpcs[0].VpcId')"

aws ec2 delete-vpc \
    --vpc-id "$vpc_id"

echo "Deleted VPC $vpc_id!"