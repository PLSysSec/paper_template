PAPER_SRC=paper.tex
PAPER_OUT=paper.pdf

# DO NOT EDIT THESE DEFINITIONS
BUILTINS := builtins
EXTENSIONS := extensions
LATEX_RUN := $(BUILTINS)/latexrun.py

# Require VERBOSE=1 to print all the commands run
ifndef VERBOSE
.SILENT:
endif

# Always build because latexrun does fancy dependency analysis for us
.PHONY: FORCE
$(PAPER_OUT): FORCE
	$(LATEX_RUN) --latex-args=-shell-escape $(PAPER_SRC)

# Allow `make` to just build the paper
.DEFAULT_GOAL := $(PAPER_OUT)

# Clean out all intermediate files
.PHONY: clean
clean:
	$(LATEX_RUN) --clean-all



# Spellchecking
# ----------------------------

# list all unknown-words
unknown-words: $(PAPER_OUT)
	for file in `$(BUILTINS)/ltxdeps.sh`; do \
		words="$$(aspell list -t < "$$file")"; \
		if [ $$? -eq 0 ]; then \
			grep --color=auto -Hn -E "$$(echo $$words | sed -e 's/ /|/g')" $$file; \
		fi \
	done

# Run aspell interactively on all tex files that were built into PAPER_OUT
aspell: $(PAPER_OUT)
	for file in `$(BUILTINS)/ltxdeps.sh`; do \
		read -p "Press ENTER to check $$file:"; \
		aspell check -t $$file; \
	done

