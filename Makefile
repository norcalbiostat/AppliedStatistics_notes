main: index.Rmd
	Rscript -e "rmarkdown::clean_site()"
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
