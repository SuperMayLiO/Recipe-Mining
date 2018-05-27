#load package
library(dplyr)

#先設定路徑
setwd("C:/Users/May/Documents/BBC")

#load data
load("samrecwithcomment.rda")
recipe_list=read.csv("recipe_list.csv", header=T)

#choose dish recipes
cate_dish=samrec[recipe_list[,3]=="dish"]  
namelist=NULL
for (i in 1:length(cate_dish)){
  namelist=c(namelist,names(cate_dish[[i]]$comment))
}
namelist <- unique(namelist)
dish_com_pos=as.data.frame(matrix('',nrow=length(namelist),ncol=3),stringsAsFactors=F)
dish_com_neg=as.data.frame(matrix('',nrow=length(namelist),ncol=3),stringsAsFactors=F)
dish_com_pos[,1]=namelist
dish_com_neg[,1]=namelist
dish_com_pos[,3]=0
dish_com_neg[,3]=0


for (i in 1:length(cate_dish)){
  for(j in 1:length(cate_dish[[i]]$comment)){
    if(length(cate_dish[[i]]$comment)>0){
      if(!is.null(cate_dish[[i]]$comment[[j]]$commentrating)){
        if(cate_dish[[i]]$comment[[j]]$commentrating %>% as.numeric < 2.5){
          dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,2] <-
            paste(dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,2],cate_dish[[i]]$comment[[j]]$comment)
          dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,3] <-
            cate_dish[[i]]$comment[[j]]$commentrating %>% as.numeric
          
        }else if(cate_dish[[i]]$comment[[j]]$commentrating %>% as.numeric > 3){
          dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,2] <-
            paste(dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,2],cate_dish[[i]]$comment[[j]]$comment)
          dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,3] <-
            cate_dish[[i]]$comment[[j]]$commentrating %>% as.numeric
          
        }
      }
      if(!is.null(cate_dish[[i]]$comment[[j]]$`commentrating*`)){
        if(cate_dish[[i]]$comment[[j]]$`commentrating*` %>% as.numeric < 2.5){
          dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,2] <-
            paste(dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,2],cate_dish[[i]]$comment[[j]]$`comment*`)
          dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,3] <-
            mean(dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,3] ,
                 cate_dish[[i]]$comment[[j]]$`commentrating*` %>% as.numeric )
          
        }else if(cate_dish[[i]]$comment[[j]]$`commentrating*` %>% as.numeric > 3){
          dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,2] <-
            paste(dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,2],cate_dish[[i]]$comment[[j]]$`comment*`)
          dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,3] <-
            mean(dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,3] ,
                 cate_dish[[i]]$comment[[j]]$`commentrating*` %>% as.numeric )
          
        }
      }
      if(!is.null(cate_dish[[i]]$comment[[j]]$`commentrating**`)){
        if(cate_dish[[i]]$comment[[j]]$`commentrating**` %>% as.numeric < 2.5){
          dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,2] <-
            paste(dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,2],cate_dish[[i]]$comment[[j]]$`comment**`)
          dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,3] <-
            mean(dish_com_neg[names(cate_dish[[i]]$comment)[j]==namelist,3] ,
                 cate_dish[[i]]$comment[[j]]$`commentrating**` %>% as.numeric)
          
        }else if(cate_dish[[i]]$comment[[j]]$`commentrating**` %>% as.numeric > 3){
          dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,2] <-
            paste(dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,2],cate_dish[[i]]$comment[[j]]$`comment**`)
          dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,3] <-
            mean(dish_com_pos[names(cate_dish[[i]]$comment)[j]==namelist,3] ,
                 cate_dish[[i]]$comment[[j]]$`commentrating**` %>% as.numeric)
          
        }
      }
    }
  }
}

#save table
dish_com_neg <- dish_com_neg[dish_com_neg[,2]!='',]
dish_com_pos <- dish_com_pos[dish_com_pos[,2]!='',]



###########################

for(i in 1:200){
  if(samrec[[i]]$comment %>% names %>% grepl(pattern='georgeb74') %>% any){
    print(i)
  }
}

samrec[[2]]$comment['georgeb74']
names(samrec)[2]

