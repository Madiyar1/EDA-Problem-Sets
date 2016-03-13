---
  title: "Problem Set 4"
author: "Madiyar Tuleuov"
date: "24 February 2016"
output: html_document
---
  
  This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:
  ---
  Create a scatterplot of price vs x. 
```{r}
ggplot(aes(x=price, y=x), data=diamonds) +
  geom_point()
```
---
  What are your observations about the scatterplot?
It looks that there is no correlation in the data.Almost all data points are horizontal.
---
  What is the correlation between price and x?
0.8844352
What is the correlation between price and y?
0.8654209 
What is the correlation between price and z?
0.8612494 

```{r}
with(diamonds, cor.test(price, x))
with(diamonds, cor.test(price, y))
with(diamonds, cor.test(price, z))
```
---
  #Create a scatterplot of price vs depth
  ```{r}
ggplot(aes(x=price, y=depth), data=diamonds) +
  geom_point()
```
---
  # Change the code to make the transparency of the
  # points to be 1/100 of what they are now and mark
  # the x-axis every 2 units.
  ```{r}
ggplot(data = diamonds, aes(x = depth, y = price)) + 
  geom_point(alpha=1/100) +
  scale_x_discrete(breaks=seq(0, 80, 2))
```
---
  #Whats a correlation of depth and price?
  #-0.0106474 
  #Yes, we can use the depth as a predictor as it doesnt breach the assumption. 
  ```{r}
with(subset(diamonds, volume>=800 & volume>0), cor.test(price, depth))
```
---
  ## Create a scatterplot of price vs carat
  # and omit the top 1% of price and carat
  # values.
  ```{r}
ggplot(aes(x=price, y=carat), data=diamonds)+
  geom_point()


```
---
  # Create a scatterplot of price vs. volume (x * y * z).
  # This is a very rough approximation for a diamond's volume.
  
  # Create a new variable for volume in the diamonds data frame.
  # This will be useful in a later exercise
  ```{r}
diamonds$volume <- (diamonds$x*diamonds$y*diamonds$z)
ggplot(aes(x=price, y=volume, data=diamonds) +
         geom_point()
       ```
       ---
         Well at first it did work now it doesnt.
       ---
         #What re your observation of the scatterplot?
         #There is no relationship between price and volume, but its strange as it doesnt make sense. The bigger the diamond the higher the price should be.
         ```{r}
       with(subset(diamonds,diamonds$volume >0 & diamonds$volume >= 800), cor.test(price, volume))
       ```
       #Use the function dplyr package
       # to create a new data frame containing
       # info on diamonds by clarity.
       
       # Name the data frame diamondsByClarity
       
       # The data frame should contain the following
       # variables in this order.
       #       (1) mean_price
       #       (2) median_price
       #       (3) min_price
       #       (4) max_price
       #       (5) n
       # where n is the number of diamonds in each
       # level of clarity.
       ```{r}
       library(dplyr)
       diamonds.diamonds_by_clarity <- diamonds %>% 
         group_by(clarity) %>% 
         summarise(diamonds_by_clarity_mean = mean(price), diamonds_by_clarity_median = median(price), diamonds_by_clarity_min = min(price), diamonds_by_clarity_max = max(price), n=n()) %>% 
         arrange(price)
       ```
       plot1 <- ggplot(aes(clarity, mean_price), data= diamonds_by_clatiry) +
       geom_bar(stat="identity")
       plot2 <- ggplot(aes(x=color, y= mean_price), data =diamonds_by_color) +
       geom_bar(stat="identity")
       library(gridExtra)
       grid.arrange(plot1, plot2, n=2)
       ##GApminder
       title: "CO2"
author: "Madiyar Tuleuov"
date: "6 March 2016"
output: html_document
---
##CO2 Emission per person.
Here we will try to analyse whether the income growth affects the CO2 emission rates.
Questions:
1)Is there any dependence between co2 and gdp?
2)Is it arguable that more advanced countries have higher co2 emission rate?
3)Is it the case that developing countries have high co2 emission rate?
##Load the Data: put header true so V1 V2 will disapear. 
```{r}
carbon.dioxide <- read.csv("~/Desktop/CO2 emission /carbon dioxide.csv", header=TRUE)
gdp <- read.csv("~/Desktop/CO2 emission /gdp.csv", header=TRUE)
```
##Change the column names:
```{r}
names(carbon.dioxide)[1]<-"country"
names(gdp)[1] <- "country"
```
##Subset the data to the specific time period:
```{r}
co2 <- subset(carbon.dioxide, select=c(country, X1960:X2011))
gdp <- subset(gdp, select=c(country, X1960:X2011))
```
##Cleaning up the data:
```{r}
library(tidyr)
co2_gather <- gather(co2, "year", "emission", 2:53)
library(dplyr)
co2_gather %>% 
  arrange(year)
gdp_gather <- gather(gdp, "year", "rate", 2:53)
gdp_gather %>% 
  arrange(year, country)
```
##Removing NAs:
```{r}
co2_clean <- na.omit(co2_gather)
gdp_clean <- na.omit(gdp_gather)
```
##Joining the data:
```{r}
comb <- left_join(co2_clean, gdp_clean, by=c("country", "year"))
comb_clean <- na.omit(comb)
```
##Correlation Test:
```{r}
cor(comb_clean$rate, comb_clean$emission)
```
##Summary:
```{r}
by(comb_clean, summary)
```
##Plots:
```{r}
library(ggplot2)
p1 <- ggplot(data = comb_clean, aes(x = comb_clean$rate, y = comb_clean$emission))+
  geom_point(alpha=0.99,size = 5, color = 'blue') +  
  geom_smooth(method = 'lm', color = 'orange') +   
  xlab('GDP per capita') +   
  ylab('CO2 emmissions') 
p2 <- ggplot(data = comb_clean, aes(x = comb_clean$mean_income, y = comb_clean$mean_CO2)) + 
  geom_point(alpha = 1/5, size = 5, color = 'blue') +  
  coord_cartesian(xlim = c(0,10000), ylim = c(0,10)) +  
  xlab('GDP per capita') +  
  ylab('CO2 emmissions') 
```