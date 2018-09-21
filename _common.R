
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
                      "ggmap", "spdep", "housingData", "Hmisc", "waffle", "MKmisc", "ROCR", "caret", 
                      "stargazer", "missForest")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if ( length(new.packages) ) {
    install.packages(new.packages)
}

library(ggplot2)
library(gridExtra)
library(dplyr)
library(pander)
library(knitr)
library(kableExtra)

options(knitr.kable.NA = '', knitr.table.format = "html")
theme_set(theme_bw())

