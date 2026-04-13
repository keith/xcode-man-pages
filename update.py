#!/usr/bin/env python3

import collections
import http.client
import json
import plistlib
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path


def get_xcode_version(xcode_path: str) -> str:
    plist_path = Path(xcode_path) / "Contents/version.plist"
    with plist_path.open("rb") as f:
        plist = plistlib.load(f)

    full_version = plist["CFBundleShortVersionString"]
    build_number = plist["ProductBuildVersion"]

    response: http.client.HTTPResponse = urllib.request.urlopen(
        "https://xcodereleases.com/data.json"
    )
    if response.getcode() != 200:
        raise SystemExit(
            f"error: got unexpected status code: {response.getcode()}: {response.read()}"
        )

    complete_version_info = collections.defaultdict(dict)
    response_json = json.loads(response.read())
    for blob in response_json:
        version_info = blob["version"]
        if version_info["build"] == build_number:
            complete_version_info[build_number]["number"] = version_info["number"]
            complete_version_info[build_number].update(version_info["release"])

    version_info = complete_version_info[build_number]
    extra_info = ""
    if version_info:
        if version_info.get("release"):
            pass
        elif beta_version := version_info.get("beta"):
            extra_info = f" beta {beta_version}"
        elif rc_version := version_info.get("rc"):
            extra_info = f" RC {rc_version}"
    else:
        print("warning: could not find version information, it might not be on xcodereleases.com yet")
        print("enter any extra version information (e.g. 'beta 1' or 'RC 2'):")
        try:
            extra_info = input().strip()
        except (KeyboardInterrupt, EOFError):
            sys.exit(1)
        if extra_info:
            extra_info = f" {extra_info}"

    return f"Xcode {full_version}{extra_info} ({build_number})"


def main() -> None:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} XCODE_PATH", file=sys.stderr)
        sys.exit(1)

    xcode_path = sys.argv[1]
    repo_dir = Path(__file__).resolve().parent
    version = get_xcode_version(xcode_path)
    print(f"Will use version: '{version}'")

    output_dir = repo_dir / "docs"
    shutil.rmtree(output_dir, ignore_errors=True)

    subprocess.check_call([str(repo_dir / "export.sh"), xcode_path, output_dir])

    subprocess.check_call([str(repo_dir / "generate-index.sh"), version], cwd=output_dir)
    (output_dir / "README.md").write_text("---\npermalink: /index.html\n---\n\n")

    subprocess.check_call([str(repo_dir / "cleanup.sh")], cwd=repo_dir)
    subprocess.check_call(["git", "add", "-A"], cwd=repo_dir)
    subprocess.check_call(["git", "commit", "-m", version], cwd=repo_dir)


if __name__ == "__main__":
    main()
