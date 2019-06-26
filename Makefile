PAPER_SRC=paper.tex
PAPER_OUT=paper.pdf


# DO NOT EDIT THESE DEFINITIONS
PROJ := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

BUILTINS := $(PROJ)/builtins
EXTENSIONS := $(PROJ)/extensions
LATEX_RUN := $(BUILTINS)/latexrun.py

.PHONY: FORCE
$(PAPER_OUT): FORCE
	$(LATEX_RUN) $(PROJ)/paper.tex

.PHONY: clean
clean:
	$(LATEX_RUN) --clean-all

default: $(PAPER_OUT)