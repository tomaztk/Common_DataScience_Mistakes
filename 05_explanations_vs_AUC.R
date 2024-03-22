#
#  Lime example
#  interpretation

#install.packages("lime")
library("lime")
library(MASS)

data(biopsy)

# check the data
head(biopsy)

# First we'll clean up the data a bit
biopsy$ID <- NULL
biopsy <- na.omit(biopsy)
names(biopsy) <- c('clump thickness', 'uniformity of cell size', 
                   'uniformity of cell shape', 'marginal adhesion',
                   'single epithelial cell size', 'bare nuclei', 
                   'bland chromatin', 'normal nucleoli', 'mitoses',
                   'class')


# Now we'll fit a linear discriminant model on all but 4 cases
set.seed(4)
test_set <- sample(seq_len(nrow(biopsy)), 4)
prediction <- biopsy$class
biopsy$class <- NULL
# discriminant analysis
model <- lda(biopsy[-test_set, ], prediction[-test_set])

#do the prediction
predict(model, biopsy[test_set, ])


explainer <- lime(biopsy[-test_set,], model, bin_continuous = TRUE, quantile_bins = FALSE)
explanation <- explain(biopsy[test_set, ], explainer, n_labels = 1, n_features = 4)

# Only showing part of output for better printing
explanation[, 2:9]

#or plot the features
plot_features(explanation, ncol = 1)
