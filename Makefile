# pandora autoconf file.
# Cengiz Gunay 2007-08-08

SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .c

TARNAME = pandora
VERSION = 1.2b

DIRNAME = $(TARNAME)-$(VERSION)
DOCDIR = $(DIRNAME)-htmldoc

PLOTPKGNAME = cgmplot
PLOTDIRNAME = $(PLOTPKGNAME)-$(VERSION)

STGWWWDIR = ~/public_html/userwww/pandora/

all: 

dist: 
	mkdir $(DIRNAME)
	cp -a classes $(DIRNAME)/pandora
	cp -a functions/* $(DIRNAME)/pandora
	mkdir $(DIRNAME)/doc
	cp -a doc/prog-manual.pdf $(DIRNAME)/doc
	cp README.dist $(DIRNAME)/README.txt
	cp COPYING $(DIRNAME)
	tar -cz --exclude .svn --exclude *~ -f $(DIRNAME).tar.gz $(DIRNAME)
	rm $(DIRNAME).zip
	zip -rq $(DIRNAME).zip $(DIRNAME) -x "*/.svn/*" -x "*~"
	rm -rf $(DIRNAME)

distdochtml: doc/website/html
	mkdir $(DOCDIR)
	cp -a doc/website/html/* $(DOCDIR)
	tar -czf $(DOCDIR).tar.gz $(DOCDIR)
	rm -rf $(DOCDIR)

distclean:
	rm -f *~
	rm -rf $(DIRNAME)
	rm -rf $(DOCDIR)

distplots:
	mkdir $(PLOTDIRNAME)
	cp README.cgmplot.dist $(PLOTDIRNAME)/README
	cp COPYING $(PLOTDIRNAME)
	mkdir $(PLOTDIRNAME)/$(PLOTPKGNAME)
	cp -a classes/\@plot_* functions/*  $(PLOTDIRNAME)/$(PLOTPKGNAME)/
	tar -cz --exclude .svn -f $(PLOTDIRNAME).tar.gz $(PLOTDIRNAME)
	rm -rf $(PLOTDIRNAME)

stgwww:
	cp -ur doc/website/* $(STGWWWDIR)
	cp -a $(DIRNAME)[.\-]* $(STGWWWDIR)
	cp -a doc/prog-manual.pdf $(STGWWWDIR)
	cp -a CHANGES $(STGWWWDIR)

clean: 

