library("rjson")
library('stringi')
library('dplyr')

setwd('C:/Users/TEST/Documents/NTU courses/Network Analysis/project/crawler/bbcgoodfood_recipe/')
#json_data <- fromJSON(file='C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/cuisine json/american.json')

allrecipe=rep(list(list()),5)
dirr_list <- list.files()
dirr_list=dirr_list[-1]
a=NULL
for (i in 1:5){
  file_list <- list.files(paste(dirr_list[i],'/',sep=''))
  for (file in file_list){
    cat(paste('now reading',file,'...'))
    json_data <- fromJSON(file=paste('C:/Users/TEST/Documents/NTU courses/Network Analysis/project/crawler/bbcgoodfood_recipe/',dirr_list[i],'/',file,sep=''))
    a=c(a,json_data)
  }
  allrecipe[[i]]=a
}
names(allrecipe)=dirr_list


set.seed(1)
samrec=list()
for(i in 2:5){
  samrec=c(samrec,allrecipe[[i]][sample(1:length(allrecipe[[i]]),50)])
}


#save(samrec,allsaming,file='samrec.rda')

##all sample ingredient
allsaming=NULL
a=NULL
for (i in 1:length(samrec)){
  for (j in 1:length(samrec[[i]]$ingredient)){
    if(samrec[[i]]$ingredient[j]==''){
    }else{
      allsaming=c(allsaming,samrec[[i]]$ingredient[j])
    }
  }
  cat(paste('now cleaning recipe number',i))
}



saming=NULL ## sample ingredient
a=NULL
for (i in 1:length(samrec)){
  for (j in 1:length(samrec[[i]]$ingredient)){
    if(samrec[[i]]$ingredient[j]==''){
    }else{
      a=strsplit(samrec[[i]]$ingredient[j],'[0-9]+[a-z]*\ |tsp |tbsp ')[[1]]
      a=tail(a, n=1)
      a=strsplit(a,',')[[1]][1]
      a=strsplit(a,'\\(')[[1]][1]
      saming=c(saming,a)
    }
  }
  cat(paste('now cleaning recipe number',i))
}


#saming=unique(saming)
#tsp
#tbsp
#g
#ml
### NLP
## JAVA要手動更新到64BIT 他預設32所以直接下載有錯誤
library(NLP)
library(openNLP)

tagPOS <-  function(x, ...) {
  s <- as.String(x)
  word_token_annotator <- Maxent_Word_Token_Annotator()
  a2 <- Annotation(1L, "sentence", 1L, nchar(s))
  a2 <- annotate(s, word_token_annotator, a2)
  a3 <- annotate(s, Maxent_POS_Tag_Annotator(), a2)
  a3w <- a3[a3$type == "word"]
  POStags <- unlist(lapply(a3w$features, `[[`, "POS"))
  POStagged <- paste(sprintf("%s/%s", s[a3w], POStags), collapse = " ")
  list(POStagged = POStagged, POStags = POStags)
}

hehe=NULL
for(i in 1:length(samrec)){
  if(length(samrec[[i]]$method)>0&
     length(samrec[[i]]$ingredient)>0){
    if(length(strsplit(samrec[[i]]$method,'')[[1]])>5){
      acqTag1 <- tagPOS(samrec[[i]]$method)    
      acqTag2 <- tagPOS(samrec[[i]]$ingredient) 
      acqTagSplit1 = strsplit(acqTag1[[1]]," ")[[1]]
      acqTagSplit2 = strsplit(acqTag2[[1]]," ")[[1]]
      
      
      ha=intersect(acqTagSplit1[grepl("NN",acqTagSplit1 )],
                   acqTagSplit2[grepl("NN",acqTagSplit2 )])
      endlen=length(ha)-1
      bye=rep(T,length(ha))
      stocom=NULL
      if(length(ha)>1){
        for(k in 1:endlen){
          comnoun=paste(strsplit(ha,"/")[[k]][1],strsplit(ha,"/")[[k+1]][1])
          if(any(grepl(comnoun,samrec[[i]]$ingredient))){
            stocom=c(stocom,comnoun)
            bye[k]=F
            bye[k+1]=F
            #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][1],'/',sep=''),ha)]
            #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][2],'/',sep=''),ha)]
          }
        }
      }
      ha=ha[bye]
      ha=c(ha,stocom)
      hehe=c(hehe,ha)
      cat(paste('just finished ',i))
    }
  }
}
hehe=unique(hehe)
hehe=hehe[!grepl('tbsp|tsp',hehe)]

# purn=hehe[grepl('NNS',hehe)]
# sinn=setdiff(hehe,purn)

#purn=paste('kkk',sapply(strsplit(purn,'/'),head,n=1),sep='')
#sinn=paste('kkk',sapply(strsplit(sinn,'/'),head,n=1),sep='')
#substr(purn,1,nchar(purn)-3)
# purn=sapply(strsplit(purn,'/'),head,n=1)
# sinn=sapply(strsplit(sinn,'/'),head,n=1)
# library(dplyr)
# purn %>%
#   substr(nchar(purn)-2,nchar(purn))=='ies'
# 
# for(i in 1:length(purn)){
#   if(substr(purn[i],nchar(purn[i])-2,nchar(purn[i]))=='ies'){
#     for(j in sinn){
#       if(sum(grepl(substr(purn[i],0,nchar(purn[i])-3),j)>0)){
#         print(paste(purn[i],j))
#       }
#     }
#   }else if(substr(purn[i],nchar(purn[i])-1,nchar(purn[i]))=='es'){
#     for(j in sinn){
#       if(sum(grepl(substr(purn[i],0,nchar(purn[i])-2),j))>0){
#         print(paste(purn[i],j))
#       }
#     }
#   }else if(substr(purn[i],nchar(purn[i]),nchar(purn[i]))=='s'){
#     for(j in sinn){
#       if(sum(grepl(substr(purn[i],0,nchar(purn[i])-1),j))>0){
#         print(paste(purn[i],j))
#       }
#     }
#   }else{
#     print(purn[i])
#   }
# }
# 
# purn=purn[substr(purn,nchar(purn)-2,nchar(purn))=='ies']
# substr(purn,nchar(purn)-1,nchar(purn))=='es'
# substr(purn,nchar(purn),nchar(purn))=='s'
# 
# 
# for(i in sinn){
#   for(j in purn){
#     if(sum(grepl(j,i))>0){
#       print(paste(i,j))
#     }
#   }
# }

###########################################
load('C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/samrec.rda')
###########################################

#######################################
### alredy create ingredient list
inglist=read.csv('C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/ingredient list.csv',header=T,colClasses='character')
# numb=rep(list(list()),length(allsaming))
# names(numb)=allsaming
# for (i in 1:length(allsaming)){
#   k=NULL
#   for(j in 1:dim(inglist)[1]){
#     if(grepl(inglist[j,1],allsaming[i])){
#       k=c(k,inglist[j,1])
#     }
#    
#   }
#   numb[[i]]=k
#   cat(paste('now cleaning ingredient number',i,'/',length(allsaming)))
# }
# allsaming[sapply(numb,length)==0]
# table(sapply(numb,length))
creme=paste(strsplit(allsaming[76],' ')[[1]][3],strsplit(allsaming[76],' ')[[1]][4])
Gruyere=strsplit(allsaming[85],' ')[[1]][4]
inglist[,1][inglist[,1]=='creme']=creme
inglist[,1][inglist[,1]=='Gruyere']=Gruyere
orderquer=inglist[,1][order(nchar(inglist[,1]),decreasing =T)]

exam=samrec

