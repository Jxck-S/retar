#!/bin/bash
# How this cache busting works:
# 1. It calculates the MD5 checksum of specified static files (defaults from cachebust.list).
# 2. It renames those files to include the checksum in the filename (e.g., style.css -> style_checksum.css).
#    This "fingerprinting" ensures that if the file content changes, the filename changes, forcing the browser to fetch the new version.
# 3. It updates references to these renamed files inside 'script.js' and 'index.html' using sed.
# 4. It also handles 'script.js' specifically, renaming it and updating its reference in 'index.html'.


set -e
trap 'echo "[ERROR] Error in line $LINENO when executing: $BASH_COMMAND"' ERR

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo "ERROR: usage: ./cachebust.sh <path_to_cachebust.list> <tar1090_html_folder>"
    exit 1
fi

# most common way to use this:
# ./cachebust.sh cachebust.list <tar1090_html_folder>

LISTPATH="$1"
HTMLFOLDER="$2"

sedreplaceargs=()

function moveFile() {
    FILE=$1
    md5sum=$(md5sum "$FILE" | cut -d' ' -f1)
    prefix=$(cut -d '.' -f1 <<< "$FILE")
    postfix=$(cut -d '.' -f2 <<< "$FILE")
    newname="${prefix}_${md5sum}.${postfix}"
    mv "$FILE" "$newname"
    sedreplaceargs+=("-e" "s#${FILE}#${newname}#")
}

while read -r FILE; do
    moveFile "$FILE"
done < "$LISTPATH"

sed -i "${sedreplaceargs[@]}" "$HTMLFOLDER"/index.html
