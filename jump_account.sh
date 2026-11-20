#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <organization-member-name>" >&2
    exit 1
fi

ORGANIZATION_MEMBER_NAME=$1

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

ACCOUNT_ID=$(aws organizations list-accounts --query "Accounts[?Name=='${ORGANIZATION_MEMBER_NAME}'].Id" --output text)

echo "Switching to account: ${ORGANIZATION_MEMBER_NAME} (ID: ${ACCOUNT_ID})"

SESSION=$(aws sts assume-role --role-arn arn:aws:iam::${ACCOUNT_ID}:role/OrganizationAccountAccessRole --role-session-name "AssumeRoleSession")

export AWS_ACCESS_KEY_ID=$(echo $SESSION | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $SESSION | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $SESSION | jq -r '.Credentials.SessionToken')
