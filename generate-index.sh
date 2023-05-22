#!/bin/bash

set -euo pipefail

version="$1"
header="<!DOCTYPE html>
<html>
<head>
  <title>Xcode's man pages</title>
  <style>
    body { font-family: sans-serif; }
    h1, h2, h3, h4, h5, h6 { font-family: serif; }
    .col ul { margin-top: 0; } 
    .col { column-width: 20em; overflow-wrap: anywhere; hyphens: auto; } 
  </style>
</head>
<body>
<h1>Xcode $version</h1>
"

footer="</body>"

output=index.html
echo "$header" > "$output"

rm -r _tmp &>/dev/null || true
mkdir -p _tmp

for file in *.html
do
  [[ -f $file ]] || continue
  name="${file%.html}"
  section="${name##*.}"
  printf "<li><a href='%s'>%s</a>\\n" "$file" "$name" >> "_tmp/$section"
done
rm _tmp/index

# Emit TOC
{
  printf '<ul>\n'
  for part in _tmp/*
  do
    section="${part##_tmp/}"
    printf '<li><a href="#s.%s">Section %s</a>\n' "$section" "$section"
  done
  printf '</ul>\n'
} >> "$output"

# Emit sections
for part in _tmp/*
do
  {
    section="${part##_tmp/}"
    printf '<h2 id="s.%s">Section %s</h2>\n' "$section" "$section"
    printf '<div class="col"><ul>\n'
    cat -- "$part"
    printf '</div></ul>\n'
  } >> "$output"
done
rm -r _tmp

echo "$footer" >> "$output"
../add_custom_css.py "$output"
