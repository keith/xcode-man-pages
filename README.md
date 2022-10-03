# xcode-man-pages

A HTML export of all Apple's man pages that are bundled with Xcode. Useful for diffing tools between
Xcode releases, and for having an updated version of them online.

[View them here](https://keith.github.io/xcode-man-pages/)

## Usage

```sh
brew install groff mandoc coreutils
brew link --overwrite mandoc
./export.sh /path/to/Xcode.app
```
