#####Set Env#####
rm(list=ls())
gc()
options(stringsAsFactors = FALSE)
options(digits = 10)
options(scipen = 100)
#install.packages("data.table")
#install.packages("dplyr")
#install.packages("jsonlite")
#install.packages("RCurl)
library(jsonlite)
library(data.table)
library(RCurl) 
library(dplyr)
library(MatchIt)
library(stringr)



#####/Env####

##
getwd()
setwd("C:/projects/jmt/")
seoul_ful <- fread("filtered_jmt_2018_seoul_city_ful.csv")
##
seoul_ful_n <- seoul_ful$exec_loc
seoul_ful_n <- gsub(("\\(.*\\)"),"",seoul_ful)
seoul_ful_n <- gsub(("\\（.*\\）"),"",seoul_ful)
seoul_ful_n <- gsub(("\\(.*\\)"),"",seoul_ful)
seoul_ful_n <- gsub(("\\（.*\\)"),"",seoul_ful)
#seoul_ful2 <- gsub(("외.*"),"",seoul_ful)

seoul_ful_n <- gsub("（주）","",seoul_ful)
seoul_ful_n <- gsub(("서.*로"),"",seoul_ful)
seoul_ful_n <- gsub(("서.*길"),"",seoul_ful)
seoul_ful_n <- gsub(("서.*구"),"",seoul_ful)
seoul_ful_n <- gsub(("㈜"),"",seoul_ful)
seoul_ful_n <- gsub(("주식회사"),"",seoul_ful)
seoul_ful_n <- gsub(("\\s"),"",seoul_ful)
seoul_ful_n <- gsub(("중구.*"),"",seoul_ful)
seoul_ful_n <- gsub(("\\（.*"),"",seoul_ful)
seoul_ful_n <- gsub(("\\(.*"),"",seoul_ful)
write.table(seoul_ful,file="filtered_list.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t",append = FALSE)





b <- as.data.frame(seoul_ful2)


a <- grep("^\\(",seoul_ful1)
a <- grep("\\)$",seoul_ful1)
a <- grep("^\\(\\)$",seoul_ful1)
a <- grep("\\(.*\\)",seoul_ful1)
seoul_ful1[a]


#b <- replace(벡터명,list=벡터의 인덱스 ,values=변경할 값)