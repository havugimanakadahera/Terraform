#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <resource_group_name> <keyvault_name>"
  exit 1
fi

RG_NAME="$1"
KV_NAME="$2"

ID=$(az keyvault show --resource-group "${RG_NAME}" --name "${KV_NAME}" --query id -o tsv)

if [ -z "${ID}" ]; then
  echo "Key Vault not found"
  exit 2
fi

echo "${ID}"
