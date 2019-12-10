BASE=medical-imaging-nix
DOC=$(BASE).md
PDF=$(BASE).pdf

############################################################################
#                                 TARGETS                                  #
############################################################################

$(PDF): $(DOC) fig
	pandoc --pdf-engine=xelatex --filter=pandoc-crossref -t beamer -V theme:metropolis --slide-level=2 $(DOC) -o $(PDF)