samrec=exam
twomode=data.frame(matrix(0,ncol=length(samrec),nrow=length(unique(inglist[,2]))))
rownames(twomode)=unique(inglist[,2])
colnames(twomode)=names(samrec)
# for(i in 1:length(orderquer)){
#   for(j in 1:length(samrec)){
#     for(k in 1:length(samrec[[j]]$ingredient)){
#       if(grepl(orderquer[i],samrec[[j]]$ingredient[k])){
#         ha=which(inglist[,1]==orderquer[i])
#         ha=inglist[ha,2]
#         #twomode[rownames(twomode)==ha,j]=stri_extract_first_regex(samrec[[j]]$ingredient[k],'[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)*|[0-9]*½+[a-z]*( +tsp)*( +tbsp)*|[0-9]+[a-z]*( +tsp)*( +tbsp)*|[0-9]*( *handful)+|[0-9]*( *bunch)+|[0-9]*( *little)+|[0-9]*( *pack)+')
#         twomode[rownames(twomode)==ha,j]=stri_extract_first_regex(samrec[[j]]$ingredient[k],'[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)*|[0-9]*½*( *handful)+|[0-9]*½*( *bunch)+|[0-9]*½*( *little)+|[0-9]*½*( *pack)+|[0-9]*½+[a-z]*( +tsp)*( +tbsp)*|[0-9]+[a-z]*( +tsp)*( +tbsp)*')
#         samrec[[j]]$ingredient[k]='used'
#       }
#     }
#   }
#   cat('now pairing',i,'/',length(orderquer))
# }
j=111
k=2

for(j in 1:length(samrec)){
  for(k in 1:length(samrec[[j]]$ingredient)){
    a=NULL
    b=NULL
    for(i in 1:length(orderquer)){
      if(gregexpr(orderquer[i],samrec[[j]]$ingredient[k])[[1]][1]!=-1){
        a=c(a,i)
        b=c(b,gregexpr(orderquer[i],samrec[[j]]$ingredient[k])[[1]][1])
      }
    }
    if(!is.null(a)){
      i=a[which(b==min(b))][1]
      ha=which(inglist[,1]==orderquer[i])
      ha=inglist[ha,2]
      #twomode[rownames(twomode)==ha,j]=stri_extract_first_regex(samrec[[j]]$ingredient[k],'[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)*|[0-9]*½+[a-z]*( +tsp)*( +tbsp)*|[0-9]+[a-z]*( +tsp)*( +tbsp)*|[0-9]*( *handful)+|[0-9]*( *bunch)+|[0-9]*( *little)+|[0-9]*( *pack)+')
      if(twomode[rownames(twomode)==ha,j]==0){
        c <- stri_extract_first_regex(samrec[[j]]$ingredient[k],'[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)*|[0-9]*½*( *handful)+|[0-9]*½*( *bunch)+|[0-9]*½*( *little)+|[0-9]*½*( *pack)+|[0-9]*½+[a-z]*( +tsp)*( +tbsp)*|[0-9]+[a-z]*( +tsp)*( +tbsp)*')
        #c <- c[[1]][which.max(nchar(c[[1]]))]
        twomode[rownames(twomode)==ha,j]=c
        if(is.na(twomode[rownames(twomode)==ha,j])){
          twomode[rownames(twomode)==ha,j]='no'
        }
        samrec[[j]]$ingredient[k]='used'
      }else if(is.na(stri_extract_first_regex(samrec[[j]]$ingredient[k],'[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)*|[0-9]*½*( *handful)+|[0-9]*½*( *bunch)+|[0-9]*½*( *little)+|[0-9]*½*( *pack)+|[0-9]*½+[a-z]*( +tsp)*( +tbsp)*|[0-9]+[a-z]*( +tsp)*( +tbsp)*'))){
        twomode[rownames(twomode)==ha,j]=paste(twomode[rownames(twomode)==ha,j],'no')
        samrec[[j]]$ingredient[k]='used'
      }else{
        c <- stri_extract_first_regex(samrec[[j]]$ingredient[k],'[0-9]+( *x *)+[0-9]* *[a-z]*( +tsp)*( +tbsp)*|[0-9]*½*( *handful)+|[0-9]*½*( *bunch)+|[0-9]*½*( *little)+|[0-9]*½*( *pack)+|[0-9]*½+[a-z]*( +tsp)*( +tbsp)*|[0-9]+[a-z]*( +tsp)*( +tbsp)*')
        c <- c[[1]][which.max(nchar(c[[1]]))]
        twomode[rownames(twomode)==ha,j]=paste(twomode[rownames(twomode)==ha,j],c)
        samrec[[j]]$ingredient[k]='used'
      }
    }
  }
  cat('now pairing',j,'/',length(samrec))
}
####### quick load
load("C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/twomode.rda")
#save(twomode,file="C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/twomode.rda")

###### all quantities
x <- twomode %>% 
  sapply(unique) %>% 
  unlist %>% 
  unique %>% 
  sort
#######
## tbsp 15
## tbp 5
## 少 handful 100
## 少 little 50
## 多 pack 400
## 多 bunch 250
## 20cm(fruitcake)
## 

