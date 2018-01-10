# Preparing Data for Analysis

Just a recap


## A Reproducible Workflow

![PrepareData](images/Afifi_Fig3_1.png)

* You are your own collaborator 6 months from now. Make sure you will be able
to understand what you were doing.
* Investing the time to do things clearly and in a reproducible manner will
make your future self happy.
* Comment your code with explanations and instructions.
    - How did you get from point A to B? 
    - Why did you recode this variable in this manner? 
* This is reason #1 we use the Markdown language through R. 


![Repro](images/pipeline.png)

Figure Credits: [Roger Peng](http://www.biostat.jhsph.edu/~rpeng/)




## Identifying Variable Types
This section uses the `depression` data set from Afifi et.al. 

Consider a variable that measures marital status. What data type does R see this variable as? 

```r
table(depress$MARITAL)
```

```
## 
##   1   2   3   4   5 
##  73 127  43  13  38
```

```r
str(depress$MARITAL)
```

```
##  int [1:294] 5 3 2 3 4 2 2 1 2 2 ...
```

```r
class(depress$MARITAL)
```

```
## [1] "integer"
```

When variables have numerical levels it is necessary to ensure that R knows it is a factor variable.

The following code uses the `factor()` function to take the marital status variable and convert it into a factor variable with specified labels that match the codebook. 

```r
depress$MARITAL <- factor(depress$MARITAL, 
                          labels = c("Never Married", "Married", "Divorced", "Separated", "Widowed"))
```

It is important to confirm the recode worked. If it did not you will have to re-read in the raw data set again since the variable `SEX` was replaced. 


```r
table(depress$MARITAL)
```

```
## 
## Never Married       Married      Divorced     Separated       Widowed 
##            73           127            43            13            38
```

```r
class(depress$MARITAL)
```

```
## [1] "factor"
```

* Create a boxplot of income across marital status category.

```r
qplot(y=INCOME, x=MARITAL, data=depress, geom="boxplot")
```

<img src="01-Preparing-Data-for-Analysis_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Boxplots are nice because they clearly show the range where 50% of the data lie and any potential outliers. Boxplots can also indicate skewness, but sometimes it is helpful to visualize the location of the mean as well as the median. `ggplot2` has a nice `stat_summary` layer that will calculate and add the means to the current plot. 


```r
qplot(y=INCOME, x=MARITAL, data=depress, geom="boxplot") + 
   stat_summary(fun.y=mean, colour="blue", size=3, geom="point")
```

<img src="01-Preparing-Data-for-Analysis_files/figure-html/unnamed-chunk-6-1.png" width="672" />

## Data Editing and Recoding

For unbiased and accurate results of a statistical analysis, sufficient data has to be present. Often times once you start slicing and dicing the data to only look at certain groups, or if you are interested in the behavior of certain variables across levels of another variable, sometimes you start to run into small sample size problems. For example, consider marital status again:  


```r
table(depress$MARITAL)
```

```
## 
## Never Married       Married      Divorced     Separated       Widowed 
##            73           127            43            13            38
```

There are only 13 people who report being separated. This could potentially be too small of a group size for valid statistical analysis. 

One way to deal with insufficient data within a certain category is to collapse categories. The following code uses the `recode()` function from the `car` package to create a new variable that I am calling `MARITAL2` that combines the `Divorced` and `Separated` levels. 


```r
library(car)
```

```
## 
## Attaching package: 'car'
```

```
## The following object is masked from 'package:dplyr':
## 
##     recode
```

```r
depress$MARITAL2 <- recode(depress$MARITAL, "'Divorced' = 'Sep/Div'; 'Separated' = 'Sep/Div'")
```

Always confirm your recodes. 

```r
table(depress$MARITAL, depress$MARITAL2, useNA="always")
```

```
##                
##                 Married Never Married Sep/Div Widowed <NA>
##   Never Married       0            73       0       0    0
##   Married           127             0       0       0    0
##   Divorced            0             0      43       0    0
##   Separated           0             0      13       0    0
##   Widowed             0             0       0      38    0
##   <NA>                0             0       0       0    0
```

This confirms that records where `MARITAL` (rows) is `Divorced` or `Separated` have the value of `Sep/Div` for `MARITAL2` (columns).


Now let's examine the relationship between income against marital status by creating a boxplot. This is a situation where _jittering_  or _dodging_ the points is helpful to avoid overplotting of points. Note that the full `ggplot` code had to be used here, not the simpler `qplot` methods. Furthermore, the `grid.arrange` function from the `gridExtra` package is used  to display these plots side by side. 


```r
library(gridExtra)
```

```
## 
## Attaching package: 'gridExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     combine
```

```r
a <- qplot(x=MARITAL2, y=INCOME, data=depress, col=MARITAL2, geom="point", main = "Without jittering") + 
           coord_flip() + theme(legend.position="none")
b <- ggplot(depress, aes(x=INCOME, y=MARITAL2, color=MARITAL2), main="With jittering") +
            geom_point(position=position_jitter()) + theme(legend.position="none")
grid.arrange(a, b, ncol=2)
```

<img src="01-Preparing-Data-for-Analysis_files/figure-html/unnamed-chunk-10-1.png" width="960" />

* What do you think `coord_flip()` does? Look at the difference in the X and Y values between
  plot a and plot b. 

* What do you think `theme(legend.position="none")` does? 

_Hint:_ Try removing them and see what happens. 

* What can you say about the relationship between Income and marital status? 

## Outliers

Let's look at the age variable in the depression data set. 

```r
par(mfrow=c(1,2))
boxplot(depress$AGE)
hist(depress$AGE)
```

<img src="01-Preparing-Data-for-Analysis_files/figure-html/unnamed-chunk-11-1.png" width="960" />

Just looking at the data graphically raises no red flags. The boxplot shows no outlying values and the histogram does not look wildly skewed. This is where knowledge about the data set is essential. The codebook does not provide a valid range for the data, but the description of the data starting on page 3 in the textbook clarifies that this data set is on adults. In the research world, this specifies 18 years or older. 

Now look back at the graphics. See anything odd? It appears as if the data go pretty far below 20, possibly below 18. Let's check the numerical summary to get more details. 


```r
summary(depress$AGE)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    9.00   28.00   42.50   44.38   59.00   89.00
```

The minimum value is a 9, which is outside the range of valid values for this variable. This is where you, as a statistician, data analyst or researcher goes back to the PI and asks for advice. Should this data be set to missing, or edited in a way that changes this data point into a valid piece of data. 

As an example of a common data entry error, and for demonstration purposes, I went in and changed a 19 to a 9. So the correct thing to do here is to change that 9, back to a 19. This is a very good use of the `ifelse()` function. 


```r
depress$AGE <- ifelse(depress$AGE==9, 19, depress$AGE)
```

The logical statement is `depress$AGE==9`. Wherever this is true, replace the value of `depress$AGE` with 19, wherever this is false then keep the value of `depress$AGE` unchanged (by "replacing" the new value with the same old value). 


Alternatively, you can change that one value using bracket notation. Here you are specifying that you only want the rows where `AGE==9`, and directly assign a value of 19 to those rows.  

```r
depress$AGE[depress$AGE==9] <- 19
```

Confirm the recode. 

```r
summary(depress$AGE)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   18.00   28.00   42.50   44.41   59.00   89.00
```

Looks like it worked. 

