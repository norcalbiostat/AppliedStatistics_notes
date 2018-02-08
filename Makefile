all: main

PHONY: main clean open

main: clean index.Rmd
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

clean:
	Rscript -e "rmarkdown::clean_site()"

open:
	open docs/index.html
