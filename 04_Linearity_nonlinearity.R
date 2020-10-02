setwd("c:\\DataTK")
#
# SQLBits 2020
# 
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
degree_to_plot=c(1,2,3,5,10)
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
