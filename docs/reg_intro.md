# (PART) Regression Modeling {-}

# Introduction {#reg-intro}

The general purpose of regression is to learn more about the relationship between several independent or predictor variables and a quantitative dependent variable. Multiple regression procedures are very widely used in research. In general, this inferential tool allows us to ask (and hopefully answer) the general question "_what is the best predictor of_...", and does “_additional variable A_” or “_additional variable B” confound the relationship between my explanatory and response variable?_” 

> * Educational researchers might want to learn about the best predictors of success in high-school. 
* Sociologists may want to find out which of the multiple social indicators best predict whether or not a new immigrant group will adapt to their new country of residence. 
* Biologists may want to find out which factors (i.e. temperature, barometric pressure, humidity, etc.) best predict caterpillar reproduction.

This chapter starts by recapping notation and topics for simple linear regression, when there is only one predictor. Then we move into generalization of these concepts to many predictors, and model building topics such as stratification, interactions, and categorical predictors. 


## Opening Remarks

The PMA6 textbook (Chapter 7) goes into great detail on this topic, since regression is typically the basis for all advanced models. 

The book also distinguishes between a "fixed-x" case, where the values of the explanatory variable $x$ only take on pre-specified values, and a "variable-x" case, where the values of $x$ are observations from a population distribution of X's. 

This latter case is what we will be concerning ourselves with. 

