# Technical Details

## External Libraries

### zstd Decompression
To boost performance and lower bandwidth, tar1090 uses the following library for decompressing `zstd` compressed data payloads directly in the browser:

<https://github.com/wiedehopf/zstddec-tar1090>
