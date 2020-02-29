#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 XCODE_PATH"
  exit 1
fi

output_dir="$PWD/docs"
readme="$(cat "$output_dir/README.md")"
rm -rf "$output_dir"
./export.sh "$1" "$output_dir"
pushd "$output_dir"
../generate-index.sh
echo "$readme" > README.md
