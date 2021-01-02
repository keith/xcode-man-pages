#!/usr/bin/env python3
import sys

_CSS = """
<style>
@media (prefers-color-scheme: dark) {
  body {
    background: #000;
    color: #d0d0d0;
  }

  a, a:visited {
    color: #1899eb;
  }
}
</style>
""".split("\n")

def _add_css(filepath: str) -> None:
    with open(filepath) as f:
        contents = f.read().splitlines()

    new_lines = []
    added = False
    for line in contents:
        new_lines.append(line)
        if line.strip() == "<head>":
            new_lines.extend(_CSS)
            added = True

    if not added:
        raise SystemExit(f"error: failed to add css to {filepath}")

    with open(filepath, "w") as f:
        f.write("\n".join(new_lines))
        f.write("\n")

if __name__ == "__main__":
    _add_css(sys.argv[1])
