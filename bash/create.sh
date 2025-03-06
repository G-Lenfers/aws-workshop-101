#!/bin/bash

TAG_NAME="aws-101-cli"

function create_subnet () {
    tag_name_complement=$1
    cidr_block=$2
    aws ec2 create-subnet \
        --vpc-id "$vpc_id" \
        --cidr-block "$cidr_block" \
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
echo "VPC ID: $vpc_id"

aws ec2 modify-vpc-attribute \
    --vpc-id "$vpc_id" \
    --enable-dns-support '{"Value":true}'

aws ec2 modify-vpc-attribute \
    --vpc-id "$vpc_id" \
    --enable-dns-hostnames '{"Value":true}'

vpce_s3_id=$(aws ec2 create-vpc-endpoint \
    --vpc-id "$vpc_id" \
    --vpc-endpoint-type Gateway \
    --service-name com.amazonaws.us-east-1.s3 \
    --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=$TAG_NAME-vpce-s3}]" | \
    jq -r '.VpcEndpoint.VpcEndpointId')
echo "VPC S3 endpoint ID: $vpce_s3_id"


subnet_1a_public1_id="$(create_subnet 'public1' '10.1.0.0/28')" && echo "Subnet 1a public1 ID: $subnet_1a_public1_id"
subnet_1a_private1_id="$(create_subnet 'private1' '10.1.0.16/28')" && echo "Subnet 1a private1 ID: $subnet_1a_private1_id"
subnet_1b_public2_id="$(create_subnet 'public2' '10.1.0.128/28')" && echo "Subnet 1b public2 ID: $subnet_1b_public2_id"
subnet_1b_private2_id="$(create_subnet 'private2' '10.1.0.144/28')" && echo "Subnet 1b private2 ID: $subnet_1b_private2_id"

# TODO Create Internet Gateways
# TODO attach IGs to the public subnets
# TODO Create route tables
# TODO Create NAT Gateways

echo "Successfully created VPC resources!"
