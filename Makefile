# pandora autoconf file.
# Cengiz Gunay 2007-08-08

SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .c

TARNAME = pandora
VERSION = 1.1b

DIRNAME = $(TARNAME)-$(VERSION)
DOCDIR = $(DIRNAME)-htmldoc

all: 

dist: 
	mkdir $(DIRNAME)
	cp -a classes $(DIRNAME)/pandora
	cp -a functions/* $(DIRNAME)/pandora
	mkdir $(DIRNAME)/doc
	cp -a doc/prog-manual.pdf $(DIRNAME)/doc
	cp README.dist $(DIRNAME)/README
	cp COPYING $(DIRNAME)
	tar -cz --exclude .svn -f $(DIRNAME).tar.gz $(DIRNAME)
	rm -rf $(DIRNAME)

distdochtml: doc/html
	mkdir $(DOCDIR)
	cp -a doc/html/* $(DOCDIR)
	tar -czf $(DOCDIR).tar.gz $(DOCDIR)
	rm -rf $(DOCDIR)

distclean:
	rm -f *~
	rm -rf $(DIRNAME)
	rm -rf $(DOCDIR)

clean: 

