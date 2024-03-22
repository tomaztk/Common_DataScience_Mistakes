

#######################################################
### 
###  Issue: Myth that data ALWAYS (!) needs to be correlated
###
#######################################################
cat("\014")
rm(list = ls())
setwd("/Users/tomazkastrun/Documents/06-SQL/03 - 2024/01 - SQLBits (March 2024)/01 - Common Data Science Mistakes")

set.seed(29102008)

### 1. General Linear Model with logistic regression
library(ggplot2)
library(dplyr)
library(tidyr)
library(cowplot)


# make a reduced iris data set that only contains virginica and versicolor species
# so we can run logistic regression against variable -> species (binary / two-class)
iris.small <- filter(iris, Species %in% c("virginica", "versicolor"))

dim(iris.small)


# fit a logistic regression model to the data
glm.out <- glm(Species ~ Petal.Width + Petal.Length + Sepal.Width,data = iris.small,family = binomial)

glm.out$linear.predictors
iris.small$Species


# extract linear predictors for each observation
lr_data <- data.frame(predictor = glm.out$linear.predictors, Species = iris.small$Species)


# get a density plot for each species
# separate them into two datasets
d_virg <- density(filter(lr_data, Species == "virginica")$predictor)
d_vers <- density(filter(lr_data, Species == "versicolor")$predictor)

par(mfrow = c(1, 2))
plot(d_virg)
plot(d_vers)
par(mfrow=c(1,1))


#combined
#original state
plot(d_virg, xlim=c(-30, 30), ylim=c(0,0.08), col="red", main="density predictors")
lines(d_vers, col="blue")


# move each species' density plot to overlap at the center.this is the starting point
# we create a separate datasets for each of the species
# Adding the Virg mean that is correlated with the mean(x)
# adding the predictor to Versi that is not correlated with mean(x)
virg_t1 <- data.frame(predictor = d_virg$x - 11.7, 
                   density = d_virg$y, 
                   time = 1, 
                   Species = "virginica")
vers_t1 <- data.frame(predictor = d_vers$x + 11.8, 
                      density = d_vers$y, 
                      time = 1, 
                      Species = "versicolor")


virg_t6 <- virg_t1 %>% mutate(predictor = predictor + 15, time = 2) 
vers_t6 <- vers_t1 %>% mutate(predictor = predictor - 15, time = 2) 



# combine virginica and versicolor data sets separately.
# this is essential to move density plots independently of each other

# merge datapoints together
p_dist1 <- ggplot(mapping  = aes(predictor, density, group = 2)) +
  geom_line(data = virg_t1, color = "red") +
  geom_line(data = vers_t1, color="blue") 

# merge datapoints together
p_dist2 <- ggplot(mapping  = aes(predictor, density, group = 2)) +
  geom_line(data = virg_t6, color = "red") +
  geom_line(data = vers_t6, color="blue") 


#Helper multiplot function
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}



#combined on one png
multiplot(p_dist1, p_dist2, cols=2)


# Helper ROC function
calc_ROC <- function(probabilities, known_truth, model.name = NULL)
{
  outcome <- as.numeric(factor(known_truth))-1
  pos <- sum(outcome) # total known positives
  neg <- sum(1-outcome) # total known negatives
  pos_probs <- outcome*probabilities # probabilities for known positives
  neg_probs <- (1-outcome)*probabilities # probabilities for known negatives
  true_pos <- sapply(probabilities,
                     function(x) sum(pos_probs>= x)/pos) # true pos. rate
  false_pos <- sapply(probabilities,
                      function(x) sum(neg_probs>= x)/neg)
  if (is.null(model.name))
    result <- data.frame(true_pos, false_pos)
  else
    result <- data.frame(true_pos, false_pos, model.name)
  result %>% arrange(false_pos, true_pos)
}


# combine all data frames and calculate ROC curves and AUC values
ROC <-  rbind(virg_t1, virg_t6, vers_t1, vers_t6) %>%
          mutate(probabilities = exp(predictor)/(1+exp(predictor))) %>% # calculate probabilities for linear predictors
          group_by(time) %>% 
          do(results = calc_ROC(probabilities = .$probabilities, known_truth = .$Species)) %>% # get True_positives and Flase_positives
          group_by(time) %>%
          do(as.data.frame(.$results)) %>% # store output from calc_ROC() in the data frame
          mutate(delta=false_pos-lag(false_pos)) %>%# calculate AUC values
          mutate(AUC=round(sum(delta*true_pos, na.rm=T), 3))

head(ROC)
ROC_1 <- filter(ROC, time == 1)
ROC_6 <- filter(ROC, time == 2)


# make an animation with ROC curves
p_ROC1 <- ggplot(data = ROC_1, aes(x = true_pos, y=false_pos)) + #, y = true_pos)) +
  geom_line(size = .8, color="brown") +
  geom_abline(intercept = 0, slope = 1, color = "green") +
  labs(title = "AUC") +
  scale_x_continuous(name = "False positive rate") +
  scale_y_continuous(name = "True positive rate") 

p_ROC2 <- ggplot(data = ROC_6, aes(x = true_pos, y=false_pos)) + #, y = true_pos)) +
  geom_line(size = .8, color="brown") +
  geom_abline(intercept = 0, slope = 1, color = "green") +
  labs(title = "AUC") +
  scale_x_continuous(name = "False positive rate") +
  scale_y_continuous(name = "True positive rate") 


#combined on one png
multiplot(p_ROC1, p_ROC2, cols=2)

#combines AUC and density
multiplot(p_dist1, p_ROC1, p_dist2, p_ROC2, cols=2)



########################
### 2.  Factor Analysis
########################

# check for assumptions: https://www.statisticssolutions.com/factor-analysis-sem-exploratory-factor-analysis/
library(psych)
library(MASS)
library(factoextra)


bfi_data=bfi
bfi_data=bfi_data[complete.cases(bfi_data),]
# cor.plot(bfi_data[,c(1:25)])
bfi_cor <- cor(bfi_data)
#Factor analysis of the data
factors_data <- fa(r = bfi_cor, nfactors = 6)



mu <- rep(0,10)
Sigma <- matrix(.7, nrow=10, ncol=10) + diag(10)*.3
rawvars <- mvrnorm(n=10000, mu=mu, Sigma=Sigma)

cov(rawvars); cor(rawvars)
#normal distribution
pvars <- pnorm(rawvars)
cov(pvars); cor(pvars)

# http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/116-mfa-multiple-factor-analysis-in-r-essentials/

#install.packages("FactoMineR")
library(FactoMineR)

data(wine)
head(wine)
res.mfa <- MFA(wine, 
               group = c(2, 5, 3, 10, 9, 2), 
               type = c("n", "s", "s", "s", "s", "s"),
               name.group = c("origin","odor","visual",
                              "odor.after.shaking", "taste","overall"),
               num.group.sup = c(1, 6),
               graph = FALSE)
eig.val <- get_eigenvalue(res.mfa)
head(eig.val)


df_raw <- data.frame(rawvars)
raw.mfa <- MFA(df_raw, group = c(2,5,3))
eig.val <- get_eigenvalue(df_raw)
head(eig.val)
