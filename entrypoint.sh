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

latest_flag=""

if [ "$latest" = "true" ]; then
    latest_flag="--latest"
fi

wick registry push "$(basename "$manifest_path")" $latest_flag | grep -Eo 'reference="(\S*)"' | cut -d '"' -f2 | head -1

# # Store the output in a variable
# output=$()
# echo $output

# # Write the output to the GITHUB_OUTPUT environment file
# echo "reference=$output" >> "$GITHUB_OUTPUT"