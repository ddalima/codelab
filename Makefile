
.SECONDARY:
.SECONDEXPANSION:

VERSION ?= 1.0.0

.phony: help tutorials

  

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