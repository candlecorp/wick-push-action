#!/bin/bash -l

set -e

manifest_path="$1"
latest="$2"
registry_username="$3"
registry_password="$4"

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

latest_flag=""

if [ "$latest" = "true" ]; then
    latest_flag="--latest"
fi

wick registry push "$(basename "$bus_path")" $latest_flag | grep -Eo 'reference="(.*)"' | cut -d '"' -f2 | head -1