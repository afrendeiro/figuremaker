#!/bin/bash

INPUT_DIR=png
OUTPUT_DIR=newsprint
mkdir -p $OUTPUT_DIR

convert_to_bw() {
    local input_file="$1"
    local output_file="${2:-${input_file/.png/.newsprint.png}}"

    gimp -i -b - <<EOF
(let* (
        (image (car (gimp-file-load RUN-NONINTERACTIVE "$input_file" "$input_file")))
        (drawable (car (gimp-image-get-active-layer image)))
    )
    (plug-in-newsprint RUN-NONINTERACTIVE image drawable
        4           ; cell-width (Screen cell width in pixels)
        0           ; colorspace (Grayscale)
        0           ; k-pullout (Percentage of black pullout, 0 for non-CMYK)
        75.0        ; gry-ang (Grey/black screen angle in degrees)
        3           ; gry-spotfn (Grey/black spot function, LINES = 1, DIAMOND = 3)
        0.0         ; red-ang (Red/cyan screen angle, not used in grayscale)
        0           ; red-spotfn (Red/cyan spot function, not used in grayscale)
        0.0         ; grn-ang (Green/magenta screen angle, not used in grayscale)
        0           ; grn-spotfn (Green/magenta spot function, not used in grayscale)
        0.0         ; blu-ang (Blue/yellow screen angle, not used in grayscale)
        0           ; blu-spotfn (Blue/yellow spot function, not used in grayscale)
        2           ; oversample (Times to oversample spot function)
    )
    (gimp-file-save RUN-NONINTERACTIVE image drawable "$output_file" "$output_file")
    (gimp-image-delete image)
)
(gimp-quit 0)
EOF
}

for FIGURE in "$@"; do
    echo "Exporting newsprint PNG for $FIGURE"
    INPUT="${INPUT_DIR}"/$(basename "${FIGURE/.svg/.png}")
    OUTPUT="${OUTPUT_DIR}"/$(basename "${FIGURE/.svg/.png}")
    if [ ! -f "$INPUT" ]; then
        echo "Could not find $INPUT"
        continue
    fi
    convert_to_bw "$INPUT" "$OUTPUT" > /dev/null 2>&1
done
