#!/usr/bin/env bash

set -x

set -euo pipefail

# There are a few issues with the man pages in Xcode that requires special handling
# - Some man pages like LD have non utf-8 characters that have to be discarded with iconv -c (FB7607115)
# - There are some links from man pages that man can't handle (FB7607158)
# No tool I could find could handle all the formats here, so we attempt to use one, before falling bacak to another

xcode_path="$1"
script_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$xcode_path"
output_dir="$2"
mkdir -p "$output_dir"

mapfile -t directories < <(fd "\bman\b" -t d -E node_modules)
for directory in "${directories[@]}"
do
  mapfile -t files < <(fd . -t f "$directory")
  for file in "${files[@]}"
  do
    # It seems like all the files with bad links link to something in this dir
    if [[ "$(head -1 "$file")" == *acfs.fs* ]]; then
      continue
    fi

    output_path="$output_dir/$(basename "$file").html"
    (timeout 5 bsdman -Thtml "$file" > "$output_path" \
      || (echo "warning: invalid man page: $file" && exit 1)) && \
      "$script_root/add_custom_css.py" "$output_path"
  done

  sleep 1
done

echo "Exported to $output_dir"
