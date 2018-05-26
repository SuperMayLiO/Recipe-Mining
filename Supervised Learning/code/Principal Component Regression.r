# 1. Remove Y with zero
#data
recipe_remove0=read.csv('I:/BADM Final/bbc recipes without zero average rating(0107).csv',header=T)
recipe_remove0=recipe_remove0[,-c(1:3)]

#spilt data
set.seed(1234)
train=sample(1:nrow(recipe_remove0),nrow(recipe_remove0)*0.7,rep=F)
test=(1:nrow(recipe_remove0))[-train]

#PCR
#install.packages('pls')
library (pls)
set.seed(1234)
pcr.fit=pcr(average_ratingvalue~., data=recipe_remove0,subset=train ,scale=TRUE,
            validation ="CV")
validationplot(pcr.fit ,val.type="MSEP")
summary(pcr.fit)
#predict
pcr.pred=predict (pcr.fit,recipe_remove0[test,-1], ncomp =2)
sqrt(sum((pcr.pred -recipe_remove0[test ,1])^2)/length(test))#rmse=0.6608985
sum(pcr.pred -recipe_remove0[test ,1])/length(test)#Average error=-0.01881874
sum((pcr.pred -recipe_remove0[test ,1])^2) #sse=981.0234

# 2. Keep Y with zero
#data
recipe_with_0=read.csv('I:/BADM Final/bbc recipes with zero average rating.csv',header=T)
recipe_with_0=recipe_with_0[,-c(1:3)]

#spilt data
set.seed(1234)
train=sample(1:nrow(recipe_with_0),nrow(recipe_with_0)*0.7,rep=F)
test=(1:nrow(recipe_with_0))[-train]

#PCR
#install.packages('pls')
library (pls)
set.seed(1234)
pcr.fit=pcr(average_ratingvalue~., data=recipe_with_0,subset=train ,scale=TRUE,validation ="CV")
validationplot(pcr.fit ,val.type="MSEP")
summary(pcr.fit)
###predict
pcr.pred=predict (pcr.fit,recipe_with_0[test,-1], ncomp =2)
sqrt(sum((pcr.pred -recipe_with_0[test ,1])^2)/length(test))#rmse=1.505759
sum(pcr.pred -recipe_with_0[test ,1])/length(test)#Average error=0.03138372
sum((pcr.pred -recipe_with_0[test ,1])^2) #sse=5720.424
