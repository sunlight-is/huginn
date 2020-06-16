#!/bin/bash
set -ev

# Build docker image
docker build --tag=$DOCKER_IMAGE -f docker/multi-process/Dockerfile .

# AWS Login
aws ecr get-login --no-include-email --region $AWS_REGION --profile $AWS_PROFILE | /bin/bash

# Add AWS repo tag
docker tag $DOCKER_IMAGE:latest $AWS_URI_REPOSITORY:latest

# Push image to ECS
docker push $AWS_URI_REPOSITORY:latest

# Deploy service
aws ecs update-service --region $AWS_REGION --cluster $AWS_CLUSTER --service $AWS_SERVICE --force-new-deployment
