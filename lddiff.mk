## lddiff.mk: latexdiff of a multi-file LaTeX document against an old version
## Uses gitrev_r from git.mk (include order doesn't matter)

## make draft.prev2.lddiff.pdf
## <rev> is as in gitversions (git.mk): a commit or tag; YYYY-MM-DD for the
## last commit by the end of that day; or prev<n> for the nth-latest commit
## Dates and prev<n> count commits touching $(lddiff_path) (default: any .tex)
## <rev> can't contain a dot

## Builds, in <doc>.<rev>.lddiff/:
##   rev      the resolved commit
##   old/     this directory at <rev> (git archive)
##   lddiff/  where latex runs; files keep their original names:
##     <doc>.tex (always, for the markup preamble) and changed or new
##     top-level .tex files are made by latexdiff
##     everything else is a symlink to the working directory, so the new side
##     is the working tree (uncommitted changes included)
## .tex files in subdirectories are linked, not diffed

## Remade when a top-level .tex file changes (the new side)
## Not when a moving <rev> (prev<n>, a date, HEAD) moves; delete the .pdf to refresh

## Preamble material shouldn't be diffed (latexdiff markup breaks it)
## Files \input in <doc>.tex before \begin{document} are skipped automatically;
## add others (e.g., files \input from those) to lddiff_skip

Ignore += *.lddiff/ *.lddiff.pdf

lddiff_path ?= '*.tex'
lddiff_skip ?=
LDOPTS ?=
## System latexdiff if there is one; the bundled copy is old and noisy
lddiff_cmd ?= $(if $(shell command -v latexdiff),latexdiff,perl -f makestuff/latexdiff.pl)
lddiff_latex ?= pdflatex -interaction=nonstopmode
lddiff_bib ?= biber $(lddiff_doc) || bibtex $(lddiff_doc)

## latex output for <doc>; never linked, so latex can't write into the main directory
lddiff_outputs ?= aux log pdf out bbl blg bcf run.xml toc lof lot fls synctex.gz nav snm vrb idx ind ilg

lddiff_doc = $(basename $*)
lddiff_rev = $(patsubst .%,%,$(suffix $*))
lddiff_dir = $*.lddiff

## .tex files \input or \include'd in the preamble of $1
lddiff_preamble = perl -ne 'last if /\\begin\{document\}/; s/(?<!\\)%.*//; \
	print "$$1\n" while /\\(?:input|include)\{([^}]+)\}/g' $1 | sed -e 's/\.tex$$//; s/$$/.tex/'

%.lddiff.pdf: $(wildcard *.tex)
	@test -f $(lddiff_doc).tex || (echo "lddiff: no $(lddiff_doc).tex; target should be <doc>.<rev>.lddiff.pdf, e.g. draft.prev2.lddiff.pdf" >&2; false)
	$(RM) -r $(lddiff_dir)
	mkdir -p $(lddiff_dir)/old $(lddiff_dir)/lddiff
	rev=$$($(call gitrev_r,$(lddiff_path),$(lddiff_rev))); \
	test -n "$$rev" || (echo "No version of $(lddiff_path) for '$(lddiff_rev)'" >&2; false) && \
	echo $$rev > $(lddiff_dir)/rev && \
	git archive "$$rev:./" | tar -x -C $(lddiff_dir)/old
	skip=" $(lddiff_skip) $$($(call lddiff_preamble,$(lddiff_doc).tex) | tr '\n' ' ') "; \
	echo "lddiff: not diffing$$skip"; \
	for f in *; do \
		case "$$f" in \
		(*.lddiff | *.lddiff.pdf | $(patsubst %,$(lddiff_doc).% |,$(lddiff_outputs)) *.aux) ;; \
		(*.tex) \
			case "$$skip" in (*" $$f "*) ln -s ../../"$$f" $(lddiff_dir)/lddiff/; continue;; esac; \
			if test "$$f" != $(lddiff_doc).tex && cmp -s "$$f" $(lddiff_dir)/old/"$$f"; then \
				ln -s ../../"$$f" $(lddiff_dir)/lddiff/; \
			else \
				test -f $(lddiff_dir)/old/"$$f" || : > $(lddiff_dir)/old/"$$f"; \
				echo "lddiff: diffing $$f"; \
				$(lddiff_cmd) $(LDOPTS) $(lddiff_dir)/old/"$$f" "$$f" > $(lddiff_dir)/lddiff/"$$f" || exit 1; \
			fi ;; \
		(*) ln -s ../../"$$f" $(lddiff_dir)/lddiff/ ;; \
		esac; \
	done
	- cd $(lddiff_dir)/lddiff && $(lddiff_latex) $(lddiff_doc)
	- cd $(lddiff_dir)/lddiff && ($(lddiff_bib))
	- cd $(lddiff_dir)/lddiff && $(lddiff_latex) $(lddiff_doc)
	- cd $(lddiff_dir)/lddiff && $(lddiff_latex) $(lddiff_doc)
	test -f $(lddiff_dir)/lddiff/$(lddiff_doc).pdf
	ln -sf $(lddiff_dir)/lddiff/$(lddiff_doc).pdf $@
