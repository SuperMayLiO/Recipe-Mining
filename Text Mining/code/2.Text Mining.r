#安裝package:
install.packages("NLP")
install.packages("tm")
install.packages("SnowballC")
install.packages("textir")
install.packages("fpc")
install.packages("lsa")
install.packages("cluster")

#安裝package Rgraphviz
source("http://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")


#1.載入函式
# for text mining functions
library(NLP)
library(tm)
# for word stemming
library(SnowballC)
# for plot
library(Rgraphviz)
#source("http://bioconductor.org/biocLite.R")
#biocLite("Rgraphviz") 
# for calculating the tf-idf
library(textir)
library(fpc)
# for correlation
library(lsa)
# for cluster
library(cluster)

#2.讀檔
recipes <- dish_com_pos[,2] #抓positive recipe欄位
recipes <- dish_com_neg[,2] #抓negative recipe欄位

#3.字串處理
corpus <- Corpus(VectorSource(recipes)) #轉格式
corpus <- tm_map(corpus, content_transformer(function(x) chartr("-/","  ", x))) #將"-/"等符號轉成空白
corpus <- tm_map(corpus, removePunctuation, preserve_intra_word_dashes=FALSE) #移除標點
corpus <- tm_map(corpus, content_transformer(tolower)) # 轉成小寫
corpus <- tm_map(corpus, removeWords, stopwords("english")) # 移除stop words
corpus <- tm_map(corpus, removeNumbers) # 移除數字
corpus <- tm_map(corpus, stripWhitespace) #移除多餘空白
corpus <- tm_map(corpus, stemDocument) #Stem words in a text document using Porter's stemming algorithm

#4.輸出字串處理好的結果
outputcorpus <- unlist(sapply(corpus,"[","content")) #轉換格式
outputcorpus2 <- data.frame(outputcorpus) #轉換格式
write.csv2(outputcorpus2, "corpus.csv") #輸出檔案

#5.???p算NTF-IDF
doctermmatrix <- DocumentTermMatrix(corpus) #???p算TF
countterm <- sapply(gregexpr("//W+", outputcorpus), length) + 1 #???p算每篇文章字數-方法1
#countterm <- rowSums(as.matrix(doctermmatrix)) #???p算每篇文章字數-方法2
nterm <- sum(countterm)#加總每篇文章字數
ndoc <- length(corpus) #總文章數
norm <- nterm/ndoc     # 先算(所有文章總字數/總文章數) 
tfidf <- tfidf(doctermmatrix,FALSE) #???p算tf-idf
ntfidf <- tfidf*norm/countterm  #???p算ntf-idf
matrix.ntfidf <- as.matrix(ntfidf)
write.csv2(matrix.ntfidf,"ntfidf.csv") # 輸出
sortterm <- sort(colSums(matrix.ntfidf), decreasing=TRUE) #排序
freqterm <-  names(sortterm[1:200]) #抓前100???茼W字
freqterm <-  sortterm[1:200] #抓名字及ntf-idf
write.csv2(freqterm,"freqterm.csv") #輸出
#########see top 50 manually##########
top200_to_top50=grep('cherr',unique(others_com_neg[,2]),value=T) #see top 100 words to pick top 50
#top200_to_top50
write.table(top200_to_top50,"top100_to_top50.txt")
#setwd("C:/Users/May/Documents")
#############################
top50 <- read.csv2("top50.csv") #讀入csv檔
top50 <-names(top50) #取出前50名的words
top50[top50=='next.']='next'
freqterm.ntfidf <- matrix.ntfidf[,top50] #取出前50名的NTFIDF
write.csv2(freqterm.ntfidf,"top50ntfidf.csv") # 輸出

#6.???p算correlation
cordoc <- cosine(freqterm.ntfidf) #word的關聯系數
cordoc2 <- cosine(t(freqterm.ntfidf)) #食譜的關聯系數
write.csv2(cordoc,"cordoc.csv") #輸出
write.csv2(cordoc2,"cordoc2.csv") #輸出


#7.k-means-words
#set.seed(1234)
set.seed(100)
#set.seed(12)
#set.seed(1)
#set.seed(139)
wclusterresult2 <- kmeans(cordoc,2) #K-means分2???
wclusterresult3 <- kmeans(cordoc,3) #K-means分3???
wclusterresult4 <- kmeans(cordoc,4) #K-means分4???
wrmsstd2<-sqrt(sum(wclusterresult2$withinss/(wclusterresult2$size-1))) #2???的RMSSTD
wrmsstd3<-sqrt(sum(wclusterresult3$withinss/(wclusterresult3$size-1))) #3???的RMSSTD
wrmsstd4<-sqrt(sum(wclusterresult4$withinss/(wclusterresult4$size-1))) #4???的RMSSTD
wRS2inverse<-(wclusterresult2$totss/wclusterresult2$betweenss) #2???的1/RS
wRS3inverse<-(wclusterresult3$totss/wclusterresult3$betweenss) #3???的1/RS
wRS4inverse<-(wclusterresult4$totss/wclusterresult4$betweenss) #4???的1/RS
wc2<-wrmsstd2+wRS2inverse  #2???的RMSSTD+1/RS
wc3<-wrmsstd3+wRS3inverse  #3???的RMSSTD+1/RS
wc4<-wrmsstd4+wRS4inverse  #4???的RMSSTD+1/RS
w_summary_sum=data.frame(twocluster=c(wc2),threecluster=c(wc3),fourcluster=c(wc4)) #RMSSTD+1/RS
write.csv2(w_summary_sum,"w_summary_sum.csv") #輸出2~4???的RMSSTD+1/RS
w_x.num<-c(2,3,4) #增加群組的名字(第1欄)
w_y.str<-c(wc2,wc3,wc4) #增加群組的????(第2欄)
w_xy.data<-data.frame(x.num.name=w_x.num, y.str.name=w_y.str) #結合第1,2欄為data.frame
w_cluster_sort<-w_xy.data[order(w_xy.data$y.str.name),]  #以RMSSTD+1/RS排序
w_z <-w_cluster_sort[1,1] #找出最佳???組
w_clusterresult<- kmeans(cordoc,w_z)#K-means分w_z???
write.csv2(w_z,"w_suggest_group_number.csv") #輸出
write.csv2(w_clusterresult$centers,"w_cluster_center.csv") #輸出

clusplot(as.matrix(cordoc),w_clusterresult$cluster,color=T,shade=T,labels=2,lines=0,cex=1.5) #畫圖

sort(w_clusterresult$cluster)





















