
# Random Intercept Models {#RI}

Radon data explanation.


```r
data(radon, package="rstanarm")
```

Compare two models, partial pooling versus no-pooling.


```r
fit_partpool <- lme4::lmer(log_radon ~ (1 |county), data=radon)
bfit_partpool <- broom::augment(fit_partpool)

fit_nopool <- lm(log_radon~county, data=radon)
bfit_nopool <- broom::augment(fit_nopool)
```

The plot below displays the overall mean as complete pooling estimate (solid, horizontal line), and the no-pooling (fixed effect) and partial pooling (random effect) estimates for 8 randomly selected counties contained in the radon data.  The amount of shrinkage from the partial pooling fit is determined by sample size, and the variances within and among the counties.  The counties with smaller sample sizes are shrunk more towards the overall mean, while counties with larger sample sizes are shrunk less.  The fitted values corresponding to different observations within each county of the no-pooling model are jittered to help the eye determine approximate sample size within each county.


```r
county_idx <- sample(radon$county, 8)
bfit_nopool %>%
    filter(county %in% county_idx) %>%
    ggplot(aes(x=county, y=.fitted, color="fixed")) +
    geom_jitter() +
    geom_point(data=bfit_partpool[bfit_partpool$county %in% county_idx,],
               aes(y=.fitted, colour="random")) +
    geom_hline(aes(yintercept=mean(bfit_partpool$log_radon))) +
    labs(y="Estimated county means", x="County") +
    theme_bw() +
    theme(axis.text.x=element_text(angle=35, hjust=1)) +
    scale_colour_hue("Effect")
```

<img src="random_intercept_files/figure-html/unnamed-chunk-4-1.png" width="384" style="display: block; margin: auto;" />
