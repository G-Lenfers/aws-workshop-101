#!/bin/bash

REGION="us-east-1"
TAG_NAME="aws-101-cli"

function create_vpc () {
    _cidr_block=$1

    aws ec2 create-vpc \
        --cidr-block "$_cidr_block" \
        --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$TAG_NAME-vpc}]" \
        --output json |
        jq -r '.Vpc.VpcId'
}

function enable_vpc_dns () {
    aws ec2 modify-vpc-attribute \
        --vpc-id "$vpc_id" \
        --enable-dns-support '{"Value":true}'

    aws ec2 modify-vpc-attribute \
        --vpc-id "$vpc_id" \
        --enable-dns-hostnames '{"Value":true}'
}

function create_vpc_endpoint () {
    _vpc_id=$1
    _vpc_endpoint_type=$2
    _service_name=$3
    _tag_name_complement=$4

    aws ec2 create-vpc-endpoint \
        --vpc-id "$_vpc_id" \
        --vpc-endpoint-type "$_vpc_endpoint_type" \
        --service-name "$_service_name" \
        --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=$TAG_NAME-vpce-$_tag_name_complement}]" | \
        jq -r '.VpcEndpoint.VpcEndpointId'
}

function create_subnet () {
    _vpc_id=$1
    _cidr_block=$2
    _availability_zone=$3
    _tag_name_complement=$4

    aws ec2 create-subnet \
        --vpc-id "$_vpc_id" \
        --cidr-block "$_cidr_block" \
        --availability-zone "$REGION$_availability_zone" \
        --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$TAG_NAME-subnet-$_tag_name_complement}]" \
        --output json |
        jq -r '.Subnet.SubnetId'
}

echo "Creating VPC resources..."

vpc_id=$(create_vpc '10.1.0.0/24')
echo "VPC ID: $vpc_id"

enable_vpc_dns

vpce_s3_id=$(create_vpc_endpoint "$vpc_id" Gateway com.amazonaws.us-east-1.s3 s3)
echo "VPC S3 endpoint ID: $vpce_s3_id"

subnet_1a_public1_id="$(create_subnet "$vpc_id" '10.1.0.0/28' 'a' 'public1')" && echo "Subnet 1a public1 ID: $subnet_1a_public1_id"
subnet_1a_private1_id="$(create_subnet "$vpc_id" '10.1.0.16/28' 'a' 'private1')" && echo "Subnet 1a private1 ID: $subnet_1a_private1_id"
subnet_1b_public2_id="$(create_subnet "$vpc_id" '10.1.0.128/28' 'b' 'public2')" && echo "Subnet 1b public2 ID: $subnet_1b_public2_id"
subnet_1b_private2_id="$(create_subnet "$vpc_id" '10.1.0.144/28' 'b' 'private2')" && echo "Subnet 1b private2 ID: $subnet_1b_private2_id"

# TODO Create Internet Gateways
# TODO attach IGs to the public subnets
# TODO Create route tables
# TODO Create NAT Gateways

echo "Successfully created VPC resources!"
