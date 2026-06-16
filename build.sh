#!/usr/bin/env bash
# "Build" script for exporting both 1.21.1 and 1.20.1 versions

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD="$ROOT/build"
TEMP="$(mktemp -d)"

cleanup() { rm -rf "$TEMP"; }
trap cleanup EXIT

cp -r "$ROOT/data" "$ROOT/LICENSE" "$ROOT/pack.mcmeta" "$ROOT/pack.png" "$TEMP"

cd "$TEMP"

zip -r "$BUILD/create_sa-tags-1.21.1.zip" . > /dev/null

find . -depth -type d -name item | while IFS= read -r d; do
  mv "$d" "${d%item}items"
done

sed -i 's/"pack_format": [0-9]*/"pack_format": 15/' pack.mcmeta

zip -r "$BUILD/create_sa-tags-1.20.1.zip" . > /dev/null
