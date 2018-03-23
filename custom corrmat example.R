library(lme4qtl)
library(lme4)
library(dplyr)
library(sjPlot)



data(dat40)
dat4sub <- dat40 %>% filter(FAMID %in% c("10", "11", "12", "13", "14", "15")) %>% droplevels()

lm(trait1 ~ AGE + FAMID, data=dat4sub)
l4mod <- lmer(trait1~AGE + (1|FAMID), data=dat4sub)

indep <- diag(6); colnames(indep) <- rownames(indep) <- c("10", "11", "12", "13", "14", "15")
corrplot::corrplot(indep)
l4qmod <- relmatLmer(trait1 ~ AGE + (1|FAMID), dat4sub, relmat = list(FAMID = indep))

cs <- indep
rho = .5
for(i in 1:6){
  for(j in 1:6){
      if(i!=j) cs[i,j] <- rho
  }
}
corrplot::corrplot(cs)
l4qmod <- relmatLmer(trait1 ~ AGE + (1|FAMID), dat4sub, relmat = list(FAMID = cs))


ri <- cs
for(i in 1:3){
  for(j in 4:6){
    ri[i,j] <- ri[j,i] <- 0
  }
}
# ri[lower.tri(ri)] <- ri[upper.tri(ri)]
corrplot::corrplot(ri)
l4qmod <- relmatLmer(trait1 ~ AGE + (1|FAMID), dat4sub, relmat = list(FAMID = ri))





# same table and plot options since it's a lmer object
sjt.lmer(l4mod)
sjt.lmer(l4qmod)

plot_model(l4qmod, type="re", y.offset = .4)