convtomat=function(x){
  y=rep(0,length(x))
  x=as.character(x)
  for( i in 1:length(x)){
    if(x[i]==0){
      y[i]=0
    }
    if(x[i]=='no'){
      y[i]=0.5
    }
    if(x[i]=='no no'){
      y[i]=0.5
    }
    if(grepl('[0-9]+( *x *)+[0-9]* *[a-z]*',x[i])){
      y[i] <- y[i]+x[i] %>%
        stri_extract_first_regex('[0-9]+( *x *)+[0-9]* *[a-z]*') %>%
        strsplit(split=' *x *') %>%
        unlist %>%
        gsub(pattern='g',repla='') %>%
        as.numeric  %>% 
        na.omit %>%
        prod
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]+( *x *)+[0-9]* *[a-z]*',replacement='')
    }
    if(grepl('[0-9]*½*( *handful)+',x[i])){
      a <- x[i] %>%
        stri_extract_first_regex('[0-9]*½*( *handful)+') %>%
        stri_extract_first_regex('[0-9]*½*') 
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>% 
          unlist %>% 
          as.numeric  %>% 
          na.omit %>%  
          sum
      }
      if(a!=0){
        y[i]=y[i]+a*100
      }else{
        y[i]=y[i]+100
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*( *handful)+',replacement='')
    }
    if(grepl('[0-9]*½*( *bunch)+',x[i])){
      a <- x[i] %>%
        stri_extract_first_regex('[0-9]*½*( *bunch)+') %>%
        stri_extract_first_regex('[0-9]*½*')  
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>%
          unlist %>%
          as.numeric  %>%
          na.omit %>% 
          sum
      }
      if(a!=0){
        y[i]=y[i]+a*250
      }else{
        y[i]=y[i]+250
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*( *bunch)+',replacement='')
    }
    if(grepl('[0-9]*½*( *little)+',x[i])){
      a <- x[i] %>%
        stri_extract_first_regex('[0-9]*½*( *little)+') %>%
        stri_extract_first_regex('[0-9]*½*') 
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>% 
          unlist %>% 
          as.numeric  %>% 
          na.omit %>%     
          sum
      }
      if(a!=0){
        y[i]=y[i]+a*50
      }else{
        y[i]=y[i]+50
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*( *little)+',replacement='')
    }
    if(grepl('[0-9]*½*( *pack)+',x[i])){
      a <- x[i] %>%
        stri_extract_first_regex('[0-9]*½*( *pack)+') %>%
        stri_extract_first_regex('[0-9]*½*')
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>%
          unlist %>%
          as.numeric %>% 
          na.omit %>%    
          sum
        
      }
      if(a!=0){
        y[i]=y[i]+a*400
      }else{
        y[i]=y[i]+400
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*( *pack)+',replacement='')
    }
    if(grepl('[0-9]*½*( +tbsp)',x[i])){
      a <- x[i] %>%
        stri_extract_first_regex('[0-9]*½*( +tbsp)') %>%
        stri_extract_first_regex('[0-9]*½*') 
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>%
          unlist %>% 
          as.numeric  %>% 
          na.omit %>%   
          sum
        
      }
      if(a>0){
        y[i]=y[i]+a*15
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*( +tbsp)',replacement='')
    }
    if(grepl('[0-9]*½*[a-z]*( +tsp)',x[i])){
      a <- x[i] %>%
        stri_extract_all_regex('[0-9]*½*[a-z]*( +tsp)') %>%
        unlist %>%
        stri_extract_all_regex('[0-9]*½*') %>%
        unlist
      if(any(grepl('½',a[[1]]))){
        a <- a %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a %>%
          unlist %>%
          as.numeric  %>%  
          na.omit %>%   
          sum
      }
      if(a>0){
        y[i]=y[i]+a*5
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*[a-z]*( +tsp)',replacement='')
    }
    if(grepl('[0-9]*½*(kg)',x[i])){
      a <- x[i] %>%
        stri_extract_all_regex('[0-9]*½*(kg)') %>%
        unlist %>%
        stri_extract_all_regex('[0-9]*½*') %>%
        unlist
      if(any(grepl('½',a[[1]]))){
        a <- a %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a %>% 
          unlist %>% 
          as.numeric  %>%
          na.omit %>% 
          sum
        
      }
      if(a>0){
        y[i]=y[i]+a*1000
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*(kg)',replacement='')
    }
    if(grepl('[0-9]+½*(l)',x[i])){
      a <- x[i] %>%
        stri_extract_all_regex('[0-9]+½*(l)') %>%
        stri_extract_all_regex('[0-9]+½*') 
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>% 
          unlist %>% 
          as.numeric  %>%
          na.omit %>% 
          sum
        
      }
      if(a>0){
        y[i]=y[i]+a*1000
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]+½*(l)',replacement='')
    }
    if(grepl('[0-9]*½*(cl)',x[i])){
      a <- x[i] %>%
        stri_extract_all_regex('[0-9]*½*(cl)') %>%
        stri_extract_all_regex('[0-9]*½*') 
      if(any(grepl('½',a[[1]]))){
        a <- a[[1]] %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a[[1]] %>% 
          unlist %>% 
          as.numeric  %>%
          na.omit %>% 
          sum
        
      }
      if(a>0){
        y[i]=y[i]+a*10
      }else{
        y[i]=y[i]
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*(cl)',replacement='')
    }
    if(grepl('[0-9]*g|[0-9]*ml',x[i])){
      a <- x[i] %>%
        stri_extract_all_regex('[0-9]*g|[0-9]*½*ml') %>%
        stri_extract_all_regex('[0-9]*') %>%
        unlist  %>% as.numeric %>% 
        na.omit %>% sum
      if(a>0){
        y[i]=y[i]+a
      }else{
        y[i]=y[i]
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*g|[0-9]*ml',replacement='')
    }
    ## manually clean
    ## suger
    if(grepl('800',x[i])){
      y[i]=y[i]+800
      x[i] <- x[i] %>%
        gsub(pattern='800',replacement='')
    }
    ## cake
    if(grepl('20cm',x[i])){
      y[i]=y[i]+ 500
      x[i] <- x[i] %>%
        gsub(pattern='20cm',replacement='')
    }
    ## repeat
    if(grepl('20',x[i])){
      y[i]=y[i]
      x[i] <- x[i] %>%
        gsub(pattern='20',replacement='')
    }
    if(grepl('[0-9]*½*',x[i])){
      a <- x[i] %>%
        stri_extract_all_regex('[0-9]*½*') %>%
        unlist %>%
        stri_extract_all_regex('[0-9]*½*') %>%
        unlist
      if(any(grepl('½',a[[1]]))){
        a <- a %>%
          strsplit(split='') %>%
          unlist %>%
          gsub(pattern='½',repla='0.5') %>%
          as.numeric  %>% 
          na.omit %>% 
          sum
      }else{
        a <- a %>% 
          unlist %>% 
          as.numeric  %>%
          na.omit %>% 
          sum
      }
      if(a>0){
        y[i]=y[i]+a*100
      }
      x[i] <- x[i] %>%
        gsub(pattern='[0-9]*½*',replacement='')
    }
  }
  return(y)
}


num_twomode <-
twomode %>% 
  apply(1,convtomat) %>%
  t
# save(num_twomode,file="C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/numtwomode.rda")
##############################################
load("C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/numtwomode.rda")
#######################################################
## per serving fordishes or
## 100g or ml for others(cake, cookies, jars, 750ml)
# a <- samrec %>% 
#   sapply(function(x){x$serving}) %>%
#   stri_extract_all_regex(pattern = '[0-9]+')  
# b=NULL
# for(i in 1:length(samrec)){
#   if(grepl("serv|Serv",samrec[[i]]$serving)){
#     b=c(b,i)
#   }
# }
# b <- setdiff(1:nrow(twomode),c(b,32,62,103,191))
# # for(i in b){
# #   print(samrec[[i]]$serving)
# # }
# a[[32]]= as.numeric(a[[32]])/100
# a[[191]]=as.numeric(a[[191]][1])*as.numeric(a[[191]][2])/100
# a[[62]]=as.numeric(a[[62]][1])+as.numeric(a[[62]][2])
# a[[103]]=c(a[[103]][3],a[[103]][4])
# a[is.na(a)]=1
# serving <- a %>%
#   sapply(as.numeric) %>%
#   sapply(mean)
# 
# for(i in b){
#   serving[i] <- 1/300*num_twomode[,i] %>% sum
# }

### adjust to 100
### then adjust to per serving
serving=NULL
for(i in 1:ncol(num_twomode)){
  serving[i]=sum(num_twomode[,i])/100
  num_twomode[,i] <- num_twomode[,i]/serving[i]
}

############ convertto more or less

coldif=num_twomode
hi=0
for(j in 1:ncol(coldif)){
  ci=coldif[,j]!=0
  hi=hi+sum(coldif[ci,j]-mean(coldif[ci,j])>0)
  bigger=which((coldif[ci,j]-mean(coldif[ci,j]))>0)
  smaller=which((coldif[ci,j]-mean(coldif[ci,j]))<=0)
  coldif[ci,j][bigger] <- 2
  coldif[ci,j][smaller] <- 1
}
colnames(coldif) <- names(samrec)
#####################
all_twomode=coldif
all_twomode[all_twomode==2]=1
all_ing_onemode <- all_twomode %*% t(all_twomode)
all_rec_onemode <- t(all_twomode) %*% all_twomode
colnames(all_ing_onemode) <- rownames(all_ing_onemode) <- rownames(coldif)
colnames(all_rec_onemode) <- rownames(all_rec_onemode) <- names(samrec)
#####

#####
more_twomode=coldif
more_twomode[more_twomode==1]=0
more_twomode[more_twomode==2]=1
more_ing_onemode <- more_twomode %*% t(more_twomode)
more_rec_onemode <- t(more_twomode) %*% more_twomode
colnames(more_ing_onemode) <- rownames(more_ing_onemode) <- rownames(coldif)
colnames(more_rec_onemode) <- rownames(more_rec_onemode) <- names(samrec)
#####
less_twomode=coldif
less_twomode[less_twomode==2]=0
less_ing_onemode <- less_twomode %*% t(less_twomode)
less_rec_onemode <- t(less_twomode) %*% less_twomode
colnames(less_ing_onemode) <- rownames(less_ing_onemode) <- rownames(coldif)
colnames(less_rec_onemode) <- rownames(less_rec_onemode) <- names(samrec)
#####
mole_ing_onemode=matrix(0,ncol=nrow(coldif),nrow=nrow(coldif))
for(i in 1:nrow(coldif)){
  for(j in 1:nrow(coldif)){
    for(k in 1:ncol(coldif)){
      if(coldif[i,k]!=0&coldif[j,k]!=0){
        if(coldif[i,k]<coldif[j,k]){
          mole_ing_onemode[i,j] <- mole_ing_onemode[i,j] + 1
        }
      }
    }
  }
}
colnames(mole_ing_onemode) <- rownames(mole_ing_onemode) <- rownames(coldif)

mole_rec_onemode=matrix(0,ncol=ncol(coldif),nrow=ncol(coldif))
for(i in 1:ncol(coldif)){
  for(j in 1:ncol(coldif)){
    for(k in 1:nrow(coldif)){
      if(coldif[k,i]!=0&coldif[k,j]!=0){
        if(coldif[k,i]<coldif[k,j]){
          mole_rec_onemode[i,j] <- mole_rec_onemode[i,j] + 1
        }
      }
    }
  }
}
colnames(mole_rec_onemode) <- rownames(mole_rec_onemode) <- names(samrec)




save(more_ing_onemode,more_rec_onemode,more_twomode,
     less_ing_onemode,less_rec_onemode,less_twomode,
     mole_ing_onemode,mole_rec_onemode,coldif,
     all_ing_onemode, all_rec_onemode, all_twomode,
     file='C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/mole_twomode.rda')
#################################
load(file='C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/mole_twomode.rda')
#################################
library(igraph)
library(sna)
##"Central Europe"   green
##"Northern Europe" blue
##"Southern Europe" light blue
##"Western Europe"  yellow
recipe_list=read.csv('C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/recipe_list.csv')
recipe_list=recipe_list[,-1]
##"dessert"   green  
##"dish"      blue
##"meal"      light blue
##"salad"     pink 
##"soup"      yellow

######################################################
### centrality color is area, size is 
g1=graph.adjacency(all_rec_onemode) 
g1=as.undirected(g1)
#pr<-page_rank(g1)$vector
V(g1)$color[1:50] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(g1)$color[51:100] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(g1)$color[101:150] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(g1)$color[151:200] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
#V(g1)$size <- diag(all_rec_onemode)
V(g1)$label <- rownames(all_rec_onemode)
tkplot(g1, layout=layout.kamada.kawai)

######################################################
### by cuisine
g2=graph.adjacency(all_rec_onemode)
g2=as.undirected(g2)
#V(g2)$size <- diag(all_rec_onemode)
##
V(g2)$color[as.numeric(recipe_list[,2])+2==3] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(g2)$color[as.numeric(recipe_list[,2])+2==4] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(g2)$color[as.numeric(recipe_list[,2])+2==5] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(g2)$color[as.numeric(recipe_list[,2])+2==6] =  rgb(red = 1, green = 0, blue = 1, alpha = .5)
V(g2)$color[as.numeric(recipe_list[,2])+2==7] = rgb(red = 1, green = 1, blue = 0, alpha = .5)

V(g2)$label <- rownames(all_rec_onemode)
tkplot(g2, layout=layout.kamada.kawai)
###
######################################################
### by cuisine    more_twomode[more_twomode==2]=1

rmrep=rep(F,200)
for(i in 1:200){
  if(match(rownames(all_rec_onemode)[i],rownames(all_rec_onemode))!=i){
    rmrep[i]=T
  }
}
for(i in 3:8){
herher=all_rec_onemode
herher[herher<i]=0
diag(herher)=0
g22=graph.adjacency(herher) 
g22=as.undirected(g22)
#V(g2)$size <- diag(all_rec_onemode)
##
V(g22)$color[as.numeric(recipe_list[,2])+2==3] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(g22)$color[as.numeric(recipe_list[,2])+2==4] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(g22)$color[as.numeric(recipe_list[,2])+2==5] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(g22)$color[as.numeric(recipe_list[,2])+2==6] =  rgb(red = 1, green = 0, blue = 1, alpha = .5)
V(g22)$color[as.numeric(recipe_list[,2])+2==7] = rgb(red = 1, green = 1, blue = 0, alpha = .5)

# V(g22)$color[1:50] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
# V(g22)$color[51:100] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
# V(g22)$color[101:150] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
# V(g22)$color[151:200] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs

V(g22)$label <- rownames(all_rec_onemode)
g22 = delete.vertices(g22, V(g22)[rmrep])
g22 = delete.vertices(g22, V(g22)[igraph::degree(g22)==0 ])

tkplot(g22, layout= layout.kamada.kawai)
}
###
######################################################
##main ingredient network
g3=graph.adjacency(more_ing_onemode) # PageRank Scores
pr<-page_rank(g3)$vector
# V(g3)$color[1:50] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
# V(g3)$color[51:100] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
# V(g3)$color[101:150] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
# V(g3)$color[151:200] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
#V(g2)$size <- pr*500
V(g3)$label <- rownames(all_ing_onemode)
V(g3)$color <- moreingcol
g3 = delete.vertices(g3, V(g3)[igraph::degree(g3)==0 ])
tkplot(g3)

######################################################
### minor ingredient network
g4=graph.adjacency(less_ing_onemode) # PageRank Scores
pr<-page_rank(g4)$vector
# V(g3)$color[1:50] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
# V(g3)$color[51:100] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
# V(g3)$color[101:150] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
# V(g3)$color[151:200] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
#V(g2)$size <- pr*500
V(g4)$label <- rownames(less_ing_onemode)
g4 = delete.vertices(g4, V(g4)[igraph::degree(g4)==0 ])
tkplot(g4)

######################################################
########## group by concor (louvain algorithm, get.backbone)
library(concoR)
g5=graph.adjacency(all_rec_onemode)
g5=as.undirected(g5)
list1<-list(all_rec_onemode)
blks <- concor_hca(list1, p = 2)
V(g5)$color = blks$block
tkplot(g5,layout= layout.kamada.kawai)
###
g6=graph.adjacency(all_rec_onemode)
g6=as.undirected(g6)
V(g6)$color=cluster_fast_greedy(g6)$membership
V(g6)$label <- rownames(all_rec_onemode)
tkplot(g6)

##############################
### first 5 centrality each courses
hi=list()
hey=NULL
for(i in 1:5){
  a=all_twomode[,as.numeric(recipe_list[,2])==i] %*% t(all_twomode[,as.numeric(recipe_list[,2])==i])
  # g=graph.adjacency(a)
  # pr<-page_rank(g)$vector
  pr=degree(a)
  hi[[i]]=order(pr,decreasing = T)[1:5]
  hey=c(hey,order(pr,decreasing = T)[1:5])
}
rownames(all_twomode)

hehe=matrix(0,ncol=5,nrow=length(unique(hey)))
for(i in 1:5){
  for(j in 1:length(unique(hey))){
    if(unique(hey)[j] %in% hi[[i]]){
      hehe[j,i]=1
    }
  }
}
haha <- graph.incidence(hehe)
V(haha)$color[1:15] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[16] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[17] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[18] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[19] =  rgb(red = 1, green = 0, blue = 1, alpha = .5)
V(haha)$color[20] = rgb(red = 1, green = 1, blue = 0, alpha = .5)
V(haha)$label = c(rownames(all_twomode)[unique(hey)],c("dessert",
                                "dish",
                                "meal",
                                "salad",
                                "soup"))

V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[16:20]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha)

##############################
### first 5 centrality each courses
########### mole_ing_onemode in courses
hiin=list()
hiout=list()
hiboth=list()
for(l in 1:5){
  a=coldif[,as.numeric(recipe_list[,2])==l]
  b=matrix(0,ncol=nrow(a),nrow=nrow(a))
  for(i in 1:nrow(a)){
    for(j in 1:nrow(a)){
      for(k in 1:ncol(a)){
        if(a[i,k]!=0&a[j,k]!=0){
          if(a[i,k]<a[j,k]){
            b[i,j] <-b[i,j] + 1
          }
        }
      }
    }
    cat(i/nrow(a),'\n')
  }
  cat(l,'is finished')
  hiin[[l]]=order(sna::degree(b, cmode = "indegree"),decreasing = T)[1:5]
  hiout[[l]]=order(sna::degree(b, cmode = "outdegree"),decreasing = T)[1:5]
  pr= b %>% graph.adjacency %>% page_rank
  hiboth[[l]]= order(pr$vector,decreasing = T)[1:5]
}


unhiboth=hiboth %>% unlist %>% unique
heheboth=matrix(0,ncol=5,nrow=hiboth %>% unlist %>% unique %>% length)
for(i in 1:5){
  for(j in 1:nrow(heheboth)){
    if(unhiboth[j] %in% hiboth[[i]]){
      heheboth[j,i]=1
    }
  }
}
haha <- graph.incidence(heheboth)
V(haha)$color[1:nrow(heheboth)] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[nrow(heheboth)+1] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[nrow(heheboth)+2] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(heheboth)+3] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(heheboth)+4] =  rgb(red = 1, green = 0, blue = 1, alpha = .5)
V(haha)$color[nrow(heheboth)+5] = rgb(red = 1, green = 1, blue = 0, alpha = .5)
V(haha)$label = c(rownames(coldif)[unhiboth],c("dessert",
                                             "dish",
                                             "meal",
                                             "salad",
                                             "soup"))

