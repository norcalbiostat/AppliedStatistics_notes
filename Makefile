main: index.Rmd
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
