#!/bin/bash

HERE=$(cd $(dirname "$0") && pwd)
PACKAGE=$(basename "$HERE")
DIST="$HERE/dist"
ARCHIVE="$DIST/$PACKAGE.zip"
GENERATE="$HERE/generate.sh"

# Generate code if generate.sh present.
[ -x "$GENERATE" ] && "$GENERATE" || exit 1

mkdir -p "$DIST"
rm -f "$ARCHIVE"
cd "$HERE/src/" && zip -r "$ARCHIVE" . > /dev/null

echo "ZIPPING $ARCHIVE"
