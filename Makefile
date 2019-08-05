
.SECONDARY:
.SECONDEXPANSION:

VERSION ?= 1.0.0

.phony: help tutorials

get-linux-deps: ##@Install Dependencies Linux
	curl -LO https://github.com/googlecodelabs/tools/releases/download/v2.2.0/claat-linux-amd64
	chmod +x claat-linux-amd64
	sudo mv claat-linux-amd64 /usr/local/bin/claat
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.56.3/hugo_extended_0.56.3_macOS-64bit.tar.gz
	tar -xf hugo_extended_0.56.3_linux-64bit.tar.gz hugo
	sudo mv hugo /usr/local/bin/hugo

get-mac-deps: ##@Install Dependencies MacOS		
	curl -LO https://github.com/googlecodelabs/tools/releases/download/v2.2.0/claat-darwin-amd64
	chmod +x claat-darwin-amd64
	mv claat-darwin-amd64 /usr/local/bin/claat
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.56.3/hugo_extended_0.56.3_Linux-64bit.tar.gz
	tar -xf hugo_extended_0.56.3_Linux-64bit.tar.gz hugo
	mv hugo /usr/local/bin/hugo
 

tutorial-all: ##@Build Build codelabs
	rm -Rf _codelabs && mkdir _codelabs
	cd tutorials/advisor-codelabs && make advisor-codelab-tutorials OUTDIR=$(CURDIR)/_codelabs

codelab-site: tutorial-all   ##@Build Build site
	rm -Rf $(CURDIR)/site/static/codelabs
	cp -R $(CURDIR)/_codelabs $(CURDIR)/site/static/
	mv  $(CURDIR)/site/static/_codelabs $(CURDIR)/site/static/codelabs
	cd $(CURDIR)/site && hugo --verboseLog -log -v --debug
	mkdir -p $(CURDIR)/docs && cp -R $(CURDIR)/site/docs/* $(CURDIR)/docs/ 

codelab-serve:   ##@Run Run site    
	cd $(CURDIR)/site && hugo serve -D --noHTTPCache

HELP_FUN = \
         %help; \
         while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^(.+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/ }; \
         print "Usage: make [options] [target] ...\n\n"; \
     for (sort keys %help) { \
         print "$$_:\n"; \
         for (sort { $$a->[0] cmp $$b->[0] } @{$$help{$$_}}) { \
             $$sep = " " x (30 - length $$_->[0]); \
             print "  $$_->[0]$$sep$$_->[1]\n" ; \
         } print "\n"; }

help: ##@Misc Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)	

.DEFAULT_GOAL := help

USERID=$(shell id -u)	