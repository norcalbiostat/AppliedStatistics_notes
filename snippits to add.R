nc <- read.csv("https://norcalbiostat.netlify.com/data/NCbirths.csv", header=TRUE)
library(dplyr)
library(ggplot2); library(scales)


# Plot percents by group

plot.pctF.by.mature.and.habit <- nc %>% select(gender, mature, habit) %>% na.omit() %>% 
  group_by(mature, habit) %>% summarise(nF=n(), pctF = sum(gender=="female")/nF)

ggplot(plot.pctF.by.mature.and.habit, 
        aes(x = mature, y = pctF, group = habit, color = habit)) + 
  geom_line() + geom_point(aes(size=nF)) + ylab("% Female") + 
  scale_y_continuous(limits=c(0,.6), labels=percent) + theme_bw() + 
  scale_size_continuous(name="Sample Size") + 
  scale_color_discrete(name="Smoking Habit")


# Change colors on a pie chart
# https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf

library(RColorBrewer)
my.colors <- brewer.pal(3, "Blues")
pie(table(iris$Species), col=my.colors)

dc <- table(iris$Species)
pct <- round(dc/sum(dc)*100)
lbls <- paste(levels(iris$Species), pct)
lbls <- paste(lbls, "%", sep="")

pie(dc, labels=lbls, col=my.colors, (length(lbls)), main="Species")
