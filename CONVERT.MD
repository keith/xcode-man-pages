# Converting Pages to a Different Format

It may be that the format of the man pages isn't ideal for certain applications. To fix this issue, they'll need to be converted en masse to Markdown, LaTex, or some other document format. One of the easiest ways to do this is using a universal markup converter -- in the below instructions we will use ![pandoc](github.com/jgm/pandoc).

Start all of the following by cloning the `xcode-man-pages` repo to your machine.

```bash
git clone https://github.com/keith/xcode-man-pages.git
```

## Installation

Pandoc can be installed from their official repo, ![located here](github.com/jgm/pandoc) or from their website, ![located here](https://pandoc.org). Follow the instructions applicable to your platform.

### Converting -- Markdown

1) Change to the man pages directory.

```bash
cd xcode-man-pages/
```

2) Loop through the man pages and convert them individually.

```bash
mkdir docs-md
for file in docs/*.html; do
    echo "Processing $file..."
    pandoc "$file" \
    -f html \
    -t gfm \
    --wrap=none \
    --markdown-headings=atx \
    -o "docs-md/$(basename "$file" .html).md"
done
```
