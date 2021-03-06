
knitr::opts_chunk$set(
  warning   = FALSE
  ,message   = FALSE
  ,collapse  = TRUE
  ,cache     = TRUE
# ,out.width = "70%"
# ,fig.align = 'center'
# ,fig.width = 6
# ,fig.asp   = 0.618 # 1 / phi
# ,fig.show  = "hold"
)

list.of.packages <- c("ggplot2", "Rcpp", "rstanarm", "lme4", "mice", "VIM", "pander", "kableExtra",
                      "corrplot", "psych", "ggfortify", "GPArotation", "sjPlot", "gridExtra", "knitr", 
                      "ggmap", "spdep", "housingData", "Hmisc", "waffle", "ROCR", "caret", "ggjoy",
                      "stargazer", "missForest", "forestplot", "emo", "tidyr", "factoextra")
# issues with MKMisk requiring 'limma' which is in bioconductor
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages>0)){install.packages(new.packages)}

library(ggplot2)
library(gridExtra)
library(dplyr)
library(pander)
library(knitr)
library(kableExtra)

options(knitr.kable.NA = '', knitr.table.format = "html")
theme_set(theme_bw())

# loading data sets used in multiple chapters

depress <- read.delim("https://norcalbiostat.netlify.com/data/depress_081217.txt")
names(depress) <- tolower(names(depress))


load(url("https://norcalbiostat.netlify.com/data/addhealth_clean.Rdata"))
addhealth$smoke <- ifelse(addhealth$eversmoke_c=="Smoker", 1, 0)

fev <- read.delim("https://norcalbiostat.netlify.com/data/Lung_081217.txt", sep="\t", header=TRUE)

