PAPER_SRC=paper.tex
PAPER_OUT=paper.pdf

BUILTINS := builtins
EXTENSIONS := extensions

# Either specify USE_LATEXRUN=1 when calling the makefile or
# uncomment the next line if you prefer the LATEXRUN python tool
# USE_LATEXRUN:=1

LATEXRUN := $(BUILTINS)/latexrun.py --latex-args=-shell-escape
LATEXMK := latexmk -pdf -shell-escape -outdir="latex.out"

# Require VERBOSE=1 to print all the commands run
ifndef VERBOSE
.SILENT:
endif

# Always build because the latex tool does fancy dependency analysis for us
.PHONY: build
build:
	rm -f $(PAPER_OUT)
ifdef USE_LATEXRUN
		$(LATEXRUN) $(PAPER_SRC)
else
		$(LATEXMK) $(PAPER_SRC)
endif
	cp latex.out/$(PAPER_OUT) $(PAPER_OUT)

# Allow `make` to just build the paper
.DEFAULT_GOAL := build

.PHONY: clean
clean:
	rm -f paper.pdf
ifdef USE_LATEXRUN
		$(LATEXRUN) --clean-all
else
		$(LATEXMK) -C
endif
	rm -f *.aux *.bbl *.dvi

# Useful for editor integrations. Will output the full build log
# rather than the just the abbreviated latexrun output.
# You will need to use the --ignore-errors flag though
.PHONY: with-log
with-log: build
	cat ./latex.out/$(basename $(notdir $(PAPER_SRC))).log

# Spellchecking
# ----------------------------

# list all unknown-words
.PHONY: unknown-words
unknown-words: build
	for file in `$(BUILTINS)/ltxdeps.sh`; do \
		words="$$(aspell --home-dir=./ list -t < "$$file")"; \
		if [ $$? -eq 0 ]; then \
			grep --color=auto -Hn -Ew "$$(echo $$words | sed -e 's/ /|/g')" $$file; \
		fi \
	done

# Run aspell interactively on all tex files that were built into PAPER_OUT
.PHONY: aspell
aspell: build
	for file in `$(BUILTINS)/ltxdeps.sh`; do \
		read -p "Press ENTER to check $$file:"; \
		aspell --home-dir=./ check -t $$file; \
	done

