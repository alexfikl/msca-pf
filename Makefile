TEXMK?=latexmk
OUTDIR?=latex.out
TEXFLAGS?=-pdflua -output-directory=$(OUTDIR)
PDFFILES=\
	msca-pf-part-b1-template.pdf \
	msca-pf-part-b2-template.pdf

all: template

help: 								## Show this help
	@echo -e "Specify a command. The choices are:\n"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;36m%-12s\033[m %s\n", $$1, $$2}'
	@echo ""
.PHONY: help

template: $(PDFFILES)				## Compile template example
.PHONY: template

clean:								## Remove temporary compilation files
	rm -rf $(OUTDIR)
.PHONY: clean

purge: clean						## Remove all generated files
	rm -rf $(PDFFILES)
.PHONY: purge

%.pdf: %.tex
	PYTHONWARNINGS=ignore $(TEXMK) $(TEXFLAGS) $<
	cp $(OUTDIR)/$@ .
