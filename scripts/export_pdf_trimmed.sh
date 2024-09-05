#!/bin/bash

INPUT_DIR=svg
OUTPUT_DIR=pdf
mkdir -p $OUTPUT_DIR

for FIGURE in "$@"; do
    echo "Exporting PDF for $FIGURE"
    INPUT="${INPUT_DIR}"/$(basename "${FIGURE}")
    TMP="${OUTPUT_DIR}"/$(basename "${FIGURE/.svg/.trimmed.svg}")
    OUTPUT="${OUTPUT_DIR}"/$(basename "${FIGURE/.svg/.pdf}")
    NUM=$(echo $FIGURE | sed -n "s/^.*FigureS\{0,1\}\(.*\).svg$/\1/p")
    if [[ "$FIGURE" == *"FigureS"* ]]; then
        sed "s/Supplementary Figure $NUM//g" "$INPUT" > "${TMP}"
    else
        sed "s/Figure $NUM//g" "$INPUT" > "${TMP}"
    fi

    OUTPUT="${FIGURE/.svg/.trimmed.pdf}"
    inkscape --export-area-drawing --export-margin=5 --export-type=pdf -o "${OUTPUT}" "${TMP}" 2> /dev/null
    rm "${TMP}"
done
