#!/bin/bash

INPUT_DIR=svg
OUTPUT_DIR=svg_minified
mkdir -p $OUTPUT_DIR

for FIGURE in "$@"; do
    echo "Minifying $FIGURE"
    minify --type svg --svg-precision 3 \
        --output "${FIGURE/$INPUT_DIR/$OUTPUT_DIR}" \
        "$FIGURE" \
        > /dev/null
done
