#�w��package:
install.packages("NLP")
install.packages("tm")
install.packages("SnowballC")
install.packages("textir")
install.packages("fpc")
install.packages("lsa")
install.packages("cluster")

#�w��package Rgraphviz
source("http://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")


#1.���J�禡
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

#2.Ū��
recipes <- dish_com_pos[,2] #��positive recipe���
recipes <- dish_com_neg[,2] #��negative recipe���

#3.�r��B�z
corpus <- Corpus(VectorSource(recipes)) #��榡
corpus <- tm_map(corpus, content_transformer(function(x) chartr("-/","  ", x))) #�N"-/"���Ÿ��ন�ť�
corpus <- tm_map(corpus, removePunctuation, preserve_intra_word_dashes=FALSE) #�������I
corpus <- tm_map(corpus, content_transformer(tolower)) # �ন�p�g
corpus <- tm_map(corpus, removeWords, stopwords("english")) # ����stop words
corpus <- tm_map(corpus, removeNumbers) # �����Ʀr
corpus <- tm_map(corpus, stripWhitespace) #�����h�l�ť�
corpus <- tm_map(corpus, stemDocument) #Stem words in a text document using Porter's stemming algorithm

#4.��X�r��B�z�n�����G
outputcorpus <- unlist(sapply(corpus,"[","content")) #�ഫ�榡
outputcorpus2 <- data.frame(outputcorpus) #�ഫ�榡
write.csv2(outputcorpus2, "corpus.csv") #��X�ɮ�

#5.???p��NTF-IDF
doctermmatrix <- DocumentTermMatrix(corpus) #???p��TF
countterm <- sapply(gregexpr("//W+", outputcorpus), length) + 1 #???p��C�g�峹�r��-��k1
#countterm <- rowSums(as.matrix(doctermmatrix)) #???p��C�g�峹�r��-��k2
nterm <- sum(countterm)#�[�`�C�g�峹�r��
ndoc <- length(corpus) #�`�峹��
norm <- nterm/ndoc     # ����(�Ҧ��峹�`�r��/�`�峹��) 
tfidf <- tfidf(doctermmatrix,FALSE) #???p��tf-idf
ntfidf <- tfidf*norm/countterm  #???p��ntf-idf
matrix.ntfidf <- as.matrix(ntfidf)
write.csv2(matrix.ntfidf,"ntfidf.csv") # ��X
sortterm <- sort(colSums(matrix.ntfidf), decreasing=TRUE) #�Ƨ�
freqterm <-  names(sortterm[1:200]) #��e100???ӦW�r
freqterm <-  sortterm[1:200] #��W�r��ntf-idf
write.csv2(freqterm,"freqterm.csv") #��X
#########see top 50 manually##########
top200_to_top50=grep('cherr',unique(others_com_neg[,2]),value=T) #see top 100 words to pick top 50
#top200_to_top50
write.table(top200_to_top50,"top100_to_top50.txt")
#setwd("C:/Users/May/Documents")
#############################
top50 <- read.csv2("top50.csv") #Ū�Jcsv��
top50 <-names(top50) #���X�e50�W��words
top50[top50=='next.']='next'
freqterm.ntfidf <- matrix.ntfidf[,top50] #���X�e50�W��NTFIDF
write.csv2(freqterm.ntfidf,"top50ntfidf.csv") # ��X

#6.???p��correlation
cordoc <- cosine(freqterm.ntfidf) #word�����p�t��
cordoc2 <- cosine(t(freqterm.ntfidf)) #���Ъ����p�t��
write.csv2(cordoc,"cordoc.csv") #��X
write.csv2(cordoc2,"cordoc2.csv") #��X


#7.k-means-words
#set.seed(1234)
set.seed(100)
#set.seed(12)
#set.seed(1)
#set.seed(139)
wclusterresult2 <- kmeans(cordoc,2) #K-means��2???
wclusterresult3 <- kmeans(cordoc,3) #K-means��3???
wclusterresult4 <- kmeans(cordoc,4) #K-means��4???
wrmsstd2<-sqrt(sum(wclusterresult2$withinss/(wclusterresult2$size-1))) #2???��RMSSTD
wrmsstd3<-sqrt(sum(wclusterresult3$withinss/(wclusterresult3$size-1))) #3???��RMSSTD
wrmsstd4<-sqrt(sum(wclusterresult4$withinss/(wclusterresult4$size-1))) #4???��RMSSTD
wRS2inverse<-(wclusterresult2$totss/wclusterresult2$betweenss) #2???��1/RS
wRS3inverse<-(wclusterresult3$totss/wclusterresult3$betweenss) #3???��1/RS
wRS4inverse<-(wclusterresult4$totss/wclusterresult4$betweenss) #4???��1/RS
wc2<-wrmsstd2+wRS2inverse  #2???��RMSSTD+1/RS
wc3<-wrmsstd3+wRS3inverse  #3???��RMSSTD+1/RS
wc4<-wrmsstd4+wRS4inverse  #4???��RMSSTD+1/RS
w_summary_sum=data.frame(twocluster=c(wc2),threecluster=c(wc3),fourcluster=c(wc4)) #RMSSTD+1/RS
write.csv2(w_summary_sum,"w_summary_sum.csv") #��X2~4???��RMSSTD+1/RS
w_x.num<-c(2,3,4) #�W�[�s�ժ��W�r(��1��)
w_y.str<-c(wc2,wc3,wc4) #�W�[�s�ժ�????(��2��)
w_xy.data<-data.frame(x.num.name=w_x.num, y.str.name=w_y.str) #���X��1,2�欰data.frame
w_cluster_sort<-w_xy.data[order(w_xy.data$y.str.name),]  #�HRMSSTD+1/RS�Ƨ�
w_z <-w_cluster_sort[1,1] #��X�̨�???��
w_clusterresult<- kmeans(cordoc,w_z)#K-means��w_z???
write.csv2(w_z,"w_suggest_group_number.csv") #��X
write.csv2(w_clusterresult$centers,"w_cluster_center.csv") #��X

clusplot(as.matrix(cordoc),w_clusterresult$cluster,color=T,shade=T,labels=2,lines=0,cex=1.5) #�e��

sort(w_clusterresult$cluster)





















