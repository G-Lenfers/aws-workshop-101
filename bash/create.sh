#!/bin/bash

TAG_NAME="aws-101-cli"

function create_subnet () {
    tag_name_complement=$1
    aws ec2 create-subnet \
    --vpc-id "$vpc_id" \
    --cidr-block '10.1.0.0/28' \
    --availability-zone 'us-east-1a' \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$TAG_NAME-subnet-$tag_name_complement}]" \
    --output json |
    jq -r '.Subnet.SubnetId'
}

echo "Creating VPC resources..."

vpc_id="$(aws ec2 create-vpc \
    --cidr-block '10.1.0.0/24' \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$TAG_NAME-vpc}]" \
    --output json |
    jq -r '.Vpc.VpcId')"
echo "VPC Id: $vpc_id"

aws ec2 modify-vpc-attribute \
    --vpc-id "$vpc_id" \
    --enable-dns-support '{"Value":true}'

aws ec2 modify-vpc-attribute \
    --vpc-id "$vpc_id" \
    --enable-dns-hostnames '{"Value":true}'

subnet_1a_public1_id="$(create_subnet 'public1')" && echo "Subnet 1a public1 ID: $subnet_1a_public1_id"

# TODO Create subnets
# TODO Create Internet Gateways
# TODO attach IGs to the public subnets
# TODO Create route tables
# TODO Create NAT Gateways

echo "Successfully created VPC resources!"
