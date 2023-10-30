#!/bin/bash -l

set -e

manifest_path="$1"
registry_username="$2"
registry_password="$3"
IFS=' ' read -r -a tags <<< "$4"

if [ -z "$manifest_path" ] || [ -z "$registry_username" ] || [ -z "$registry_password" ]; then
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

#create additional tags list for image
tag_flags=""
for tag in "${tags[@]}"
do
    tag_flags="$tag_flags --tag=$tag"
done

# Store the output in a variable and capture both stdout and stderr
output=$(wick registry push "$(basename "$manifest_path")" $tag_flags 2>error.log)

# Check the exit status of the wick command
if [[ $? -ne 0 ]]; then
  echo "Error: wick command failed with output:" >&2
  cat error.log >&2
  exit 1
fi

# Process the output with your sequence of commands
processed_output=$(echo "$output" | grep 'reference' | grep -E '"(\S*)"' | cut -d '"' -f2 | head -1)
echo $processed_output

# Write the processed output to the GITHUB_OUTPUT environment file
echo "reference=$processed_output" >> "$GITHUB_OUTPUT"
