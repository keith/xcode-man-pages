#!/bin/bash

set -euo pipefail

version="$1"
header="<!DOCTYPE html>
<html>
<head>
  <title>Xcode's man pages</title>
</head>
<body>
<h1>Xcode $version</h1>
"

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
