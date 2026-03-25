#!/usr/bin/env bash
# Generate favicon / PWA icons from one SVG for tar1090 HTML staging.
# Usage: generate_web_icons.sh <html_staging_dir> <install_path>
#
# Source: <install_path>/customIcon.svg if present, else <staging>/images/favicon.svg
# Writes: images/icon.svg, images/favicon.png (32×32),
#         images/apple-touch-icon.png (180×180 on white), images/icon-192.png,
#         images/icon-512.png
#
# Requires rsvg-convert (librsvg2-bin) and/or ImageMagick for rasterization.

set -euo pipefail

TMP="${1:?}"
IPATH="${2:?}"
IMG="$TMP/images"
RSVG=""
MAGICK=""

if command -v rsvg-convert &>/dev/null; then
    RSVG=rsvg-convert
elif command -v rsvg-convert-qt &>/dev/null; then
    RSVG=rsvg-convert-qt
fi

if command -v magick &>/dev/null; then
    MAGICK=magick
elif command -v convert &>/dev/null; then
    MAGICK=convert
fi

if [[ -f "$IPATH/customIcon.svg" ]]; then
    SRC_SVG="$IPATH/customIcon.svg"
elif [[ -f "$IMG/favicon.svg" ]]; then
    SRC_SVG="$IMG/favicon.svg"
else
    echo "generate_web_icons.sh: no SVG source (expected $IPATH/customIcon.svg or $IMG/favicon.svg)" >&2
    exit 0
fi

mkdir -p "$IMG"
cp -f "$SRC_SVG" "$IMG/icon.svg"

png_from_svg() {
    # args: width height out_png [background]
    local w="$1" h="$2" out="$3"
    local bg="${4:-}"

    if [[ -n "$RSVG" ]]; then
        if [[ -n "$bg" ]]; then
            "$RSVG" -b "$bg" -w "$w" -h "$h" "$SRC_SVG" -o "$out"
        else
            # Explicit transparent page (some older rsvg defaulted PNG to white without -b)
            "$RSVG" -b none -w "$w" -h "$h" "$SRC_SVG" -o "$out"
        fi
        return 0
    fi

    if [[ -n "$MAGICK" ]]; then
        if [[ -n "$bg" ]]; then
            "$MAGICK" -size "${w}x${h}" "xc:${bg}" \( "$SRC_SVG" -resize "${w}x${h}" \) -gravity center -composite "$out"
        else
            # PNG32 forces RGBA so transparency survives IM SVG rasterization quirks
            "$MAGICK" -background none -alpha set "$SRC_SVG" -resize "${w}x${h}" "PNG32:${out}"
        fi
        return 0
    fi

    return 1
}

if ! png_from_svg 32 32 "$IMG/favicon.png"; then
    echo "generate_web_icons.sh: install librsvg2-bin or ImageMagick to build icons from SVG" >&2
    exit 0
fi

png_from_svg 192 192 "$IMG/icon-192.png" || true
png_from_svg 512 512 "$IMG/icon-512.png" || true
# iOS: artwork on white canvas (rsvg -b white; magick composite above)
png_from_svg 180 180 "$IMG/apple-touch-icon.png" "#ffffff" || png_from_svg 180 180 "$IMG/apple-touch-icon.png" white || true

exit 0
