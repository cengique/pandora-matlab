SHELL=/bin/bash
EPSFILES=Dataset-classes.eps \
data-wrapper-diagram.eps \
DB-classes.eps \
db-overview.eps \
plots.eps \
Profiles.eps \

PSTEXFILES= 
PDFFILES=Dataset-classes.pdf \
data-wrapper-diagram.pdf \
DB-classes.pdf \
db-overview.pdf \
plots.pdf \
Profiles.pdf \


all_pdf: $(PDFFILES)


%.pdf: %.eps
	@echo "Converting $< to $@."
	base=$<; base=$${base%%.eps}; \
	epstopdf  $< 


%.pdf: %.pstex
	echo -e "%s/\.pstex//g\n:wq\n" | ex $<_t || echo; # Patch the TeX file
	base=$<; base=$${base%%.pstex}; \
	epstopdf  $< 
