setwd("c:\\DataTK")
#
# SQLBits 2024
# Most Common Mistakes
# 

########################################
### 
###  Issue: Clustering
###
########################################
setwd("/Users/TomazKastrun/Documents/02-Github/SQLBits2024")
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