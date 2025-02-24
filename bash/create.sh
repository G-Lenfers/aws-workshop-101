#!/bin/bash

aws ec2 create-vpc \
    --cidr-block 10.1.0.0/24 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=aws-101-cli-vpc}]'