V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[nrow(heheboth)+1:5]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.fruchterman.reingold)


unhiin=hiin %>% unlist %>% unique
hehein=matrix(0,ncol=5,nrow=hiin %>% unlist %>% unique %>% length)
for(i in 1:5){
  for(j in 1:nrow(hehein)){
    if(unhiin[j] %in% hiin[[i]]){
      hehein[j,i]=1
    }
  }
}
haha <- graph.incidence(hehein)
V(haha)$color[1:nrow(hehein)] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[nrow(hehein)+1] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[nrow(hehein)+2] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(hehein)+3] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(hehein)+4] =  rgb(red = 1, green = 0, blue = 1, alpha = .5)
V(haha)$color[nrow(hehein)+5] = rgb(red = 1, green = 1, blue = 0, alpha = .5)
V(haha)$label = c(rownames(coldif)[unhiin],c("dessert",
                                "dish",
                                "meal",
                                "salad",
                                "soup"))

V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[nrow(hehein)+1:5]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.fruchterman.reingold)



unhiout=hiout %>% unlist %>% unique
heheout=matrix(0,ncol=5,nrow=hiout %>% unlist %>% unique %>% length)
for(i in 1:5){
  for(j in 1:nrow(heheout)){
    if(unhiout[j] %in% hiout[[i]]){
      heheout[j,i]=1
    }
  }
}

