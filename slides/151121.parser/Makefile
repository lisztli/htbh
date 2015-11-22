DOT_FILES := $(shell find ./imgs -name '*.dot')
IMG_FILES := $(DOT_FILES:%.dot=%.png)

.PHONY: all dot tex

all: tex

dot: $(IMG_FILES)
	echo "Done"

imgs/%.png: imgs/%.dot
	- rm $@
	dot -n -Tpng $< -o$@

tex:
	pdflatex slide.tex
	- rm *.aux *.bak *.log *.bbl *.blg *.thm *.toc *.out *.gz *.nav *.snm *.vrb
clean:
	- rm *.aux *.bak *.log *.bbl *.blg *.thm *.toc *.out *.gz *.nav *.snm *.vrb
