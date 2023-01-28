#!/bin/bash

# Check if 2 args are present
if [ "$#" -ne 2 ]; then
  echo "Error: Two arguments are required, you passed $#"
  echo "./expose_service <service_name> <external_port>"
  exit 1
fi

# Initial params
service_name=$1   # First param
external_port=$2  # Second param

# Get service port by service name
service_port=$(minikube service $service_name --url | cut -d':' -f3)


# Check if service is found
if [[ -z "$service_port" ]]; then
  echo "Error: Service not found"
  exit 1
fi

if ! [[ "$external_port" -ge 1024 && "$external_port" -le 65535 ]]; then
  echo "Error: Variable external_port is out of range (1024-65535)"
  exit 1
fi

# SSH COMMAND EXPLAINED

# -i = private key
# -f = run in background
# -N = not execute a remote command.  This is useful for just forwarding ports.
# -L = Port forwarding

ssh -S /tmp/test -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -f -NL \*:${external_port}:0.0.0.0:${service_port}
