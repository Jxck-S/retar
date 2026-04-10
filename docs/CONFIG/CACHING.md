# Caching Configuration

This document covers notes and instructions regarding caching for retar/tar1090 to ensure optimal performance and avoid stale data issues.

## Cloudflare

When hosting a website with tar1090 via CF, CF needs to respect the various cache headers otherwise there will be caching issues.
Change Browser Cache TTL from the default of 4h to "Respect Existing Headers":
Caching -> Configuration -> Browser Cache TTL -> Respect Existing Headers
