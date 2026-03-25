#!/usr/bin/env bash
# Generate favicon / PWA icons from one SVG for tar1090 HTML staging.
# Usage: generate_web_icons.sh <html_staging_dir> <install_path>
#
# Source: <install_path>/customIcon.svg overwrites <staging>/images/icon.svg; else bundled icon.svg
# Overwrites images/icon.svg when customIcon.svg is present; always (re)writes:
#   images/favicon.png (32×32), images/apple-touch-icon.png (180×180 on white),
#   images/icon-192.png, images/icon-512.png
#
# Deps: rsvg-convert (package librsvg2-bin on Debian/Ubuntu) and/or ImageMagick — see docs/icons.md

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

mkdir -p "$IMG"
if [[ -f "$IPATH/customIcon.svg" ]]; then
    cp -f "$IPATH/customIcon.svg" "$IMG/icon.svg"
elif [[ ! -f "$IMG/icon.svg" ]]; then
    echo "generate_web_icons.sh: no images/icon.svg in tree and no $IPATH/customIcon.svg" >&2
    exit 0
fi
SRC_SVG="$IMG/icon.svg"

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
            # Read SVG first, then operators (IM7 errors if -alpha runs before an image is loaded)
            "$MAGICK" -background none "$SRC_SVG" -alpha set -resize "${w}x${h}" "PNG32:${out}"
        fi
        return 0
    fi

    return 1
}

if ! png_from_svg 32 32 "$IMG/favicon.png"; then
    echo "generate_web_icons.sh: install librsvg2-bin (apt) / librsvg2-tools (dnf) for rsvg-convert, or imagemagick" >&2
    exit 0
fi

png_from_svg 192 192 "$IMG/icon-192.png" || true
png_from_svg 512 512 "$IMG/icon-512.png" || true
# iOS: artwork on white canvas (rsvg -b white; magick composite above)
png_from_svg 180 180 "$IMG/apple-touch-icon.png" "#ffffff" || png_from_svg 180 180 "$IMG/apple-touch-icon.png" white || true

exit 0
