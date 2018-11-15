#!/bin/bash

# GET DOCKER PARAMS
DOCKER_REGISTRY_URL="$(/usr/local/bin/aws --output text ssm get-parameter --name ops-ci-docker-hub-url --query 'Parameter'.Value)"
DOCKER_REGISTRY_AUTH="$(/usr/local/bin/aws --output text ssm get-parameter --name ops-ci-docker-hub-auth --with-decryption --query 'Parameter'.Value)"
DOCKER_REGISTRY_EMAIL="$(/usr/local/bin/aws --output text ssm get-parameter --name ops-ci-docker-hub-email --query 'Parameter'.Value)"


# UPDATE ECS AGENT CONFIG
cat << EOF >> /etc/ecs/ecs.config
ECS_CLUSTER=${ecs_cluster_name}
ECS_ENGINE_AUTH_TYPE=dockercfg
ECS_ENGINE_AUTH_DATA={"$DOCKER_REGISTRY_URL":{"auth":"$DOCKER_REGISTRY_AUTH","email":"$DOCKER_REGISTRY_EMAIL"}}
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
EOF


# UPDATE DOCKER CONFIG
sed -i "/^OPTIONS/c\OPTIONS=\"--default-ulimit nofile=1024:4096 \
                               --log-driver awslogs \
                               --log-opt awslogs-group=/aws/ecs/\${ecs_cluster_name} \
                               --log-opt tag={{.Name}}/{{.ID}}\"" \
                               /etc/sysconfig/docker


service docker restart
stop ecs
start ecs