haha <- graph.incidence(heheout)
V(haha)$color[1:nrow(heheout)] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[nrow(heheout)+1] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[nrow(heheout)+2] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(heheout)+3] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(heheout)+4] =  rgb(red = 1, green = 0, blue = 1, alpha = .5)
V(haha)$color[nrow(heheout)+5] = rgb(red = 1, green = 1, blue = 0, alpha = .5)
V(haha)$label = c(rownames(coldif)[unhiout],c("dessert",
                                "dish",
                                "meal",
                                "salad",
                                "soup"))

V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[nrow(heheout)+1:5]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.davidson.harel)


##############
### first 5 centrality each area
hi=list()
hey=NULL
for(i in 1:4){
  a=all_twomode[,((i*50)-49):(i*50)] %*% t(all_twomode[,((i*50)-49):(i*50)])
#   g=graph.adjacency(a)
#   pr<-page_rank(g)$vector
  pr=degree(a)
  hi[[i]]=order(pr,decreasing = T)[1:5]
  hey=c(hey,order(pr,decreasing = T)[1:5])
}
rownames(all_twomode)

hehe=matrix(0,ncol=4,nrow=length(unique(hey)))
for(i in 1:4){
  for(j in 1:length(unique(hey))){
    if(unique(hey)[j] %in% hi[[i]]){
      hehe[j,i]=1
    }
  }
}
haha <- graph.incidence(hehe)
V(haha)$color[1:12] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[13] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[14] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[15] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[16] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$label = c(rownames(all_twomode)[unique(hey)],c("Central Europe",
                                "Northern Europe",
                                "Southern Europe" ,
                                "Western Europe"))
V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[13:16]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.fruchterman.reingold)

##############
### first 5 centrality each area
###
###########mole_ing_onemode in area
hiin=list()
hiout=list()
hiboth=list()
for(l in 1:4){
  a=coldif[,((l*50)-49):(l*50)]
  b=matrix(0,ncol=nrow(a),nrow=nrow(a))
  for(i in 1:nrow(a)){
    for(j in 1:nrow(a)){
      for(k in 1:ncol(a)){
        if(a[i,k]!=0&a[j,k]!=0){
          if(a[i,k]<a[j,k]){
           b[i,j] <-b[i,j] + 1
          }
        }
      }
    }
    cat(i/nrow(a),'\n')
  }
  cat(l,'is finished')
  hiin[[l]]=order(sna::degree(b, cmode = "indegree"),decreasing = T)[1:5]
  hiout[[l]]=order(sna::degree(b, cmode = "outdegree"),decreasing = T)[1:5]
  pr= b %>% graph.adjacency %>% page_rank
  hiboth[[l]]= order(pr$vector,decreasing = T)[1:5]
}



unhiboth=hiboth %>% unlist %>% unique
heheboth=matrix(0,ncol=4,nrow=hiboth %>% unlist %>% unique %>% length)
for(i in 1:4){
  for(j in 1:nrow(heheboth)){
    if(unhiboth[j] %in% hiboth[[i]]){
      heheboth[j,i]=1
    }
  }
}
haha <- graph.incidence(heheboth)
V(haha)$color[1:nrow(heheboth)] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[nrow(heheboth)+1] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[nrow(heheboth)+2] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(heheboth)+3] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[nrow(heheboth)+4] =  rgb(red = 1, green = 1, blue = 0, alpha = .5)
V(haha)$label = c(rownames(coldif)[unhiboth],c("Central Europe",
                                               "Northern Europe",
                                               "Southern Europe" ,
                                               "Western Europe"))


V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[nrow(heheboth)+1:4]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.fruchterman.reingold)



unhiin=hiin %>% unlist %>% unique
hehein=matrix(0,ncol=4,nrow=hiin %>% unlist %>% unique %>% length)
for(i in 1:4){
  for(j in 1:nrow(hehein)){
    if(unhiin[j] %in% hiin[[i]]){
      hehein[j,i]=1
    }
  }
}
haha <- graph.incidence(hehein)
V(haha)$color[1:13] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[14] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[15] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[16] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[17] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$label = c(rownames(coldif)[unhiin],c("Central Europe",
                                "Northern Europe",
                                "Southern Europe" ,
                                "Western Europe"))
V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[14:17]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.fruchterman.reingold)



unhiout=hiout %>% unlist %>% unique
heheout=matrix(0,ncol=4,nrow=hiout %>% unlist %>% unique %>% length)
for(i in 1:4){
  for(j in 1:nrow(heheout)){
    if(unhiout[j] %in% hiout[[i]]){
      heheout[j,i]=1
    }
  }
}

haha <- graph.incidence(heheout)
V(haha)$color[1:11] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(haha)$color[12] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$color[13] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(haha)$color[14] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(haha)$color[15] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
V(haha)$label = c(rownames(coldif)[unhiout],c("Central Europe",
                                "Northern Europe",
                                "Southern Europe" ,
                                "Western Europe"))
V(haha)$label.color = rgb(0,0,.2,.5)
V(haha)$label.cex = 2
V(haha)$size = 20
V(haha)$size[12:15]=30
V(haha)$frame.color = V(haha)$color
E(haha)$color = "black"
tkplot(haha, layout=layout.fruchterman.reingold)


######################################
### ingredient plot
a=NULL
for (i in 1:nrow(coldif)){
  a[i]=sum(coldif[i,]=='1')
}
b=NULL
for (i in 1:nrow(coldif)){
  b[i]=sum(coldif[i,]=='2')
}

##
ha=mole_ing_onemode
ha=ha[order(b/(a+b)),]
ha=ha[,order(b/(a+b))]
edco=NULL
edwi=NULL
for(i in 1:nrow(mole_ing_onemode)){
  for(j in 1:nrow(mole_ing_onemode)){
    if(ha[i,j]>=ha[j,i]&ha[i,j]>0){
      edwi=c(edwi,ha[i,j]+ha[j,i])
      edco=c(edco,ha[i,j]/(ha[i,j]+ha[j,i]))
      ha[i,j]=1
      ha[j,i]=0
    }
  }
}


g33=graph.adjacency(ha)


V(g33)$color = rgb(red = 1, green = 0, blue = (b/(a+b))[order(b/(a+b))], alpha = .5) # clubs
V(g33)$size <- (5*diag(all_ing_onemode) %>%sqrt)[order(b/(a+b))]
V(g33)$label <- rownames(all_ing_onemode)[order(b/(a+b))]
V(g33)$label.cex <- 1.8
V(g33)$label.color <- 'darkgreen'

E(g33)$weight <- edwi
E(g33)$color <-  gray(1.4-1.2*edco,alpha = 0.5)
g33= delete.vertices(g33, V(g33)[(diag(all_ing_onemode)<15)[order(b/(a+b))]])
tkplot(g33 ,edge.width= E(g33)$weight ,edge.arrow.size=2,layout=layout.grid)



## edge color : 
# between nodes pure direct

## edge size : 
# between nodes total times both more and less

## vertex color : 
# number of 2/(1+2)
# more pink more pure indegree
# more red more pure outdegree

## vertex size : appear times
# use in how many recipe

##########################
heu=all_ing_onemode
heu[upper.tri(heu)]=0
ingwei= as.vector(heu)
ingwei=ingwei[-seq(from=1,by=1+nrow(all_ing_onemode),len=nrow(all_ing_onemode))]
ingwei=ingwei[ingwei!=0]
heu[heu!=0]=1
diag(heu)=0
g7=graph.adjacency(heu)


