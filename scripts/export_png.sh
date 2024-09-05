#!/bin/bash

INPUT_DIR=svg
OUTPUT_DIR=png
mkdir -p $OUTPUT_DIR

DPI=$1
shift

for FIGURE in "$@"; do
    echo "Exporting PNG for $FIGURE"
    INPUT="${INPUT_DIR}"/$(basename "${FIGURE}")
    TMP="${OUTPUT_DIR}"/$(basename "${FIGURE/.svg/.trimmed.svg}")
    OUTPUT="${OUTPUT_DIR}"/$(basename "${FIGURE/.svg/.png}")
    NUM=`echo $FIGURE | tr -dc '0-9'`
    if [[ "$FIGURE" == *"FigureS"* ]]; then
        sed "s/Supplementary Figure $NUM//g" $INPUT > ${TMP}
    else
        sed "s/Figure $NUM//g" $INPUT > ${TMP}
    fi
    if [ ! -f "$INPUT" ]; then
        echo "Could not find $INPUT"
        continue
    fi
    inkscape \
       --export-area-drawing \
       --export-margin=5 \
       --export-background=white \
       --export-dpi=$DPI \
       --export-type=png \
       -o $OUTPUT \
       $TMP

    rm ${TMP}
done
