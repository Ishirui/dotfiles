#!/bin/sh
# Usage: ./toggle-hdr.sh <output-name>
# Example: ./toggle-hdr.sh DP-2

set -euo pipefail

OUTPUT="DP-3"

# Get HDR status for the specified output
HDR_STATUS=$(kscreen-doctor --outputs | \
    grep -i "$OUTPUT" -A 20 | \
    grep -i 'hdr:' | \
    sed 's/\x1b\[[0-9;]*m//g' | \
    awk -F: '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print tolower($2)}')

if [[ "$HDR_STATUS" == "enabled" ]]; then
    echo "HDR is enabled on $OUTPUT. Disabling..."
    kscreen-doctor "output.$OUTPUT.hdr.disable"
    # Script assumes you want wide color gamut off for SDR content
    # if that is not the case, remove this line
    kscreen-doctor "output.$OUTPUT.wcg.disable"
elif [[ "$HDR_STATUS" == "disabled" ]]; then
    echo "HDR is disabled on $OUTPUT. Enabling..."
    kscreen-doctor "output.$OUTPUT.hdr.enable"
    kscreen-doctor "output.$OUTPUT.wcg.enable"
else
    echo "Could not determine HDR status for $OUTPUT. Got: '$HDR_STATUS'"
    exit 1
fi