V(g7)$color = rgb(red = 1, green = 0, blue = 0, alpha = .5) # clubs
V(g7)$size <- 5*diag(all_ing_onemode) %>%sqrt
V(g7)$label <- rownames(all_ing_onemode)
V(g7)$label.cex  <- 1.5

E(g7)$weight <-ingwei
g7= delete.vertices(g7, V(g7)[(diag(all_ing_onemode)<15)[order(b/(a+b))]])
g7=as.undirected(g7)
tkplot(g7 ,edge.width=E(g7)$weight ,layout=layout.grid)

## nodes size 
# used times
##edge size
# co-recipe times

##power law
degree(all_ing_onemode)%>% as.numeric %>% density %>% plot

sortedVertexIDs[1:20]

2187
repeatrec=names(table(rownames(all_rec_onemode)))[table(rownames(all_rec_onemode))>1]

g2=cluster_walktrap(g1)

g2_dend <- as.dendrogram(g2, use.modularity=TRUE)
plot(g2_dend)
g3=cluster_edge_betweenness (g1)
tkplot(g3)


## morisita's overlap index  0~1 豐富的字給大權重
## 分錯的少也同時被用到權重低
# 兩個來源豐富度較高的越像 分數越高



library(igraph)
### coevent twomode
i96 <- graph.incidence(coldif)
V(i96)$color[1:238] = rgb(red = 1, green = 0, blue = 0, alpha = .5) # students
V(i96)$color[239:288] = rgb(red = 0, green = 1, blue = 0, alpha = .5) # clubs
V(i96)$color[289:338] = rgb(red = 0, green = 0, blue = 1, alpha = .5) # clubs
V(i96)$color[339:388] = rgb(red = 0, green = 1, blue = 1, alpha = .5) # clubs
V(i96)$color[389:438] = rgb(red = 1, green = 1, blue = 0, alpha = .5) # clubs
V(i96)$label = c(rownames(more_twomode),colnames(twomode))
V(i96)$label.color = rgb(0,0,.2,.5)
V(i96)$label.cex = .4
V(i96)$size = 6
V(i96)$frame.color = V(i96)$color
E(i96)$color = "black"
tkplot(i96, layout=layout.fruchterman.reingold)
### coevent twomode

g96=as.matrix(trytry)
# co-event matrices
g96e = g96 %*% t(g96)
i96e = graph.adjacency(g96e, mode = "undirected")
E(i96e)$weight <- count.multiple(i96e)

i96e <- simplify(i96e)
V(i96e)$label = V(i96e)$name
V(i96e)$label.color = "blue"
V(i96e)$label.cex = .8
V(i96e)$size = 12
V(i96e)$color ="grey"
V(i96e)$frame.color = V(i96e)$color

# Set edge attributes
egalpha = log(E(i96e)$weight)
E(i96e)$color = "black"
E(i96e)$width = egalpha

i96e_layout <- layout.fruchterman.reingold(i96e)
tkplot(i96e, main = "Co-event Network", layout=i96e_layout) 

#write(sapply(strsplit(hehe,'/'),head,n=1),file='inglist2.csv',sep='\n')


### 200 recipe comment
# allsamcom=NULL ##all sample ingredient
# a=NULL
# for (i in 1:length(samrec)){
#   for (j in 1:length(samrec[[i]]$comment)){
#     if(length(samrec[[i]]$comment)==0){
#     }else{
#       allsamcom=c(allsamcom,samrec[[i]]$comment)
#     }
#   }
#   cat(paste('now cleaning recipe number',i))
# }
###

# 
# inglist=read.csv('C:/Users/TEST/Documents/NTU courses/?����??Ƥ��R?P?Ҧ?/Project/crawler/inglist.csv')
# inglist=as.vector(inglist[,1])
# inglist=tolower(inglist)
# unique(inglist)
# recing=data.frame(matrix(0,nrow=length(samrec),ncol=length(inglist)))
# for(i in length(samrec)){
#   for(j in length(inglist)){
#     for(k in samrec[[i]]$ingredient){
#       if(grepl(inglist[j],k)){
#         recing[i,j]=
#       }
#         recing[i,j]=
#     }
#   }
# }
# 
# samrec[[i]]$ingredient[1][grepl("[-]?[0-9]+[.]?[0-9]*|[-]?[0-9]+[L]?|[-]?[0-9]+[.]?[0-9]*[eE][0-9]+",samrec[[i]]$ingredient[1])]
# 
# p=NULL
# for(i in inglist){
#   if(sum(grepl(i,unsaming1))==1){
#     p=p+1
#   }
# }
# 
# 
# strsplit(inglist,'')


