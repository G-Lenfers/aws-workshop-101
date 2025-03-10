#!/bin/bash

TAG_NAME="aws-101-cli"
REGION="us-east-1"

function get_vpc_id () {
    aws ec2 describe-vpcs \
        --filters Name=tag:Name,Values="$TAG_NAME-vpc" |
        jq -r '.Vpcs[0].VpcId'
}

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
    _vpc_id=$1
    _availability_zone=$2
    _tag_name_complement=$3
    subnet_id="$(aws ec2 describe-subnets \
        --filters \
            Name=vpc-id,Values="$_vpc_id" \
            Name=tag:Name,Values="$TAG_NAME-subnet-$_tag_name_complement" \
            Name=availability-zone,Values="$REGION$_availability_zone" |
        jq -r '.Subnets[0].SubnetId')"
    aws ec2 delete-subnet \
        --subnet-id "$subnet_id"
    echo "Deleted Subnet: $subnet_id"
}

function delete_vpc () {
    _vpc_id=$1
    aws ec2 delete-vpc \
        --vpc-id "$_vpc_id"
    echo "Deleted VPC: $_vpc_id!"
}


echo "Destroying VPC resources..."

vpc_id="$(get_vpc_id)"

delete_vpc_endpoints

delete_subnet "$vpc_id" "a" "public1"
delete_subnet "$vpc_id" "a" "private1"
delete_subnet "$vpc_id" "b" "public2"
delete_subnet "$vpc_id" "b" "private2"

delete_vpc "$vpc_id"

echo "Successfully destroyed VPC resources!"
