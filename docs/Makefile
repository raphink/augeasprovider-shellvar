all: $(patsubst %.md, %.html, $(wildcard *.md ../*.md) $(MAKE_MD)) CHANGELOG.html

CHANGELOG.html: ../CHANGELOG.md
	pandoc -o `basename $@` -f markdown -t html -c buttondown.css -S $<

%.html: %.md
	pandoc -o `basename $@` -f markdown -t html -c buttondown.css -S $<

.PHONY: clean
clean:
	rm -f *.html $(MAKE_MD)