# 
# ##1 gram
# stwor=read.table('C:/Users/TEST/Documents/NTU courses/Network Analysis/Project/crawler/claening/stopwords.txt',colClasses='character')
# stwor=as.vector(stwor[,1])
# 
# saming1=NULL
# for (i in 1:length(saming)){
#   a=strsplit(saming[i],' ')[[1]]
#   saming1=c(saming1,a)
#   cat(paste('now spliting recipe number',i))
# }
# 
# 
# ## remove number
# saming1 <- saming1[!grepl("[-]?[0-9]+[.]?[0-9]*|[-]?[0-9]+[L]?|[-]?[0-9]+[.]?[0-9]*[eE][0-9]+",saming1)]
# ## remove stop word
# isrep=NULL
# for (i in 1:length(saming1)){
#   a=0
#   for (j in 1:length(stwor)){
#     if(saming1[i]==stwor[j]){
#       a=1
#     }else{
#     }
#   }
#   if(a==1){
#     isrep=c(isrep,F)
#   }else{
#     isrep=c(isrep,T)
#   }
#   cat(i)
# }
# saming1=saming1[isrep]
# ##remove ( or )
# saming1=saming1[!grepl("\\(|\\)",saming1)]
# 
# ## remove double
# unsaming1=unique(saming1)
# 
# 
# ## remove once
# hi1=NULL
# for(i in unsaming1){
#   hi1=c(hi1,sum(saming1==i)==1)
# }
# unsaming1=unsaming1[!hi1]
# 
# 
# 
# 
# #write(unsaming1,file='single.txt',sep='\n')
# #sort(table(saming1),decreasing=T)[1:100]
# #length(table(saming1)[table(saming1)>100])
# 
# ##2 gram
# b=NULL
# saming2=NULL
# for(i in 1:length(saming)){
#   b=strsplit(saming[i],' ')[[1]]
#   for(j in 2:(length(b))){
#     if (length(b)==1){
#       saming2=c(saming2,b)
#     }else{
#       saming2=c(saming2,paste(b[j-1],' ',b[j]))
#     }
#   }
#   cat(paste('now spliting recipe number',i))
# }
# 
# ## remove number
# saming2 <- saming2[!grepl("[-]?[0-9]+[.]?[0-9]*|[-]?[0-9]+[L]?|[-]?[0-9]+[.]?[0-9]*[eE][0-9]+",saming2)]
# 
# ## remove  stop word
# isrep2=NULL
# for (i in 1:length(saming2)){
#   a=0
#   for (j in stwor){
#     for (k in strsplit(saming2[i],' ')[[1]]){
#       if(k==j){
#         a=1
#       }
#     }
#   }
#   if(a==1){
#     isrep2=c(isrep2,F)
#   }else{
#     isrep2=c(isrep2,T)
#   }
#   cat( paste(' ',i,' ' ))
# }
# saming2=saming2[isrep2]
# ##remove ( or )
# saming2=saming2[!grepl("\\(|\\)",saming2)]
# 
# ##remove double
# unsaming2=unique(saming2)
# 
# 
# ## remove once
# hi2=NULL
# for(i in unsaming2){
#   hi2=c(hi2,sum(saming2==i)==1)
# }
# unsaming2=unsaming2[!hi2]
# ## remove spaces to one space
# unsaming2=gsub('   ',' ',unsaming2)
# 
# ## remove double has one
# unsaming1=unique(c(unsaming1,unsaming2[sapply(strsplit(unsaming2,' '),length)==1]))
# unsaming2=unsaming2[!sapply(strsplit(unsaming2,' '),length)==1]
# ## remove space
# unsaming1=sub('  ','',unsaming1)
# 
# 
# ## remove appear only when pair
# hey=rep(F,length(unsaming1))
# for(i in 1:length(unsaming1)){
#   if(length(unique(grep(unsaming1[i],saming2,value=T)))==1){
#     hey[i]=TRUE
#   }
# }
# unsaming1=unsaming1[!hey]
# 
# 
# 
# 
# #write(unsaming2,file='double.txt',sep='\n')
# #sort(table(saming2),decreasing=T)[1:100]
# #length(table(saming2)[table(saming2)>100])
# 
# ## remove double has one
# unsaming1=unique(c(unsaming1,unsaming2[sapply(strsplit(unsaming2,' '),length)==1]))
# unsaming2=unsaming2[!sapply(strsplit(unsaming2,' '),length)==1]
# 
# 
# ################
# ##ingredient data
# 
# ing_list=c(names(sort(table(saming1),decreasing=T)[1:100]),names(sort(table(saming2),decreasing=T)[1:100]))
# inglist=unique(ing_list)
# 
# hi4=data.frame(matrix(0,ncol=3,nrow=length(unsaming1)))
# for(i in 1:length(unsaming1)){
#   for (j in 1:length(unsaming2)){
#     a=strsplit(unsaming2[j],' ')[[1]]
#     if(length(a)==2){
#       if(a[1]==unsaming1[i]){
#         hi4[i,2]=hi4[i,2]+1
#       }else if(a[2]==unsaming1[i]){
#         hi4[i,3]=hi4[i,3]+1
#       }
#     }
#   }
#   hi4[i,1]= sum(grepl(unsaming1[i],saming1))
#   cat(paste('now spliting recipe number',i))
# }
# colnames(hi4)=c('all','atfirst','atsecond')
# 
# #hi4[,1]==unsaming1
# 
# 
# ### collaboration
# fro=rep(list(NULL),length(unsaming1))
# names(fro)=unsaming1
# aft=rep(list(NULL),length(unsaming1))
# names(aft)=unsaming1
# a=sapply(saming2,strsplit,' ')
# for( i in 1:length(unsaming1)){
#   for( j in a){
#     if(grepl(unsaming1[i],j[1])){
#       fro[names(fro)==unsaming1[i]][[1]]=c(fro[names(fro)==unsaming1[i]][[1]],j[4])
#     }else if(grepl(unsaming1[i],tail(j,1))){
#       aft[names(aft)==unsaming1[i]][[1]]=c(aft[names(aft)==unsaming1[i]][[1]],j[1])
#     }
#   }
#   cat(paste('now spliting recipe number',i))
# }
# ##
# 
# 
# 
# ### remove adj
# adj=unsaming1[sapply(lapply(fro,unique),length)>4]
# #adj=adj[-c(18,32)]
# hew=rep(F,length(unsaming2))
# for (j in 1:length(unsaming2)){
#   hi=strsplit(unsaming2,' ')
#   for(i in adj){
#     if(sum(hi[[j]][1]==i)>0){
#       hew[j]=T
#     }
#   }
# }
# unsaming2[!hew]
# 
# unsaming1=sub(' ','',unsaming1)
# unsaming1=setdiff(unsaming1,adj)
# 
# 
# 
# 
# ##remove match more
# unsaming1[
#   sapply(lapply(fro[lapply(fro,length)>0],table),max,decreasing=T)/
#     sapply(lapply(fro[lapply(fro,length)>0],table),sum,decreasing=T)
#   <0.1]
# 
# 
# 
# 
# #################################
# 
# hee1=NULL
# for(i in sapply(strsplit(saming,' '),tail,n=1)){
#   hee1=c(hee1,i)
# }
# 
# 
# hee2=NULL
# for(i in sapply(strsplit(saming,' '),tail,n=2)){
#   hee2=c(hee2,paste(i[1],i[2]))
# }
# hee2[hee2 %>% table %>% sort(,decrea=T)>1]
# 
# 
# 
# for(k in unique(hee)){
#   if(sum(k==unsaming1[sapply(lapply(fro,unique),length)>2])>0){
#     print(k)
#   }
# }
# 
# 
# names(
#   table(saming1)[sort(table(saming1),dec=T)>1]
# )
# 
# 
# 
# sapply(lapply(aft,unique),length)>2
# 
# unsaming1[sapply(lapply(fro,unique),length)>1&
#         sapply(lapply(aft,unique),length)==0]
# 
# unsaming1[sapply(fro,length)+
#         sapply(aft,length)==0]
# 
# 
# unsaming1[
# sapply(lapply(fro[lapply(fro,length)>0],table),max,decreasing=T)/
#   sapply(lapply(aft[lapply(aft,length)>0],table),sum,decreasing=T)
# ==1]
# 
# 
# unsaming1[
#   sapply(lapply(aft,table),max,decreasing=T)/
#   sapply(lapply(aft,table),sum,decreasing=T)
#   ==1]
# 
# 
# unsaming1[sapply(aft,length)>3 & sapply(lapply(aft,unique),length)<3]
# # 
# # ("openNLPmodels.en")
# # library("openNLP") 
# # acqTag <- tagPOS(saming)
# 
# rownames(hi4) = unsaming1
# 
# write(c(unsaming1,unsaming2),file='inglist2.csv',sep='\n')

