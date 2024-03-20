## ## ## ## ##
## SQLBits 2024
## Most Common Mistakes

#############################
# 1. General Statistics
#############################


####################
# 1) Data Types
####################

# Vectors
a <- c(1,2,5.3,6,-2,4) # numeric vector
b <- c("one","two","three") # character vector
c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) #logical vector

str(b)

# Matrices
# generates 5 x 4 numeric matrix
y<-matrix(1:20, nrow=5,ncol=4)

# another example
cells <- c(1,26,24,68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
mymatrix <- matrix(cells, nrow=2, ncol=2, byrow=TRUE,
                   dimnames=list(rnames, cnames)) 


# Data Frames
d <- c(1,2,3,4)
e <- c("red", "white", "red", NA)
f <- c(TRUE,TRUE,TRUE,FALSE)
mydata <- data.frame(d,e,f)
names(mydata) <- c("ID","Color","Passed") # variable name



# Factors
## Tell R that a variable is nominal by making it a factor. The factor stores the nominal values as a vector of integers in the range [ 1... k ] 
## (where k is the number of unique values in the nominal variable), and an internal vector of character strings (the original values) mapped to these integers. 

# variable gender with 20 "male" entries and
# 30 "female" entries
rm(gender)
gender <- c(rep("male",20), rep("female", 30))
str(gender)
gender <- factor(gender)
str(gender)

# stores gender as 20 1s and 30 2s and associates
# 1=female, 2=male internally (alphabetically)
# R now treats gender as a nominal variable
summary(gender) 

# Ordered factor is used to represent ordinal  variable
# variable rating coded as "large", "medium", "small'
rm(rating)
rating <- c(1,2,1,1,1,2,3,3)
rating
rating <- ordered(rating)
rating
# recodes rating to 1,2,3 and associates
# R now treats rating as ordinal 


############################
# Causation and correlation
###########################

# https://bigdata-madesimple.com/how-to-tell-if-correlation-implies-causation/
# Sometimes it’s next to impossible to convince skeptics of a causal relationship. Sometimes it’s even tough to convince your supporters. Developing criteria for causality has been a topic of concern in medicine for centuries. Several sets of criteria have been proffered over those years, the most widely cited of which are the criteria described in 1965 by Austin Bradford Hill, a British medical statistician. Hill’s criteria for causation specify the minimal conditions necessary to accept the likelihood of a causal relationship between two measures as:
#   
# Strength: A relationship is more likely to be causal if the correlation coefficient is large and statistically significant.
# Consistency: A relationship is more likely to be causal if it can be replicated.
# Specificity: A relationship is more likely to be causal if there is no other likely explanation.
# Temporality: A relationship is more likely to be causal if the effect always occurs after the cause.
# Gradient: A relationship is more likely to be causal if a greater exposure to the suspected cause leads to a greater effect.
# Plausibility: A relationship is more likely to be causal if there is a plausible mechanism between the cause and the effect
# Coherence: A relationship is more likely to be causal if it is compatible with related facts and theories.
# Experiment: A relationship is more likely to be causal if it can be verified experimentally.
# Analogy: A relationship is more likely to be causal if there are proven relationships between similar causes and effects.



# Assumption: eating sugar causes weight gain 

likes_sugar <- c(1,1,1,1,1,0,0,0,0)
weight <- c(70,75,74,80,51,56,54,50,48) # Let's assume all women are same height | race 
df <- data.frame(cbind(likes_sugar, weight))
cor(df)

#indeed true!  there is correlation between eating sugar and weight_gain
# but what if there is another thingy in there. let's check for pregnancy test
preg <- c(1,1,1,1,0,0,0,0,0) #  1 - pregnant / 0 - not-pregnant
df <- data.frame(cbind(preg, weight, likes_sugar))
cor(df)

# The classic causation vs correlation conclusion is that eating 
# sugaris correlated with gaining weight, but doesn't cause pregnancy. :-)


################
# 3) Outliers
################

# Inject outliers into data.
cars1 <- cars[1:30, ]  # original data
cars_outliers <- data.frame(speed=c(19,19,20,20,20), dist=c(190, 186, 210, 220, 218))  # introduce outliers.
cars2 <- rbind(cars1, cars_outliers)  # data with outliers.



# Plot of data with outliers.
par(mfrow=c(1, 2))
plot(cars2$speed, cars2$dist, xlim=c(0, 28), ylim=c(0, 230), main="With Outliers", xlab="speed", ylab="dist", pch="*", col="red", cex=2)
abline(lm(dist ~ speed, data=cars2), col="blue", lwd=3, lty=2)

###############################
# What happens if we ignore
###############################

# Plot of original data without outliers. Note the change in slope (angle) of best fit line.
plot(cars1$speed, cars1$dist, xlim=c(0, 28), ylim=c(0, 230), main="Outliers removed \n A much better fit!", xlab="speed", ylab="dist", pch="*", col="red", cex=2)
abline(lm(dist ~ speed, data=cars1), col="blue", lwd=3, lty=2)


par(mfrow=c(1, 1))

############################
#### HOW TO:
## Detect outliers
## Correct
############################

url <- "http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv"  
# alternate source:  https://raw.githubusercontent.com/selva86/datasets/master/ozone.csv
inputData <- read.csv(url)  # import data

outlier_values <- boxplot.stats(inputData$pressure_height)$out  # outlier values.
boxplot(inputData$pressure_height, main="Pressure Height", boxwex=0.1)
mtext(paste("Outliers: ", paste(outlier_values, collapse=", ")), cex=0.6)



url <- "http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv"
ozone <- read.csv(url)

# For categorical variable
boxplot(ozone_reading ~ Month, data=ozone, main="Ozone reading across months")  # clear pattern is noticeable.

# this may not be significant, as day of week variable is a subset of the month var.
boxplot(ozone_reading ~ Day_of_week, data=ozone, main="Ozone reading for days of week")  


# Multivariate approach
mod <- lm(ozone_reading ~ ., data=ozone)
cooksd <- cooks.distance(mod)


plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4*mean(cooksd, na.rm=T), col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels



car::outlierTest(mod)



########################################
### 
###  Issue: Clustering
###
########################################

set.seed(29081978)

weight_kg  <- c(60, 62, 64, 63, 63,62,60,66)
height_inc <- c(66, 65, 67, 64, 66,67,66,65) 
height_cm  <- c(167,165,170,162,167,170,167,165)

dd_cm <- data.frame(cbind(weight_kg=as.integer(weight_kg), height_cm=as.integer(height_cm)))
dd_inc <- data.frame(cbind(weight_kg=as.integer(weight_kg), height_inc=as.integer(height_inc)))


# K-means
cl_cm  <- kmeans(dd_cm, 2)
cl_inc <- kmeans(dd_inc, 2)


# show kmeans
# install.packages("factoextra")
library(factoextra)
#library(ggpubr, lib.loc="C:\\R")

library(gridExtra)
library(ggplot2)

p1 <- fviz_cluster(cl_cm, data = dd_cm) + ggtitle("2CL with cm")
p2 <- fviz_cluster(cl_inc, data = dd_inc)  + ggtitle("2CL with inc")
grid.arrange(p1, p2, nrow = 1)


# Dissimilarity matrix
d_cm  <- dist(dd_cm,  method = "euclidean")
d_inc <- dist(dd_inc, method = "euclidean")

# hierarchical clustering
hc_cm  <- hclust(d_cm,  method = "complete" )
hc_inc <- hclust(d_inc, method = "complete" )

dev.off(dev.list()["RStudioGD"])
par(mfrow = c(1, 2))
plot(hc_cm, cex = 0.6, hang = -1, main = "Dendrogram based on centimeter", cex.main = .6,   font.main= 1, xlab="Distance-cm")
plot(hc_inc, cex = 0.6, hang = -1, main = "Dendrogram based on inches", cex.main = .6,   font.main= 1, xlab="Distance-inc")
par(mfrow = c(1, 1))

# compare the metrics  of dissimilarity matrix and hierarchical clustering
summary(d_cm)[4] # mean
summary(d_inc)[4] # mean


# comparte the metrics of  kmeans
cl_cm$withinss 
cl_cm$betweenss
cl_inc$withinss
cl_inc$betweenss


########################################
### 
###  Solution: Normalizing the data
###
########################################
# Standardization
# based on library clusterSim
#n1 - standardization ((x-mean)/sd)

## normalize height
# Do not do this; unless use apply
#dd_cm$dd_height_norm <- (dd_cm$X2 - mean(dd_cm$X2)/sd(dd_cm$X2))

sd <- sd(dd_cm$height_cm)
mean <- mean(dd_cm$height_cm)
dd_cm$dd_height_norm  <- ((dd_cm$height_cm - mean) / sd)


sd <- sd(dd_inc$height_inc)
mean <- mean(dd_inc$height_inc)
dd_inc$dd_height_norm  <- ((dd_inc$height_inc - mean) / sd)

dd_cm2 <- cbind(dd_cm$weight_kg, dd_cm$dd_height_norm)
dd_inc2 <- cbind(dd_inc$weight_kg, dd_inc$dd_height_norm)


#check the kmeans with standardized values
cl_cm2  <- kmeans(dd_cm2, 2)
cl_inc2 <- kmeans(dd_inc2, 2)

cl_cm2$withinss 
cl_inc2$withinss

cl_cm2$betweenss
cl_inc2$betweenss

#############################################################



setwd("c:\\DataTK")
#
# Zagreb 2019
# SQLSat 832
# Most Common Mistakes
# 

#######################################################
### 
###  Linearity or non-linearity
###
#######################################################

library(data.table)
library(ggplot2)

overfitting_data <- data.table(airquality)


head(airquality, n=3)

data_test=na.omit(overfitting_data[,.(Wind,Ozone)])
train_sample=sample(1:nrow(data_test),size = 0.6*nrow(data_test))


degree_of_poly=1:10
degree_to_plot=c(1,2,3,5)
polynomial_model=list()
df_result=NULL

for (degree in degree_of_poly) {
  fm=as.formula(paste0("Ozone~poly(Wind,",degree,",raw=T)"))
  polynomial_model=c(polynomial_model,list(lm(fm,data_test[train_sample])))
  Polynomial_degree=paste0(degree)
  data_fitted=tail(polynomial_model,1)[[1]]$fitted.values
  new_df=data.table(Wind=data_test[train_sample,Wind],Ozone_real=data_test[train_sample,Ozone],Ozone_fitted=tail(polynomial_model,1)[[1]]$fitted.values,degree=as.factor(degree))
  if (is.null(df_result))
    df_result=new_df
  else
    df_result=rbind(df_result,new_df)
}



ggplot(df_result[degree%in%degree_to_plot],aes(x=Wind))+geom_point(aes(y=Ozone_real))+geom_line(aes(color=degree,y=Ozone_fitted))


 
