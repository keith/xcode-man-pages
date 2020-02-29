#!/bin/bash

set -euo pipefail

xcode_path="$1"
version_file="$xcode_path/Contents/version.plist"

major_version="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$version_file")"
build_version="$(/usr/libexec/PlistBuddy -c "Print :ProductBuildVersion" "$version_file")"
echo "$major_version ($build_version)"
