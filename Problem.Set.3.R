---
title: "Problem Set 3"
author: "Madiyar Tuleuov"
date: "16 February 2016"
output: html_document
---
library(ggplot2)
data(diamonds)
names(diamonds)  
head(diamonds)
summary(diamonds)
?diamonds
head(diamonds, n=40)
dim(diamonds)
levels(diamonds)
ls.str(diamonds)
### Create a histogram of the price of all the diamonds in the dataset
qplot(price,
xlab='Price of the diamond', 
ylab='Number of diamonds',
data=diamonds)
summary(diamonds$price)
### How many diamonds cost less than 500 ? (1729)
summary(diamonds$price <500)
### How many diamonds cost less than 250 ? (0)
summary(diamonds$price <250)
### How many diamonds cost more than 15000 ? (1656)
summary(diamonds$price >=15000)
### Explore the largest peak in the price histogram you created earlier.
qplot(x=price, data=diamonds,binwidth=1, xlim=c(0, 2000) ) +
  scale_x_continuous(limits = c(0, 2000),
                     breaks = seq(0, 2000, 100)) +
ggsave('PriceHistogram.png')
### There is no diamonds at price 1500 in the market, the most common price for the dimonds
### below 1500 is around 650. 

### Break out the histogram of diamonds prices by cut.
qplot(x= price, data=diamonds) +
  facet_wrap(~cut)
### Distribution across the cut is different.

###
qplot(x= price, data=diamonds) +
  facet_wrap(~cut, scales="free_y")
### Create a histogram of price per carat and facet it by cut. 
qplot(x= price/carat, data=diamonds) +
  facet_wrap(~cut, scales="free_y")+
  scale_x_log10()
### when setting the binwidth=1 output doesnt make sense, it becomes uniform distribution
### may be its due to log10(1) doesnt exist or smth in that matter, but when putting 
### log10(1000)=3, setting binwidth=3 doesnt solve the problem.

### Investigate the price of diamonds using boxplot, numerical summaries, and one of the 
### following categorical variables: cut, clarity or color.
qplot(x=clarity,y=price,data=diamonds,geom='boxplot', 
      color=color)
by(diamonds$price, diamonds$clarity, summary)
### Invsetigate the price per carat of diamonds across the different 
### diamonds using boxplot
qplot(x=color,y=price/carat, data=subset(diamonds, !is.na(color)),geom='boxplot', 
      color=color) +
  coord_cartesian(ylim=c(0, 7500))
by(diamonds$price/diamonds$carat, diamonds$color, summary)
### Frequnency Polygon.
qplot(x=carat,data=diamonds,geom='freqpoly', binwidth=0.1)+
  scale_x_continuous(limits=c(0, 3), breaks=seq(0, 10, 0.1))+
  scale_y_continuous(breaks =seq(0,12000, 1000))
table(diamonds$carat)
###Data Wrangling:
#The Energy use total per person was analysed.
#Step1: Format the data from excel to csv.
setwd("/Users/Madiyar/Desktop/Energy use per person")

```{r}
energy_use_total <- read.csv(file="energy use total.csv", header=TRUE, sep=",")
library(tidyr)
energy <- gather(energy_use_total,"year", "count", 2:53)
library(dplyr)
energy_use <- energy %>% 
  arrange(Country, year)
```
Now we can draw the plots to analyse the data.
```{r}
library(ggplot2)
p1 <- ggplot(aes(x=year, y=energy), data=subset(energy_use, !is.na(count))) +
               geom_bar(stat="identity")

```
