# (PART) APPENDIX {-}

# Setup R & RStudio {#setup_intro}

This section covers how to install & set up both R and R Studio for analysis. While R is not the only software program that can be used for data analysis, it is common in the fields of Statistics and Data Science and R code is used throughout this notebook. 

This section was last updated on 2023-08-05.

For a more polished overview of R and R Studio visit this [Data Carpentry lesson](https://datacarpentry.org/R-ecology-lesson/00-before-we-start.html#what-is-r-what-is-rstudio)

## ⚠️ Before you begin

If you are using a tablet, Chromebook or otherwise do not have a computer that you can install programs on, Posit Cloud is a great option. Make an account at https://posit.cloud/, start a new project then go to [](#nav-rstudio) to learn how to navigate RStudio. 

As of the time of this writing, the **Cloud Free** account allows for 25 project hours/month, which may not be enough for your class. If you run into time limits you can upgrade to the **Cloud Plus** plan which is $5/month. 

While the cloud is easier to initially setup, having your own installation on your computer is very beneficial because: 

* you likely want to customize your programs
* you will be able to put your files under version control
* you always have access to your code even with unstable or no internet

## Download and install R 

### 🔽 Download R v 4.1+ {-#download_r}
* Windows 10 https://cran.r-project.org/bin/windows/base/ 
* Mac OS X page - https://cran.r-project.org/bin/macosx/ 
  - First link under "Latest Release" and looks like **R-4.1.2.pkg**. 
  - ⚠️ You may later get a message about needing *X11* or *XQuartz*. The download for that program is also on this page. (Mac only)
* Choose to save the file, do not open or run. 
    
### ✏️ Install {-#install_r}
* Install R by double clicking on the downloaded file and following the prompts.
  - Default settings are OK. 
  - Delete any desktop shortcuts that was created (looks like the icon above.)
  

### 🎦 Video Tutorials for both R and R Studio. {-#install_vid}
* [Windows](https://www.youtube.com/watch?v=gx7A7C_wdyE)
* [Mac](https://www.youtube.com/watch?v=Y20P3u3c_1c)


## Download and install R Studio

#### Download {-#download_rstudio}

* https://posit.co/download/rstudio-desktop/#download 
* Choose the download link that corresponds to your operating system. 

#### Install {-#install_rstudio}

* Windows: Double click on the downloaded file to run the installer program. 
* Mac: Double click on the downloaded file, then drag the R Studio Icon into your Applications folder.
  - After you are done, eject the "Drive" that you downloaded by dragging the icon to your trash. 

## Navigating RStudio {#nav-rstudio}

![The major windows (or panes) of the RStudio environment:](https://datacarpentry.org/genomics-r-intro/fig/rstudio_session_4pane_layout.png)

* **Source**: This pane is where you will write/view R scripts. Some outputs (such as if you view a dataset using `View()`) will appear as a tab here.
* **Console/Terminal/Jobs**: This is actually where you see the execution of commands. This is the same display you would see if you were using R at the command line without RStudio. You can work interactively (i.e. enter R commands here), but for the most part we will run a script (or lines in a script) in the source pane and watch their execution and output here. The “Terminal” tab give you access to the BASH terminal (the Linux operating system, unrelated to R). RStudio also allows you to run jobs (analyses) in the background. This is useful if some analysis will take a while to run. You can see the status of those jobs in the background.
* **Environment/History**: Here, RStudio will show you what datasets and objects (variables) you have created and which are defined in memory. You can also see some properties of objects/datasets such as their type and dimensions. The “History” tab contains a history of the R commands you’ve executed R.
* **Files/Plots/Packages/Help/Viewer**: This multipurpose pane will show you the contents of directories on your computer. You can also use the “Files” tab to navigate and set the working directory. The “Plots” tab will show the output of any plots generated. In “Packages” you will see what packages are actively loaded, or you can attach installed packages. “Help” will display help files for R functions and packages. “Viewer” will allow you to view local web content (e.g. HTML outputs).

> this page pulled directly from the [Data Carpentry Genomics lesson](https://datacarpentry.org/genomics-r-intro/00-introduction.html#overview-and-customization-of-the-rstudio-layout)

## Setting preferences

**Retain sanity while troubleshooting** 

* Open R Studio and go to the file menu go to _Tools_ then _Global Options_.
* Uncheck "Restore .RData into workspace at startup" 
* Where it says "Save workspace to .RData on exit:" Select "Never""
* Click apply then ok to close that window.
  
This will ensure that when you restart R you do not "carry forward" objects such as data sets that you were working on in a prior assignment. 

**Restarting R**

To effectively restart R, go to the file menu and click _Session_ , then "Restart R", or "Restart R and clear output". 

**R Studio Color Themes**

* Open R Studio and go to the file menu go to _Tools_ then _Global Options_.
* Left side under _Appearance_ you have options to change the program window itself, but the best options are down under the _Editor themes_. 
    - If you choose a dark editor theme then choose the _Modern_ program theme to get a fully dark themed program. 


**Show Output Preview**

R Markdown and Quarto documents will default to showing your output (code and graphics) in the code editor window itself. The default is to minimize the console window when executing code, since the output is in the editor window. 

**Pro**: You are only dealing with one main window where you can see your output directly under the code that created it

**Con**: The output does not auto-regenerate or auto-update when your code or data changes. This can lead to mistakes because if you change code or data and don't re-run code chunks that contain output or plots, you could be looking at old/incorrect plots and output. 




## Installing packages

> All the fun functions are in packages

R is considered an **Open Source** software program. That means many (thousands) of people contribute to the software. They do this by writing commands (called functions) to make a particular analysis easier, or to make a graphic prettier.

When you download R, you get access to a lot of functions that we will use. However these other _user-written_ packages add so much good stuff that it really is the backbone of the customizability and functionality that makes R so powerful of a language. 

For example we will be creating graphics using functions like `boxplot()` and `hist()` that exist in base R. But you will quickly move on to creating graphics using functions contained in the `ggplot2` package. We will be managing data using functions in `dplyr` and reading in Excel files using `readxl`. Installing packages will become your favorite past-time. 


✏️  Start by typing the following in the console to install the `ggplot2` package. 

```r
install.packages("ggplot2")
```

When the download and install is complete, you should see a message similar to: 

```r
The downloaded binary packages are in
	C:\Users\Robin\AppData\Local\Temp\Rtmpi8NAym\downloaded_packages
```


⚠️ R is case sensitive and spelling matters. If you get an error message like the following: 

```r
Warning in install.packages :
  package ‘ggplot’ is not available (for R version 3.5.1)
```

The correct package name is `ggplot2`, not `ggplot`.


> **Alternative Method of installing Packages:**  Use the Package tab in the lower right pane in R Studio. 

Keep an eye on the messages that fly by in the console. You are looking for key words such as "error code" or "unable to remove..." to indicate installation problems. 


When you see a chevron `>` in the console you know R is done installing and waiting for you.


### Common packages used in this notebook

> ⚠️ Check with your instructor about which packages to install. You typically do NOT need all of these. 

**Data Import and Management**

* `here`
* `tidyverse` (an opinionated collection of packages that work well together
* `tidyr`
* `palmerpenguins` example data 

**Communication / pretty reporting**

* `rmarkdown` literate data analysis and creating reports, presentations, websites. 
* `pander`
* `kableExtra`
* `knitr`
* `gtsummary`

**Data Visualization**

* `ggplot2` (also contained in tidyverse)
* `ggpubr`
* `corrplot` visualizing correlation matricies
* `sjPlot`
* `gridExtra`
* `waffle`
* `dotwhisker`


**Analysis**

* `rstanarm` or `lme4` multi-level modeling
* `mice` multiple imputation with chained equations
* `VIM` visualizing missing data patterns, 
* `caret`
* `ROCR`
* `factoextra`
* `performance`
* `broom`
* `survey`
* `marginaleffects`


## Organization using R Projects

If you are using R for more than one thing (a class, thesis, multiple research projects) then I *strongly* recommend using R projects. 

R projects are a great way of keeping all files for one project all together, and makes importing data much easier by using relative paths instead of absolute ones. Plus this ensures reproducibility by others (because noone else has a path at `C:\users\rdonatello\myprojects\math615`)

* Click on the R cube icon in the top right corner of the RStudio program and select _Crete new project_. 
* If you already have a project folder created then choose an "Existing Directory", otherwise choose a "New directory" and navigate to the folder where this work should belong. 
* I recommend checking _Open in new session_ for all projects. This allows you to have multiple Rstudio windows open for different projects and the files/data/objects don't get cross-contaminated. 

**Using R Projects**

* Navigate in your file explorer to the folder where you created your project. 
* Click on the R cube icon to open the whole project. 
* Then from your bottom left pane, in the `files` tab you can open the desired script files.


Other helpful articles. 

* [Posit Support Introduction](https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects) 
* [R Blogger post by Martin Chan](https://www.r-bloggers.com/2020/01/rstudio-projects-and-working-directories-a-beginners-guide/)

## Literate programming with Quarto

Generate dynamic output using Python, R, Julia, and Observable. Create reproducible documents that can be regenerated when underlying assumptions or data change.

Learn more at [https://quarto.org/](https://quarto.org/)


For any of Dr. D's courses, this is how you'll be completing and turning in your homework. Follow this tutorial to learn about Quarto and test it out. 

[https://quarto.org/docs/get-started/hello/rstudio](https://quarto.org/docs/get-started/hello/rstudio)

### Creating PDF's

Great! You rendered your first literate document to an HTML format. Great for viewing, not so great for printing or emailing. We need to do one more thing before we can render this document to a pdf. Install a typesetting program called \LaTeX (lah-tek or lay-tek).


**Step 1: Install the `tinytex` package:**


```r
install.packages("tinytex")
```

**Step 2: Install Tinytex**


Once that is fully complete and you see the R console windows showing a `>` waiting for you, copy the following code to have tinytex install \LaTeX for you.


```r
tinytex::install_tinytex()
```

This will take some time. Be patient, and wait for R to display a `>` in the console.

**Step 3: Test your installation**

Change the output format of your quarto file to `pdf` in the YAML header (At the very top of your code file, line 2 or 3).

``` verbatim
---
format: pdf
---
```

Now click `render` and see if it creates a PDF.

The PDF should automatically pop up, otherwise check your folder *in the same location as your script file is saved* and see if a PDF is located there.


## Seeking Help

> Sometimes a second pair of eyeballs is all you need.

### Advice on asking for help

The key to receiving help from someone is for them to rapidly grasp your problem. You should make it as easy as possible to pinpoint where the issue might be.

Try to use the correct words to describe your problem. For instance, a package is not the same thing as a library. Most people will understand what you meant, but it can make things confusing for people trying to help you. Be as precise as possible when describing your problem.

⚠️ Don't let not knowing exactly how to describe your problem prevent you from asking. Screenshots help tremendously!

**When asking someone for help try to**
1. Explain what thing you are trying to do
2. Explain/show the code you wrote to try to do that thing
3. Explain/show your result, and if it's not obvious explain why you feel it's not the correct result. (E.g. you expected the answer to be 5, but instead it's 10. )

⚠️ Don't spend more than 20 minutes banging your head on the wall before you ask for help!


### Help from inside R Studio

One of the fastest ways to get help is to use the RStudio help interface. This panel by default can be found at the lower right hand panel of RStudio. As seen in the screenshot, by typing the word `mean`, RStudio tries to also give a number of suggestions that you might be interested in. The description is then shown in the display window.

❓ I know the name of the function I want to use, but I'm not sure how to use it

If you need help with a specific function, let's say `barplot()`, you can type:


```r
?barplot
```

If you just need to remind yourself of the names of the arguments, you can use:


```r
args(lm)
```

❓ I want to use a function that does X, there must be a function for it but I don't know which one...

If you are looking for a function to do a particular task, you can use the `help.search()` function, which is called by the double question mark `??`. However, this only looks through the installed packages for help pages with a match to your search request.


```r
??kruskal
```

If you can't find what you are looking for, you can use the [rdocumentation.org](http://www.rdocumentation.org) website that searches through the help files across all packages available.

Finally, a generic Google or internet search "R \<task\>" will often either send you to the appropriate package documentation or a helpful forum where someone else has already asked your question.

❓ I get an error message that I don't understand

Start by googling the error message. However, this doesn't always work very well because often, package developers rely on the error catching provided by R. You end up with general error messages that might not be very helpful to diagnose a problem (e.g. "subscript out of bounds"). If the message is very generic, you might also include the name of the function or package you're using in your query.

If you check Stack Overflow, search using the `[r]` tag. Most questions have already been answered, but the challenge is to use the right words in the search to find the answers: [http://stackoverflow.com/questions/tagged/r](http://stackoverflow.com/questions/tagged/r)

⚠️ Development of R moves pretty fast. When at all possible, use results from the past 1-2 years. Anything over 5 years old for packages such as `ggplot`, `dplyr`, and `forcats` are likely obsolete. 


### Other Online

* In RStudio go to `Help` --> `Cheatsheets`   
* Posit Cloud interactive lessons: https://rstudio.cloud/learn/primers
* [Stack Overflow](http://stackoverflow.com/questions/tagged/r): if your question hasn't been answered before and is well crafted, chances are you will get an answer in less than 5 min. Remember to follow their guidelines on [how to ask a good question](http://stackoverflow.com/help/how-to-ask).
* The [R-Studio Community](https://community.rstudio.com/): it is read by a lot of people and is more welcoming to new users than the R list-serv. 
* If your question is about a specific package, see if there is a mailing list for it. Usually it's included in the DESCRIPTION file of the package that can be accessed using `packageDescription("name-of-package")`. You may also want to try to email the author of the package directly, or open an issue on the code repository (e.g., GitHub).

### Written

If you're a book kinda person, there is plenty of help available as well. Many have online versions or free PDF's.

* R Markdown, the Definitive Guide: https://bookdown.org/yihui/rmarkdown/
* R for Data Science https://r4ds.had.co.nz/
* Cookbook for R http://www.cookbook-r.com/
* R Graphics Cookbook (I use this all the time) -- Chapter 8 in the above link
* The Art of R Programming https://nostarch.com/artofr.htm
* R for... http://r4stats.com/
    - Excel Users https://www.rforexcelusers.com/
    - SAS and SPSS Users http://r4stats.com/books/r4sas-spss/
    - STATA Users http://r4stats.com/books/r4stata/



## Saving and closing your work. 

Unless you're returning to work in R Studio in a short while, you should make a habit to save all open tabs and completely shut down R studio when you are done working. This ensures your environment is cleared. _This is a good thing._

### Restart R

To restart R without shutting the entire window down, go to the file menu bar in the top, 

> _Session_ --> Restart R and Clear Output

This is good to do when switching between projects/classes. 

## Acknowledgements

Some of this material is a derivation from work that is Copyright © Software Carpentry (http://software-carpentry.org/) which is under a [CC BY 4.0 license](https://creativecommons.org/licenses/by/4.0/) which allows for adaptations and reuse of the work. 
