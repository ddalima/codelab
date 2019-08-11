
.SECONDARY:
.SECONDEXPANSION:

VERSION ?= 1.0.0

.phony: help advisor-codelab-tutorials
.phony: advisor-codelab-01 advisor-codelab-02 advisor-codelab-03 
.phony: advisor-codelab-serve advisor-codelab-run

advisor-codelab-01: ##@Build Build advisor-codelab-01
	claat export -f html advisor-codelab-01.md
	zip -r 00001/tutorial.zip playbook/*
	mv 00001 $(OUTDIR)/advisor-codelab-01

advisor-codelab-02: ##@Build Build advisor-codelab-02
	claat export -f html advisor-codelab-02.md
	mv 00002 $(OUTDIR)/advisor-codelab-02

advisor-codelab-03: ##@Build Build advisor-codelab-03
	claat export -f html advisor-codelab-03.md
	mv 00003 $(OUTDIR)/advisor-codelab-03



advisor-codelab-tutorials: advisor-codelab-01 advisor-codelab-02 advisor-codelab-03 ##@Build All tutorials


# advisor-codelab-image:  advisor-codelab-01 ##@Build Build Training Contaimner
# 	docker build -t alcide.io/codelab:$(VERSION) .
# 	docker tag alcide.io/codelab:$(VERSION) alcide.io/codelab:latest

# advisor-codelab-run: ##@Local Docker run
# 	docker run --rm --name advisor-codelab -p 9090:9090 alcide.io/codelab:latest   

advisor-codelab-serve: advisor-codelab-01 ##@Local Serve locally
	cd 00001 && claat serve | cd ..

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