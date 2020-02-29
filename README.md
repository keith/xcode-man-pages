# xcode-man-pages

A HTML export of Xcode's man pages. Useful for diffing tools between
Xcode releases.

## Usage

```sh
brew install groff mandoc
brew link --overwrite mandoc
./export.sh /path/to/Xcode.app
```
