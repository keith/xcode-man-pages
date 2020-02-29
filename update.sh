#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 XCODE_PATH"
  exit 1
fi

xcode_path="$1"
output_dir="$PWD/docs"
rm -rf "$output_dir"

./export.sh "$xcode_path" "$output_dir"
version="$(./get-xcode-version.sh "$xcode_path")"

pushd "$output_dir"
../generate-index.sh "$version"
echo "---
permalink: /index.html
---
" > README.md