# 
# ing_list=ing_list[-c(5,6,12,13,14,16,18,19,20,21,24,25,26,27,28,33,34,35,36,37,39,41,42,
#                      45,46,48,49,50,52,53,56,57,58,59,60,64,65,67,71,72,73,79,82,83,84,86,87,88,89,90,91,93,
#                      94,98,99,199,111,113,118,119,122,125,127,129,131,133,137,139,140,143,144,145,
#                      146,148,153,,156,)]
# ing_data=data.frame(matrix(0,nrow=length(json_data),ncol=length(ing_list)))
# colnames(ing_data)=ing_list
# ing_list[c(94,99)]=""
# json_data[[28]]$ingredient[7]="284ml carton double cream"
# for(i in 1:length(json_data)){
#   for (j in 1:length(ing_list)){
#     for(k in 1:length(json_data[[i]]$ingredient)){
#       if(grepl(ing_list[j],json_data[[i]]$ingredient[k])){
#         if(grepl("[0-9a-zA-Z/]*\ *[0-9]+[a-zA-Z]",json_data[[i]]$ingredient[k])){
#           if(length(grep("[0-9a-zA-Z/]*\ *[0-9]+[a-zA-Z]+",strsplit(json_data[[i]]$ingredient[k], " ")[[1]],value=T))>1){
#             ing_data[i,j]='double'
#           }else{
#             ing_data[i,j]=grep("[0-9a-zA-Z/]*\ *[0-9]+[a-zA-Z]+",strsplit(json_data[[i]]$ingredient[k], " ")[[1]],value=T)
#           }
#         }else{
#           ing_data[i,j]="wrong"
#         }
#         if(grepl("[0-9a-zA-Z/]*\ *[0-9]\ [a-zA-Z]+",json_data[[i]]$ingredient[k])){
#           if(length(regmatches(json_data[[i]]$ingredient[k],gregexpr("[0-9a-zA-Z/]*\ *[0-9]+\ [a-zA-Z]+",json_data[[i]]$ingredient[k])))>1){
#             ing_data[i,j]='double'
#           }else{
#             ing_data[i,j]= regmatches(json_data[[i]]$ingredient[k],gregexpr("[0-9a-zA-Z/]*\ *[0-9]+\ [a-zA-Z]+",json_data[[i]]$ingredient[k]))
#           }
#         }else if(ing_data[i,j]==0){
#           ing_data[i,j]="wrong"
#         }
#       }
#     }
#   }
# }
# 
# 
# gregexpr("",json_data[[1]]$ingredient[1])
# grep("[-]?[0-9]+[.]?[0-9]*|[-]?[0-9]+[L]?|[-]?[0-9]+[.]?[0-9]*[eE][0-9]+",unsaming2)
# 
# grepl("[-]?[0-9]+[.]?[0-9]*|[-]?[0-9]+[L]?|[-]?[0-9]+[.]?[0-9]*[eE][0-9]+",json_data[[1]]$ingredient[1])
# 
# for (i in 1:length(hi)){
#   for(j in 1:length(hi)){
#     for(k in strsplit(hi[j],' ')){
#       if(hi[i]==k){
#         hi[j]=hi[i]
#         hi=unique(hi)
#       }
#     }
#   }
# }
# 
# 
# 
# 
# library("stringi")
# 
# nutri=matrix(ncol=8)
# for (i in 1:length(json_data)){
#   x=json_data[[i]]$nutrition
#   y=stri_extract_last_regex(x,"[0-9]+\\.?[0-9]*")
#   nutri=rbind(nutri,matrix(as.numeric(y),1,8))
# }
# nutri=nutri[-1,]
# nutri[is.na(nutri)]=0
# nutri=as.data.frame(nutri)
# colnames(nutri)=stri_extract_last_regex(x,"[a-z][a-z]+")
# 
# 
# 
# nutri2=apply(nutri,2,scale)
# clu=kmeans(nutri,5)
# clu2=kmeans(nutri2,5)
# pairs(nutri2[,-1],col=clu2[1][[1]])
# 
# nutri3=t(apply(nutri,1,function(x){if(x[1]!=0){return(100/x[1]*x)}else{return(rep(0,8))}}))
# clu3=kmeans(nutri3,4)
# colnames(nutri3)=colnames(nutri)
# pairs(nutri3[,-1],col=clu3[1][[1]])
# hclust(nutri3)
# library(foreign)
# 
# file='C:/Users/TEST/Documents/NTU courses/?լd???k/?��?PROJECT TYP/data/j1w8s_Sep2012.sav'
# dataset = read.spss(file, to.data.frame=TRUE)
# 
# file='C:/Users/TEST/Documents/NTU courses/?լd???k/?��?PROJECT TYP/data/j3w1s_Dec2008.sav'
# # dataset2 = read.spss(file, to.data.frame=TRUE)
# # 
# w <- c('PT1H50M','PT2H20M','PT30M')
# H=stri_extract_first_regex(stri_extract_all_regex(w,'[0-9]*H',omit_no_match=T),'[0-9]*')
# M=stri_extract_first_regex(stri_extract_all_regex(w,'[0-9]*M',omit_no_match=T),'[0-9]*')
# H=as.numeric(H)
# H[is.na(as.numeric(H))]=0
# M=as.numeric(M)
# M[is.na(as.numeric(M))]=0
# 60*H+M
# 
# 
# load('C:/Users/TEST/Documents/NTU courses/Network Analysis/HW9/Task1.RData')
# # E(rfid)
# library(NLP)
# library(openNLP)
# 
# tagPOS <-  function(x, ...) {
#   s <- as.String(x)
#   word_token_annotator <- Maxent_Word_Token_Annotator()
#   a2 <- Annotation(1L, "sentence", 1L, nchar(s))
#   a2 <- annotate(s, word_token_annotator, a2)
#   a3 <- annotate(s, Maxent_POS_Tag_Annotator(), a2)
#   a3w <- a3[a3$type == "word"]
#   POStags <- unlist(lapply(a3w$features, `[[`, "POS"))
#   POStagged <- paste(sprintf("%s/%s", s[a3w], POStags), collapse = " ")
#   list(POStagged = POStagged, POStags = POStags)
# }
# 
# hehe=NULL
# for(i in 1:length(samrec)){
#   if(length(samrec[[i]]$method)>0&
#      length(samrec[[i]]$ingredient)>0){
#     if(length(strsplit(samrec[[i]]$method,'')[[1]])>5){
#       acqTag1 <- tagPOS(samrec[[i]]$method)    
#       acqTag2 <- tagPOS(samrec[[i]]$ingredient) 
#       acqTagSplit1 = strsplit(acqTag1[[1]]," ")[[1]]
#       acqTagSplit2 = strsplit(acqTag2[[1]]," ")[[1]]
#       
#       
#       ha=intersect(acqTagSplit1[grepl("NN",acqTagSplit1 )],
#                    acqTagSplit2[grepl("NN",acqTagSplit2 )])
#       endlen=length(ha)-1
#       bye=rep(T,length(ha))
#       stocom=NULL
#       if(length(ha)>1){
#         for(k in 1:endlen){
#           comnoun=paste(strsplit(ha,"/")[[k]][1],strsplit(ha,"/")[[k+1]][1])
#           if(any(grepl(comnoun,samrec[[i]]$ingredient))){
#             stocom=c(stocom,comnoun)
#             bye[k]=F
#             bye[k+1]=F
#             #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][1],'/',sep=''),ha)]
#             #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][2],'/',sep=''),ha)]
#           }
#         }
#       }
#       ha=ha[bye]
#       ha=c(ha,stocom)
#       hehe=c(hehe,ha)
#       print(paste('just finished ',i))
#     }
#   }
# }
# hehe=unique(hehe)
# hehe=hehe[!grepl('tbsp|tsp',hehe)]
# 
# hehe[grepl('NNS',hehe)]
# 
# 
# hehe=sapply(strsplit(hehe,'/'),head,n=1)
# 
# write(sapply(strsplit(hehe,'/'),head,n=1),file='inglist2.csv',sep='\n')


# 
# hehe=NULL
# for(i in 1:length(samrec)){
#   if(length(samrec[[i]]$method)>0&
#      length(samrec[[i]]$ingredient)>0){
#     if(length(strsplit(samrec[[i]]$method,'')[[1]])>5){
#       acqTag1 <- tagPOS(samrec[[i]]$method)    
#       acqTag2 <- tagPOS(samrec[[i]]$ingredient) 
#       acqTagSplit1 = strsplit(acqTag1[[1]]," ")[[1]]
#       acqTagSplit2 = strsplit(acqTag2[[1]]," ")[[1]]
#       
#       
#       ha=intersect(acqTagSplit1[grepl("NN",acqTagSplit1 )],
#                    acqTagSplit2[grepl("NN",acqTagSplit2 )])
#       endlen=length(ha)-1
#       bye=rep(T,length(ha))
#       stocom=NULL
#       if(length(ha)>1){
#         for(k in 1:endlen){
#           comnoun=paste(strsplit(ha,"/")[[k]][1],strsplit(ha,"/")[[k+1]][1])
#           if(any(grepl(comnoun,samrec[[i]]$ingredient))){
#             stocom=c(stocom,comnoun)
#             bye[k]=F
#             bye[k+1]=F
#             #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][1],'/',sep=''),ha)]
#             #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][2],'/',sep=''),ha)]
#           }
#         }
#       }
#       endlen=length(ha)-1
#       bye=rep(T,length(ha))
#       stocom=NULL
#       if(length(ha)>2){
#         for(k in 1:endlen){
#           comnoun=paste(strsplit(ha,"/")[[k]][1],strsplit(ha,"/")[[k+1]][1])
#           if(any(grepl(comnoun,samrec[[i]]$ingredient))){
#             stocom=c(stocom,comnoun)
#             bye[k]=F
#             bye[k+1]=F
#             #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][1],'/',sep=''),ha)]
#             #ha=ha[!grepl(paste(strsplit(comnoun,' ')[[1]][2],'/',sep=''),ha)]
#           }
#         }
#       }
#       ha=ha[bye]
#       ha=c(ha,stocom)
#       hehe=c(hehe,ha)
#       print(paste('just finished ',i))
#     }
#   }
# }



#   
# qq = 0
# tag = 0
# 
# for (i in 1:length(acqTagSplit[[1]])){
#   qq[i] <-strsplit(acqTagSplit[[1]][i],'/')
#   tag[i] = qq[i][[1]][2]
# }
# 
# index = 0
# 
# k = 0
# 
# for (i in 1:(length(acqTagSplit[[1]])-1)) {
#   
#   if ((tag[i] == "NN" && tag[i+1] == "NN") | 
#       (tag[i] == "NNS" && tag[i+1] == "NNS") | 
#       (tag[i] == "NNS" && tag[i+1] == "NN") | 
#       (tag[i] == "NN" && tag[i+1] == "NNS") | 
#       (tag[i] == "JJ" && tag[i+1] == "NN") | 
#       (tag[i] == "JJ" && tag[i+1] == "NNS"))
#   {      
#     k = k +1
#     index[k] = i
#   }
#   
# }
# 
# index



