#!/bin/bash

INPUT_DIR=svg
OUTPUT_DIR=pdf
mkdir -p $OUTPUT_DIR

for FIGURE in "$@"; do
    echo "Exporting PDF for $FIGURE"
    INPUT="${INPUT_DIR}"/$(basename "${FIGURE/.svg/.svg}")
    OUTPUT="${OUTPUT_DIR}"/$(basename "${FIGURE/.svg/.pdf}")
    inkscape --export-type=pdf -o "$OUTPUT" "$INPUT" 2> /dev/null
done
