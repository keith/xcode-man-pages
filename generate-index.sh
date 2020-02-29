#!/bin/bash

set -euo pipefail

header="<!DOCTYPE html>
<html>
<head>
  <title>Xcode's man pages</title>
</head>
<body>"

footer="</body>"

output=index.html
echo "$header" > "$output"

for file in $(find . -name "*.html" -type f | sort)
do
  name="${file:2}"
  name="${name%.*}"
  echo "- <a href='$file'>$name</a><br>" >> "$output"
done

echo "$footer" >> "$output"
