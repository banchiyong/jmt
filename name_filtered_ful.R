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
seoul_ful_n <- gsub(("\\(.*\\)"),"",seoul_ful_n)
seoul_ful_n <- gsub(("\\（.*\\）"),"",seoul_ful_n)
seoul_ful_n <- gsub(("\\(.*\\)"),"",seoul_ful_n)
seoul_ful_n <- gsub(("\\（.*\\)"),"",seoul_ful_n)
#seoul_ful2 <- gsub(("외.*"),"",seoul_ful_n)

seoul_ful_n <- gsub("（주）","",seoul_ful_n)
seoul_ful_n <- gsub(("서.*로"),"",seoul_ful_n)
seoul_ful_n <- gsub(("서.*길"),"",seoul_ful_n)
seoul_ful_n <- gsub(("서.*구"),"",seoul_ful_n)
seoul_ful_n <- gsub(("㈜"),"",seoul_ful_n)
seoul_ful_n <- gsub(("주식회사"),"",seoul_ful_n)
seoul_ful_n <- gsub(("\\s"),"",seoul_ful_n)
seoul_ful_n <- gsub(("중구.*"),"",seoul_ful_n)
seoul_ful_n <- gsub(("\\（.*"),"",seoul_ful_n)
seoul_ful_n <- gsub(("\\(.*"),"",seoul_ful_n)
seoul_ful_n <- gsub(("^=.*"),"",seoul_ful_n)
seoul_ful_n <- gsub(("^11번가.*"),"",seoul_ful_n)
seoul_ful_n <- gsub(("^１１번가"),"",seoul_ful_n)
seoul_ful_n <- gsub(("가마솥나주곰탕]"),"가마솥나주곰탕",seoul_ful_n)
seoul_ful_n <- gsub(("^１１번가"),"",seoul_ful_n)
seoul_ful_n <- gsub((","),"",seoul_ful_n)
seoul_ful_n <- gsub(("/."),"",seoul_ful_n)
seoul_ful_n <- gsub((":"),"",seoul_ful_n)
seoul_ful_n <- gsub(("/."),"",seoul_ful_n)
seoul_ful_n <- gsub(("129"),"",seoul_ful_n)
seoul_ful_n <- gsub(("16참숯골"),"참숯골",seoul_ful_n)
seoul_ful_n <- gsub(("14송학"),"송학",seoul_ful_n)
seoul_ful_n <- gsub(("16중국성"),"중국성",seoul_ful_n)
seoul_ful_n <- gsub(("16동해수산"),"동해수산",seoul_ful_n)
seoul_ful_n <- gsub(("16동해일식"),"동해일식",seoul_ful_n)
seoul_ful_n <- gsub(("17-17만복림"),"만복림",seoul_ful_n)
seoul_ful_n <- gsub(("217DMC자이1단지이마트"),"",seoul_ful_n)
seoul_ful_n <- gsub(("２Ｔｈｉｒｓｔｙ"),"2Thirsty",seoul_ful_n)
seoul_ful_n <- gsub(("２Thirsty"),"2Thirsty",seoul_ful_n)
seoul_ful_n <- gsub(("２Thirsty30"),"2Thirsty",seoul_ful_n)
seoul_ful_n <- gsub(("２Ｔｈｉｒｓｔｙ30"),"2Thirsty",seoul_ful_n)

seoul_ful$exec_loc <- seoul_ful_n

seoul_ful <- subset(seoul_ful , exec_loc != "")
seoul_ful <- subset(seoul_ful , exec_loc != "-")
seoul_ful <- subset(seoul_ful , exec_loc != "_")
seoul_ful <- subset(seoul_ful , exec_loc != "0")
seoul_ful <- subset(seoul_ful , exec_loc != "1")
seoul_ful <- subset(seoul_ful , exec_loc != "110")
seoul_ful <- subset(seoul_ful , exec_loc != "100회")
seoul_ful <- subset(seoul_ful , exec_loc != "１００회")
seoul_ful <- subset(seoul_ful , exec_loc != "101-1")
seoul_ful <- subset(seoul_ful , exec_loc != "115")
seoul_ful <- subset(seoul_ful , exec_loc != "115-0")
seoul_ful <- subset(seoul_ful , exec_loc != "11번가")
seoul_ful <- subset(seoul_ful , exec_loc != "15")
seoul_ful <- subset(seoul_ful , exec_loc != "151층")
seoul_ful <- subset(seoul_ful , exec_loc != "16")
seoul_ful <- subset(seoul_ful , exec_loc != "18")
seoul_ful <- subset(seoul_ful , exec_loc != "11길")
seoul_ful <- subset(seoul_ful , exec_loc != "129")
seoul_ful <- subset(seoul_ful , exec_loc != "16길")
seoul_ful <- subset(seoul_ful , exec_loc != "181길")
seoul_ful <- subset(seoul_ful , exec_loc != "19")
seoul_ful <- subset(seoul_ful , exec_loc != "1가25오피스디포코리아")
seoul_ful <- subset(seoul_ful , exec_loc != "1가56)")

seoul_ful <- subset(seoul_ful , exec_loc != "1길")
seoul_ful <- subset(seoul_ful , exec_loc != "1길18")
seoul_ful <- subset(seoul_ful , exec_loc != "16길")
seoul_ful <- subset(seoul_ful , exec_loc != "19")

write.table(seoul_ful,file="filtered_list.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t",append = FALSE)


# 
# 
# 
# b <- as.data.frame(seoul_ful2)
# 
# 
# a <- grep("^\\(",seoul_ful1)
# a <- grep("\\)$",seoul_ful1)
# a <- grep("^\\(\\)$",seoul_ful1)
# a <- grep("\\(.*\\)",seoul_ful1)
# seoul_ful1[a]
# 
# 
# #b <- replace(벡터명,list=벡터의 인덱스 ,values=변경할 값)