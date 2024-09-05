ROOT_DIR=$(pwd)
CURRENT_DATE=$(shell date '+%Y%m%d')
SVG_FILES=$(shell find svg -maxdepth 1 -regextype posix-extended -regex '.*Figure[[:digit:]]+\w?\.svg' -o -regex '.*FigureS[[:digit:]]+\w?\.svg' | sort)
MAIN_FIGURES=$(shell find svg -maxdepth 1 -regextype posix-extended -regex '.*Figure[[:digit:]]+\w?\.svg' | sort)
SUPP_FIGURES=$(shell find svg -maxdepth 1 -regextype posix-extended -regex '.*FigureS[[:digit:]]+\w?\.svg' | sort)
MINIFY ?= FALSE
DPI ?= 600
NEWSPRINT ?= TRUE

.PHONY: all pdf-trimmed clean

all: pdf-trimmed png newsprint

minify:
	@echo "Minifying SVG figures."
	bash scripts/minify_svg.sh $(SVG_FILES)

pdf:
	@echo "Exporting figures into PDF"
	bash scripts/export_pdf.sh svg $(SVG_FILES)
	pdfunite $(MAIN_FIGURES:svg=pdf) MainFigures.${CURRENT_DATE}.pdf
	pdfunite $(SUPP_FIGURES:svg=pdf) SupplementaryFigures.${CURRENT_DATE}.pdf
	pdfunite MainFigures.${CURRENT_DATE}.pdf SupplementaryFigures.${CURRENT_DATE}.pdf AllFigures.${CURRENT_DATE}.pdf

pdf-trimmed: pdf
	@echo "Producing trimmed, unlabeled figures"
	bash scripts/export_trimmed.sh $(SVG_FILES)
	pdfunite $(MAIN_FIGURES:svg=pdf/.trimmed.pdf) MainFigures.${CURRENT_DATE}.trimmed.pdf
	pdfunite $(SUPP_FIGURES:svg=pdf/.trimmed.pdf) SupplementaryFigures.${CURRENT_DATE}.trimmed.pdf
	pdfunite MainFigures.${CURRENT_DATE}.trimmed.pdf SupplementaryFigures.${CURRENT_DATE}.trimmed.pdf AllFigures.${CURRENT_DATE}.trimmed.pdf

png:
	@echo "Producing trimmed, unlabeled figures"
	bash scripts/export_png.sh $(DPI) $(SVG_FILES)

newsprint: png
	@echo "Generating newsprint figures"
	bash scripts/export_newsprint.sh $(SVG_FILES)

clean_svg_minified:
	@echo "Cleaning up minified SVG figures"
	-rm -r svg_minified

clean_pdf:
	@echo "Cleaning up PDF figures"
	-rm -r pdf

clean_png:
	@echo "Cleaning up PNG figures"
	-rm -r png

clean_newsprint:
	@echo "Cleaning up newsprint figures"
	-rm -r newsprint/

clean_join:
	@echo "Cleaning up joined figures"
	-rm MainFigures.*.pdf
	-rm SupplementaryFigures.*.pdf
	-rm AllFigures.*.pdf

clean: clean_svg_minified clean_pdf clean_png clean_newsprint clean_join
	@echo "Cleaning up files"
