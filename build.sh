#!/usr/bin/env bash
# "Build" script for exporting datapacks and mod jars for 1.21.1 and 1.20.1

set -euo pipefail

VERSION="1.0.0"
outfile() { echo "$BUILD/create_sa-tags-$VERSION+$1"; }

ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD="$ROOT/build"
TEMP="$(mktemp -d)"

cleanup() { rm -rf "$TEMP"; }
trap cleanup EXIT

convert_to_1201() {
  local dir="$1"
  cd "$dir"
  find . -depth -type d -name item | while IFS= read -r d; do
    mv "$d" "${d%item}items"
  done
  sed -i 's/"pack_format": [0-9]*/"pack_format": 15/' pack.mcmeta
}

prepare() {
  local target_dir="$1"
  mkdir -p "$target_dir"
  cp -r "$ROOT/data" "$ROOT/LICENSE" "$ROOT/pack.mcmeta" "$ROOT/pack.png" "$target_dir"
}

package() {
  local target_dir="$1"
  local mcver="$2"
  local ext="$3"

  cd "$target_dir"
  zip -r "$(outfile "$mcver").$ext" . > /dev/null
}

# Datapacks
prepare "$TEMP/dp-1211"
package "$TEMP/dp-1211" "1.21.1" "zip"

prepare "$TEMP/dp-1201"
convert_to_1201 "$TEMP/dp-1201"
package "$TEMP/dp-1201" "1.20.1" "zip"

# Mods
prepare "$TEMP/mod-1211"
cp -r "$ROOT/META-INF" "$TEMP/mod-1211"
package "$TEMP/mod-1211" "1.21.1" "jar"

prepare "$TEMP/mod-1201"
cp -r "$ROOT/META-INF" "$TEMP/mod-1201"
convert_to_1201 "$TEMP/mod-1201"
package "$TEMP/mod-1201" "1.20.1" "jar"
