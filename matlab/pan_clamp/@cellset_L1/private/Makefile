SUBDIRS := $(shell find . -mindepth 0 -maxdepth 1 -type d \! -name ".*")

all:
	m4 $(EPS2PDFM4) > Makefile.auto; make -f Makefile.auto
	$(foreach dir, $(SUBDIRS), cd $(dir); m4 ../$(EPS2PDFM4) > Makefile.auto; make -f Makefile.auto; cd ..;)

