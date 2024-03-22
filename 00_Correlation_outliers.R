cat("\014")
rm(list = ls())
setwd("/Users/tomazkastrun/Documents/06-SQL/03 - 2024/01 - SQLBits (March 2024)/01 - Common Data Science Mistakes")


################
# Correlation thingy
################

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
# Outliers - huh
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

