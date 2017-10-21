# MATH456_notes
Course notes for MATH 456

Instructions follow: http://seankross.com/2016/11/17/How-to-Start-a-Bookdown-Book.html  

1. Create new repo.
    - Initalize README.md but no .gitignore
2. Create Rproj
    - Clone repo into Rproj
3. Install `bookdown` from github

```
install.packages("devtools")
devtools::install_github("rstudio/bookdown")
```

4. Download bare boilerplate code from Sean Kross's github: https://github.com/seankross/bookdown-start 
    - As a zip file, since Repo is already made and project already created. 
    - Move all files except README.md into local github repo.
    - May get an error/warning saying can't move `.gitignore` because it's invisible. 
    - It can be copy/pasted just fine 
5. Open `_output.yaml`
    - Change `A Minimal Bookdown Book` to your book name
6. Open `bookdown.yaml`
    - Change `book_filename` to the file you would like to have when printed to PDF. i.e. `MATH456-notes.pdf`
    - Update repo association
7. Open `index.Rmd`
    - Update `title`, `author`, `date`, `github-repo`, `url`, and `description`
    - Since your repo isn't published yet, use _http://example.com_ as a placeholder. 
8. Preview the book by typing
```
bookdown:::serve_book()
```

9. If you're happy and you know it git commit...