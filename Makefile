# pandora autoconf file.
# Cengiz Gunay 2007-08-08

SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .c

TARNAME = pandora
VERSION = 1.0b
DIRNAME = $(TARNAME)-$(VERSION)

all: 

dist:
	mkdir $(DIRNAME)
	cp -a classes $(DIRNAME)/pandora
	cp -a functions/* $(DIRNAME)/pandora
	mkdir $(DIRNAME)/pandora/doc
	cp -a doc/prog-manual.pdf $(DIRNAME)/pandora/doc
	cp -a doc/html $(DIRNAME)/pandora/doc
	cp README.dist $(DIRNAME)/README
	cp COPYING $(DIRNAME)
	tar -czf $(DIRNAME).tar.gz $(DIRNAME)
	rm -rf $(DIRNAME)

clean: 
	rm -f $(TARGETS) readgenflac.mex* readgenflac.dll
