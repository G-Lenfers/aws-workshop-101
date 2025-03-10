#!/bin/bash

TAG_NAME="aws-101-cli"

function delete_vpc_endpoints () {
    vpce_id=$(aws ec2 describe-vpc-endpoints | \
        jq -r '.VpcEndpoints[0].VpcEndpointId')  # TODO how about a for loop
    aws ec2 delete-vpc-endpoints  \
        --vpc-endpoint-ids "$vpce_id" \
        --output json | \
        jq '.Unsuccessful'
        # TODO check how should we handle the response
        # I think it would be appropriate to do something like
        # if unsuccessful: echo unable to delete the VPC Endpoint $vpce_id
        # else: deleted VPC Endpoint: $vpce_id
}

function delete_subnet () {
    tag_name_complement=$1
    subnet_id="$(aws ec2 describe-subnets \
        --filters \
            Name=vpc-id,Values="$vpc_id" \
            Name=tag:Name,Values="$TAG_NAME-subnet-$tag_name_complement" \
            Name=availability-zone,Values=us-east-1a |
        jq -r '.Subnets[0].SubnetId')"
    aws ec2 delete-subnet \
        --subnet-id "$subnet_id"
    echo "Deleted Subnet: $subnet_id"
}

echo "Destroying VPC resources..."

vpc_id="$(aws ec2 describe-vpcs \
    --filters Name=tag:Name,Values="$TAG_NAME-vpc" |
    jq -r '.Vpcs[0].VpcId')"

delete_vpc_endpoints

#delete_subnet "public1"
#delete_subnet "private1"
#delete_subnet "public2"
#delete_subnet "private2"

aws ec2 delete-vpc \
    --vpc-id "$vpc_id"
echo "Deleted VPC: $vpc_id!"

echo "Successfully destroyed VPC resources!"
