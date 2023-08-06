# Random Intercept Models {#RI}

<span style="color:blue">**Example Data**</span>

Radon is a radioactive gas that naturally occurs in soils around the U.S. As radon decays it releases other radioactive elements, which stick to, among other things, dust particles commonly found in homes.  The EPA believes [radon exposure](https://www.epa.gov/radon) is one of the leading causes of cancer in the United States.

This example uses a dataset named `radon` from the `rstanarm` package. The dataset contains $N=919$ observations, each measurement taken within a home that is located within one of the $J=85$ sampled counties in Minnesota.  The first six rows of the dataframe show us that the county Aitkin has variable levels of $log(radon)$. Our goal is to build a model to predict $log(radon)$.


```r
data(radon, package="rstanarm")
head(radon)
##   floor county  log_radon log_uranium
## 1     1 AITKIN 0.83290912  -0.6890476
## 2     0 AITKIN 0.83290912  -0.6890476
## 3     0 AITKIN 1.09861229  -0.6890476
## 4     0 AITKIN 0.09531018  -0.6890476
## 5     0  ANOKA 1.16315081  -0.8473129
## 6     0  ANOKA 0.95551145  -0.8473129
```

## Pooling  {#pooling}

To highlight the benefits of random intercepts models we will compare three linear regression models: 

* complete pooling
* no pooling
* partial pooling (the random intercept model)


**Complete Pooling**

The complete pooling model pools all counties together to give one single estimate of the $log(radon)$ level. 


**No Pooling**

No pooling refers to the fact that no information is shared among the counties.  Each county is independent of the next.


**Partial Pooling**

The partial pooling model, partially shares information among the counties. 

Each county should get a _unique intercept_ such that the collection of county intercepts are randomly sampled from a normal distribution with mean $0$ and variance $\sigma^2_{\alpha}$.

Because all county intercepts are randomly sampled from the same theoretical population, $N(0, \sigma^2_{\alpha})$, information is shared among the counties.  This sharing of information is generally referred to as **shrinkage**, and should be thought of as a means to reduce variation in estimates among the counties.  When a county has little information to offer, it's estimated intercept will be shrunk towards to overall mean of all counties.



The plot below displays the overall mean as the complete pooling estimate (solid, horizontal line), the no pooling and partial pooling estimates for 8 randomly selected counties contained in the radon data.  The amount of shrinkage from the partial pooling fit is determined by a data dependent compromise between the county level sample size, the variation among the counties, and the variation within the counties.  


<img src="random_intercept_files/figure-html/unnamed-chunk-3-1.png" width="768" style="display: block; margin: auto;" />

Generally, we can see that counties with smaller sample sizes are shrunk more towards the overall mean, while counties with larger sample sizes are shrunk less.  

\BeginKnitrBlock{rmdcaution}<div class="rmdcaution">The fitted values corresponding to different observations within each county of the no-pooling model are jittered to help the eye determine approximate sample size within each county. 

Estimates of variation within each county should not be determined from this arbitrary jittering of points.</div>\EndKnitrBlock{rmdcaution}

## Mathematical Models  {#mathri}

The three models considered set $y_n=log(radon)$, and $x_n$ records floor (0=basement, 1=first floor) for homes $n=1, \ldots, N$.  

### Complete Pooling

The complete pooling model pools all counties together to give them one single estimate of the $log(radon)$ level, $\hat{\alpha}$.  

* The error term $\epsilon_n$ may represent variation due to measurement error, within-house variation, and/or within-county variation.  
* Fans of the random intercept model think that $\epsilon_n$, here, captures too many sources of error into one term, and think that this is a fault of the completely pooled model.


\begin{equation*}
\begin{split}

        y_n = \alpha & + \epsilon_n \\
            & \epsilon_n \sim N(0, \sigma_{\epsilon}^{2})

\end{split}
\end{equation*}


### No Pooling

* The no pooling model gives each county an independent estimate of  $log(radon$), $\hat{\alpha}_{j[n]}$.  
* Read the subscript $j[n]$ as home $n$ is nested within county $j$.  Hence, all homes in each county get their own independent estimate of $log(radon)$.  
* This is equivalent to the fixed effects model
* Here again, one might argue that the error term captures too much noise.


\begin{equation*}
\begin{split}

        y_n = \alpha_{j[n]} & + \epsilon_n \\
            \epsilon_n & \sim N(0, \sigma_{\epsilon}^{2})

\end{split}
\end{equation*}

### Partial Pooling (RI)

* The random intercept model, better known as the partial pooling model, gives each county an intercept term $\alpha_j[n]$ that varies according to its own error term, $\sigma_{\alpha}^2$.  
* This error term measures within-county variation
    - Separating measurement error ($\sigma_{\epsilon}^{2}$) from county level error ($\sigma_{\alpha}^{2}$) . 
* This multi-level modeling shares information among the counties to the effect that the estimates $\alpha_{j[n]}$ are a compromise between the completely pooled and not pooled estimates.  
* When a county has a relatively smaller sample size and/or the variance $\sigma^{2}_{\epsilon}$ is larger than the variance $\sigma^2_{\alpha}$, estimates are shrunk more from the not pooled estimates towards to completely pooled estimate.


\begin{equation*}
\begin{split}

        y_n = \alpha_{j[n]} & + \epsilon_n \\
            \epsilon_n & \sim N(0, \sigma_{\epsilon}^{2}) \\
            \alpha_j[n] & \sim N(\mu_{\alpha}, \sigma_{\alpha}^2)

\end{split}
\end{equation*}


## Components of Variance

Statistics can be thought of as the study of uncertainty, and variance is a measure of uncertainty (and information). So yet again we see that we're partitioning the variance. Recall that 

* Measurement error: $\sigma^{2}_{\epsilon}$ 
* County level error: $\sigma^{2}_{\alpha}$ 

The **intraclass correlation** (ICC, $\rho$) is interpreted as

* the proportion of total variance that is explained by the clusters.  
* the expected correlation between two individuals who are drawn from the same cluster. 

$$ 
\rho = \frac{\sigma^{2}_{\alpha}}{\sigma^{2}_{\alpha} + \sigma^{2}_{\epsilon}}
$$

* When $\rho$ is large, a lot of the variance is at the macro level
    - units within each group are very similar
* If $\rho$ is small enough, one may ask if fitting a multi-level model is worth the complexity. 
* No hard and fast rule to say "is it large enough?"
    - rules of thumb include
        - under 10% (0.1) then a single level analysis may still be appropriate, 
        - over 10\% (0.1) then a multilevel model can be justified. 
  

## Fitting models in R {#fitri}

**Complete Pooling**

The complete pooling model is fit with the function `lm`, and is only modeled by `1` and no covariates. This is the simple mean model, and is equivelant to estimating the mean. 

```r
fit_completepool <- lm(log_radon ~ 1, data=radon)
fit_completepool
## 
## Call:
## lm(formula = log_radon ~ 1, data = radon)
## 
## Coefficients:
## (Intercept)  
##       1.265
mean(radon$log_radon)
## [1] 1.264779
```

**No Pooling**

The no pooling model is also fit with the function `lm`, but gives each county a unique intercept in the model. 


```r
fit_nopool <- lm(log_radon ~ -1 + county, data=radon)
fit_nopool.withint <- lm(log_radon ~ county, data=radon)
```


<table style="text-align:center"><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="2"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="2" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="2">log_radon</td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Constant</td><td></td><td>0.715<sup>*</sup> (0.383)</td></tr>
<tr><td style="text-align:left">countyAITKIN</td><td>0.715<sup>*</sup> (0.383)</td><td></td></tr>
<tr><td style="text-align:left">countyANOKA</td><td>0.891<sup>***</sup> (0.106)</td><td>0.176 (0.398)</td></tr>
<tr><td style="text-align:left">countyBECKER</td><td>1.090<sup>**</sup> (0.443)</td><td>0.375 (0.585)</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="2" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

* The first model (`fit_nopool`) is coded as `lm(log_radon ~ -1 + county, data=radon)`, and so does not have the global intercept (that's what the `-1` does). Each $\beta$ coefficient is the estimate of the mean `log_radon` for that county. 
* The second model (`fit_nopool.withint`) is coded as `lm(log_radon ~ county, data=radon)` and is what we are typically used to fitting.      
    - Each estimate is the difference in log(radon) for that county _compared to a reference county_.
    - Because county is alphabetical, the reference group is AITKIN.
    - Aitkin's mean level of log(radon) shows up as the intercept or _Constant_ term.
* For display purposes only, only the first 3 county estimates are being shown. 

**Partial Pooling**

* The partial pooling model is fit with the function `lmer()`, which is part of the **[`lme4`](https://cran.r-project.org/web/packages/lme4/vignettes/lmer.pdf)** package.
* The extra notation around the input variable `(1|county)` dictates that each county should get its own unique intercept $\alpha_{j[n]}$. 


```r
fit_partpool <- lmer(log_radon ~ (1 |county), data=radon)
```

The fixed effects portion of the model output of `lmer` is similar to output from `lm`, except no p-values are displayed.  The fact that no p-values are displayed is a much discussed topic.  The author of the library `lme4`, Douglas Bates, believes that there is no "obviously correct" solution to calculating p-values for models with randomly varying intercepts (or slopes); see **[here](https://stat.ethz.ch/pipermail/r-help/2006-May/094765.html)** for a general discussion. 


```r
summary(fit_partpool)
## Linear mixed model fit by REML ['lmerMod']
## Formula: log_radon ~ (1 | county)
##    Data: radon
## 
## REML criterion at convergence: 2184.9
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -4.6880 -0.5884  0.0323  0.6444  3.4186 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  county   (Intercept) 0.08861  0.2977  
##  Residual             0.58686  0.7661  
## Number of obs: 919, groups:  county, 85
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)    1.350      0.047   28.72
```

* The random effects portion of the `lmer` output provides a point estimate of the variance of component $\sigma^2_{\alpha} = 0.09$ and the model's residual variance, $\sigma_\epsilon = 0.57$.
* The fixed effect here is interpreted in the same way that we would in a normal fixed effects mean model, as the global predicted value of the outcome of `log_radon`. 
* The random intercepts aren't automatically shown in this output. We can visualize these using a forestplot. We use the `plot_model()` function from the `sjPlot` package, on the `fit_partpool` model, we want to see the random effects (`type="re"`), and we want to sort on the name of the random variable, here it's `"(Intercept)"`. 


```r
sjPlot::plot_model(fit_partpool, type="re", sort.est = "(Intercept)", y.offset = .4)
```

<img src="random_intercept_files/figure-html/unnamed-chunk-9-1.png" width="672" />

Notice that these effects are centered around 0. Refering back \@ref(mathri), the intercept $\beta_{0j}$ was modeled equal to some average intercept across all groups $\gamma_{00}$, plus some difference. What is plotted above is listed in a table below, showing that if you add that random effect to the fixed effect of the intercept, you get the value of the random intercept for each county. 


```r
showri <- data.frame(Random_Effect   = unlist(ranef(fit_partpool)), 
                     Fixed_Intercept = fixef(fit_partpool), 
                     RandomIntercept = unlist(ranef(fit_partpool))+fixef(fit_partpool))
                
rownames(showri) <- rownames(coef(fit_partpool)$county)
kable(head(showri))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Random_Effect </th>
   <th style="text-align:right;"> Fixed_Intercept </th>
   <th style="text-align:right;"> RandomIntercept </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> AITKIN </td>
   <td style="text-align:right;"> -0.2390574 </td>
   <td style="text-align:right;"> 1.34983 </td>
   <td style="text-align:right;"> 1.1107728 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ANOKA </td>
   <td style="text-align:right;"> -0.4071256 </td>
   <td style="text-align:right;"> 1.34983 </td>
   <td style="text-align:right;"> 0.9427047 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BECKER </td>
   <td style="text-align:right;"> -0.0809977 </td>
   <td style="text-align:right;"> 1.34983 </td>
   <td style="text-align:right;"> 1.2688325 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BELTRAMI </td>
   <td style="text-align:right;"> -0.0804277 </td>
   <td style="text-align:right;"> 1.34983 </td>
   <td style="text-align:right;"> 1.2694025 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BENTON </td>
   <td style="text-align:right;"> -0.0254506 </td>
   <td style="text-align:right;"> 1.34983 </td>
   <td style="text-align:right;"> 1.3243796 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIGSTONE </td>
   <td style="text-align:right;"> 0.0582831 </td>
   <td style="text-align:right;"> 1.34983 </td>
   <td style="text-align:right;"> 1.4081133 </td>
  </tr>
</tbody>
</table>





### Comparison of estimates

* By allowing individuals within counties to be correlated, and at the same time let counties be correlated, we allow for some information to be shared across counties. 
* Thus we come back to that idea of shrinkage. Below is a numeric table version of the plot in Section \@ref(pool). 


```r
cmpr.est <- data.frame(Mean_Model       = coef(fit_completepool), 
                       Random_Intercept = unlist(ranef(fit_partpool))+fixef(fit_partpool), 
                       Fixed_Effects    = coef(fit_nopool))
rownames(cmpr.est) <- rownames(coef(fit_partpool)$county)
kable(head(cmpr.est))
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Mean_Model </th>
   <th style="text-align:right;"> Random_Intercept </th>
   <th style="text-align:right;"> Fixed_Effects </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> AITKIN </td>
   <td style="text-align:right;"> 1.264779 </td>
   <td style="text-align:right;"> 1.1107728 </td>
   <td style="text-align:right;"> 0.7149352 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ANOKA </td>
   <td style="text-align:right;"> 1.264779 </td>
   <td style="text-align:right;"> 0.9427047 </td>
   <td style="text-align:right;"> 0.8908486 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BECKER </td>
   <td style="text-align:right;"> 1.264779 </td>
   <td style="text-align:right;"> 1.2688325 </td>
   <td style="text-align:right;"> 1.0900084 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BELTRAMI </td>
   <td style="text-align:right;"> 1.264779 </td>
   <td style="text-align:right;"> 1.2694025 </td>
   <td style="text-align:right;"> 1.1933029 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BENTON </td>
   <td style="text-align:right;"> 1.264779 </td>
   <td style="text-align:right;"> 1.3243796 </td>
   <td style="text-align:right;"> 1.2822379 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIGSTONE </td>
   <td style="text-align:right;"> 1.264779 </td>
   <td style="text-align:right;"> 1.4081133 </td>
   <td style="text-align:right;"> 1.5367889 </td>
  </tr>
</tbody>
</table>





## Estimation Methods

* Similar to logistic regression, estimates from multi-level models typically aren't estimated directly using maximum likelihood (ML) methods. 
* Iterative methods like **Restricted (residual) Maximum Likelihood (REML)** are used to get approximations. 
* REML is typically the default estimation method for most packages. 


Details of REML are beyond the scope of this class, but knowing the estimation method is important for two reasons

1. Some type of testing procedures that use the likelihood ratio may not be valid. 
    - Comparing models with different fixed effects using a likelihood ratio test is not valid. (Must use Wald Test instead) 
    - Can still use AIC/BIC as guidance (not as formal tests)

2. Iterative procedures are procedures that perform estimation steps over and over until the change in estimates from one step to the next is smaller than some tolerance.
    - Sometimes this convergence to an answer never happens. 
    - You will get some error message about the algorithm not converging. 
    - The more complex the model, the higher chance this can happen
    - scaling, centering, and avoiding collinearity can alleviate these problems with convergence.

You can change the fitting algorithm to use the Log Likelihood anyhow, it may be slightly slower but for simple models the estimates are going to be very close to the REML estimate. Below is a table showing the estimates for the random intercepts, 

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> REML </th>
   <th style="text-align:right;"> MLE </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> AITKIN </td>
   <td style="text-align:right;"> 1.1107728 </td>
   <td style="text-align:right;"> 1.1143654 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ANOKA </td>
   <td style="text-align:right;"> 0.9427047 </td>
   <td style="text-align:right;"> 0.9438526 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BECKER </td>
   <td style="text-align:right;"> 1.2688325 </td>
   <td style="text-align:right;"> 1.2700351 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BELTRAMI </td>
   <td style="text-align:right;"> 1.2694025 </td>
   <td style="text-align:right;"> 1.2702493 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BENTON </td>
   <td style="text-align:right;"> 1.3243796 </td>
   <td style="text-align:right;"> 1.3245917 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIGSTONE </td>
   <td style="text-align:right;"> 1.4081133 </td>
   <td style="text-align:right;"> 1.4068866 </td>
  </tr>
</tbody>
</table>



and the same estimates for the variance terms. 

```r
VarCorr(fit_partpool)
##  Groups   Name        Std.Dev.
##  county   (Intercept) 0.29767 
##  Residual             0.76607
VarCorr(fit_partpool_MLE)
##  Groups   Name        Std.Dev.
##  county   (Intercept) 0.29390 
##  Residual             0.76607
```

So does it matter? Yes and no. In general you want to fit the models using REML, but if you really want to use a Likelihood Ratio **test** to compare models then you need to fit the models using ML. 


## Including Covariates

A similar sort of shrinkage effect is seen with covariates included in the model.  

Consider the covariate $floor$, which takes on the value $1$ when the radon measurement was read within the first floor of the house and $0$ when the measurement was taken in the basement. In this case, county means are shrunk towards the mean of the response, $log(radon)$, within each level of the covariate.

<img src="random_intercept_files/figure-html/unnamed-chunk-15-1.png" width="768" style="display: block; margin: auto;" />

Covariates are fit using standard `+` notation outside the random effects specification, i.e. `(1|county)`. 


```r
ri.with.x <- lmer(log_radon ~ floor + (1 |county), data=radon)
tab_model(ri.with.x, show.r2=FALSE)
```

<table style="border-collapse:collapse; border:none;">
<tr>
<th style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm;  text-align:left; ">&nbsp;</th>
<th colspan="3" style="border-top: double; text-align:center; font-style:normal; font-weight:bold; padding:0.2cm; ">log_radon</th>
</tr>
<tr>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  text-align:left; ">Predictors</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">Estimates</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">CI</td>
<td style=" text-align:center; border-bottom:1px solid; font-style:italic; font-weight:normal;  ">p</td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">(Intercept)</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">1.49</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">1.40&nbsp;&ndash;&nbsp;1.59</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</strong></td>
</tr>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; ">floor [first floor]</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;0.66</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  ">&#45;0.80&nbsp;&ndash;&nbsp;-0.53</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:center;  "><strong>&lt;0.001</strong></td>
</tr>
<tr>
<td colspan="4" style="font-weight:bold; text-align:left; padding-top:.8em;">Random Effects</td>
</tr>

<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">&sigma;<sup>2</sup></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.53</td>
</tr>

<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">&tau;<sub>00</sub> <sub>county</sub></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.10</td>

<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">ICC</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">0.16</td>

<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm;">N <sub>county</sub></td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left;" colspan="3">85</td>
<tr>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; text-align:left; padding-top:0.1cm; padding-bottom:0.1cm; border-top:1px solid;">Observations</td>
<td style=" padding:0.2cm; text-align:left; vertical-align:top; padding-top:0.1cm; padding-bottom:0.1cm; text-align:left; border-top:1px solid;" colspan="3">919</td>
</tr>

</table>


Note that in this table format, $\tau_{00} = \sigma^{2}_{\alpha}$ and $\sigma^{2} = \sigma^{2}_{\epsilon}$. The estimated random effects can also be easily visualized using functions from the [sjPlot](http://www.strengejacke.de/sjPlot/) package. 


```r
plot_model(ri.with.x, type="re", sort.est = "(Intercept)", y.offset = .4)
```

<img src="random_intercept_files/figure-html/unnamed-chunk-17-1.png" width="672" />

Function enhancements -- 

* Display the fixed effects by changing `type="est"`. 
* Plot the slope of the fixed effect for each level of the random effect `sjp.lmer(ri.with.x, type="ri.slope")` -- this is being depreciated in the future but works for now. Eventually I'll figure out how to get this plot out of `plot_model()`. 

## More Random Effects

What if you think the slope along some $x$ should vary (such as over time)? 

> This section has not been built yet. Reference this set of notes in the meantime: https://m-clark.github.io/mixed-models-with-R/random_slopes.html



## Centering terms

* Sometimes it might be better to measure the effect of a specific level relative to the average within cluster, rather than overall average.
* The "frog pond" effect
    - A student with an average IQ may be more confident and excel in a group of students with less than average IQ
    - But they may be discouraged and not perform to their potential in a group of students with higher than average IQ.
    
* If the effect of a specific level of a factor is dependent on where the level is in reference to _other cluster members_, more so than where the level is in reference to _all other participants_, the model should be adjusted for as follows: 
* Instead of using the actual value in the regression model you would...
    - calculate the cluster specific average
    - calculate the difference between individual and specific cluster average
    - both cluster average (macro) and difference (micro) are included in the model. 


### A generic `dplyr` approach to centering. 

```
group.means <- data %>% group_by(cluster) %>% summarise(c.ave=mean(variable))
newdata <- data %>% left_join(group.means) %>% mutate(diff = variable - c.ave)
```

1. Create a new data set that I call `group.means` that
    - takes the original `data` set and then (`%>%`)...
    - groups it by the clustering variable so that all subsequent actions are done on each group
    - makes a new variable that I call `c.ave` that is the average of the `variable` of interest
2. I then take the original `data` set, and then
    - merge onto `data`, this `group.means` data set that only contains the clustering variable, and the cluster average variable `c.ave`. 
    - I also toss in a `mutate` to create a new variable that is the `diff`erence between the `variable` of interest and the group averages. 
    - and assign all of this to a `newdata` set 



## Specifying Correlation Structures

* **Independence:** In standard linear models, the assumption on the residuals $\epsilon_{i} \sim \mathcal{N}(0, \sigma_{\epsilon}^{2})$ means that

* The variance of each observation is $\sigma_{\epsilon}^{2}$
* The covariance between two different observations $0$

Consider $n=4$ observations, $y_{1}, \ldots , y_{4}$. Visually the covariance matrix between these four observations would look like this: 

$$
\begin{array}{c|cccc}
  & y_{1} & y_{2} & y_{3} & y_{4}\\
  \hline 
  y_{1} & \sigma_{\epsilon}^{2} & 0 & 0 & 0\\ 
  y_{2} & 0 & \sigma_{\epsilon}^{2} & 0 & 0\\ 
  y_{3} & 0 & 0 & \sigma_{\epsilon}^{2} & 0\\ 
  y_{4} & 0& 0 & 0 & \sigma_{\epsilon}^{2} 
\end{array}
$$

We can also write the covariance matrix as $\sigma_{\epsilon}^{2}$ times the correlation matrix. 

$$
\begin{bmatrix} 
  \sigma_{\epsilon}^{2} & 0 & 0 & 0\\ 
  0 & \sigma_{\epsilon}^{2} & 0 & 0\\ 
  0 & 0 & \sigma_{\epsilon}^{2} & 0\\ 
  0& 0 & 0 & \sigma_{\epsilon}^{2} 
\end{bmatrix}
=
\sigma_{\epsilon}^2 
\begin{bmatrix} 
1 & 0 & 0 & 0 \\ 
& 1 & 0 & 0 \\ 
& & 1 & 0 \\ 
& & & 1 
\end{bmatrix} 
$$



* **Compound Symmetry** or **Exchangeable:** The simplest covariance structure that includes correlated errors is compound symmetry (CS). Here we see correlated errors between individuals, and note that these correlations are presumed to be the same for each pair of responses, namely $\rho$. 

$$
\sigma_{\epsilon}^{2}
\begin{bmatrix} 
1 & \rho & \rho & \rho \\ 
& 1 & \rho & \rho \\ 
& & 1 & \rho \\ 
& & & 1 
\end{bmatrix} 
$$

* **Autoregressive:** Imagine that $y_{1}, \ldots , y_{4}$ were 4 different time points on the same person. The autoregressive (Lag 1) structure considers correlations to be highest for time adjacent times, and a systematically decreasing correlation with increasing distance between time points. This structure is only applicable for evenly spaced time intervals for the repeated measure.

$$
\sigma_{\epsilon}^{2}
\begin{bmatrix} 
1 & \rho & \rho^{2} & \rho^{3} \\ 
& 1 & \rho & \rho^{2} \\ 
& & 1 & \rho \\ 
& & & 1 
\end{bmatrix}
$$


* **Unstructured:** The Unstructured covariance structure (UN) is the most complex because it is estimating unique correlations for each pair of observations. It is not uncommon to find out that you are not able to use this structure simply because there are too many parameters to estimate. 

$$
\begin{bmatrix} 
\sigma_{1}^{2} & \rho_{12} & \rho_{13} & \rho_{14} \\ 
& \sigma_{2}^{2} & \rho_{23} & \rho_{24} \\ 
& & \sigma_{3}^{2} & \rho_{34} \\ 
& & & \sigma_{4}^{2}
\end{bmatrix}
$$

* Random Intercept Model

Let $y_{1}$ and $y_{2}$ be from group 1, and $y_{3}$ and $y_{4}$ be from group 2. 

* error terms between groups are uncorrelated (groups are independent)
* two different observations from the same group have covariance $\sigma_{\alpha}^{2}$
* individuals now have the error associated with their own observation but also due to the group 
  $\sigma_{\epsilon}^{2} + \sigma_{\alpha}^{2}$


$$
\left[
\begin{array}{cc|cc}
  \sigma_{\epsilon}^{2} + \sigma_{\alpha}^{2} & \sigma_{\alpha}^{2} & 0 & 0\\ 
 \sigma_{\alpha}^{2} & \sigma_{\epsilon}^{2} + \sigma_{\alpha}^{2} & 0 & 0\\ 
 \hline
  0 & 0 & \sigma_{\epsilon}^{2} + \sigma_{\alpha}^{2} & \sigma_{\alpha}^{2}\\ 
  0 & 0 & \sigma_{\alpha}^{2} & \sigma_{\epsilon}^{2} + \sigma_{\alpha}^{2} 
\end{array}
\right]
$$


### Changing covariance structures in R

> This is very hard to do as the model becomes more complex. 
> These types of models is where Bayesian statistics has a much easier time fitting models. 
> this section has been commented out of the notes until figured out in a cleaner manner. 

<!---

* Very hard (read - don't bother) to do this using `lmer()` from package `lme4`
* Can do this using `lme()` from package `nlme`. Syntax is similar. 
* The standard classes of correlation structures available in the `nlme` package can be found in [[this help file]](https://stat.ethz.ch/R-manual/R-devel/library/nlme/html/corClasses.html)


```r
library(nlme)
model_lme_cs <- lme(log_radon ~ floor,
                     random = ~ 1 | county, 
                     cor=corCompSymm(value=0.159,form=~1|county),data = radon)
```

Using a different covariance structure can have a large effect on the results. 

* `lmer` using Identity: $\sigma^{2}_{\alpha} = 0.10, \sigma^{2}_{\epsilon} = 0.53$  
* `nlme` using Identity: $\sigma^{2}_{\alpha} = 0.32^2 = 0.10, \sigma^{2}_{\epsilon} = 0.73^2 = 0.53$  
* `nlme` using CS: $\sigma^{2}_{\alpha} = 0.14^2 = 0.02, \sigma^{2}_{\epsilon} = 0.78^2 = 0.61$

\BeginKnitrBlock{rmdcaution}<div class="rmdcaution">Mis-specifying the covariance structure can also have a large effect on the results. </div>\EndKnitrBlock{rmdcaution}

#### Autoregressive 


The AR1 structure specifies that the correlations between the repeated measurements of each subject decrease with the time lag, i.e., the distance in time between the measurements. The data is assumed to be in sort order, where $y_{it}$ and $y_{i(t+1)}$ are in sequential rows. To sort by time within id in dplyr looks like: `arrange(id, time)`. 


* **Equally spaced items**
`lme(..., correlation = corAR1())` which is equivelant to `lme(..., correlation = corAR1(form = ~ 1 | id))` 

* **Not equally spaced items**
`lme(..., correlation = corAR1(form = ~ time | id))`, the `time` variable is used to determine how far apart the measurements are (the time lag). 

* **Discrete vs continuous time**
corAR1() works with discrete time. There is also corCAR1() that works with continuous time.

Ref: https://stats.stackexchange.com/questions/367957/autoregression-in-nlme-undestanding-how-to-specify-corar1


---> 

## Additional References

* Random effects ANOVA in SAS and R http://stla.github.io/stlapblog/posts/AV1R_SASandR.html
* ICCs in mixed models https://www.theanalysisfactor.com/the-intraclass-correlation-coefficient-in-mixed-models/
* Very nice introduction to mixed models in R https://m-clark.github.io/mixed-models-with-R/introduction.html
* Interesting blog by [Tristan Mahr](https://tjmahr.github.io/plotting-partial-pooling-in-mixed-effects-models/) about pooling and shrinkage. 
* Derivation of the covariance structures http://www.bristol.ac.uk/cmm/learning/videos/correlation.html#matrix2 
* Mixed models with R - Michael Clark https://m-clark.github.io/mixed-models-with-R/


### Lecture notes from other classes found on the interwebs

* [BIOL 202: Ecological Statistics from Stanford](https://fukamilab.github.io/BIO202/04-A-mixed-models.html) This is a graduate level class. 


### Package Vignettes
* [lme4](https://cran.r-project.org/web/packages/lme4/vignettes/lmer.pdf) Functions to fit HLMs
* [sjPlot](http://strengejacke.de/sjPlot/sjt.lmer/) **Really** nice way of printing output as tables (and plots).

