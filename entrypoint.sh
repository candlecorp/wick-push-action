#!/bin/bash -l

set -e

manifest_path="$1"
latest="$2"
registry_username="$3"
registry_password="$4"

if [ -z "$manifest_path" ] || [ -z "$latest" ] || [ -z "$registry_username" ] || [ -z "$registry_password" ]; then
  echo "Error: missing or empty input variables"
  exit 1
fi

export OCI_USERNAME="$registry_username"
export OCI_PASSWORD="$registry_password"

cd /github/workspace

if [ ! -f "$manifest_path" ]; then
  echo "Error: wick file not found at $manifest_path"
  exit 1
fi

#change directory to the containing directory of wick file
manifest_dir=$(dirname "$manifest_path")
cd "$manifest_dir"
echo "PWD is $(pwd)"

latest_flag=""

if [ "$latest" = "true" ]; then
    latest_flag="--latest"
fi

echo "$(basename "$bus_path")"

wick registry push "$(basename "$bus_path")" $latest_flag | grep -Eo 'reference="(.*)"' | cut -d '"' -f2 | head -1