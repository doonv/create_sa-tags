#!/usr/bin/env bash
# "Build" script for exporting both 1.21.1 and 1.20.1 versions

set -euo pipefail

VERSION="1.0.0"
title() {
  local mc_version="$1"

  echo "$BUILD/create_sa-tags-$VERSION+$mc_version.zip"
}


ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD="$ROOT/build"
TEMP="$(mktemp -d)"

cleanup() { rm -rf "$TEMP"; }
trap cleanup EXIT

cp -r "$ROOT/data" "$ROOT/LICENSE" "$ROOT/pack.mcmeta" "$ROOT/pack.png" "$TEMP"

cd "$TEMP"

zip -r "$(title "1.21.1")" . > /dev/null

find . -depth -type d -name item | while IFS= read -r d; do
  mv "$d" "${d%item}items"
done

sed -i 's/"pack_format": [0-9]*/"pack_format": 15/' pack.mcmeta

zip -r "$(title "1.20.1")" . > /dev/null
