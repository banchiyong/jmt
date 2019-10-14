options(stringsAsFactors = FALSE)
options(digits = 20)
options(encoding = "utf8")
#install.packages("data.table")
#install.packages("dplyr")
#install.packages("jsonlite")
#install.packages("RCurl)
library(jsonlite)
library(data.table)
library(dplyr)
library(RCurl) 
# https://rfriend.tistory.com/10 using korean
# set working directory
setwd("d:/projects/jmt")


#### replaced! combined_table  ####

# read! name_filtered_ful.R

# # loading 
# temp_table1 <- fread("201801_expense_list.csv", encoding = "UTF-8")
# temp_table2 <- fread("201802_expense_list.csv", encoding = "UTF-8")
# temp_table3 <- fread("201803_expense_list.csv", encoding = "UTF-8")
# temp_table4 <- fread("201804_expense_list.csv", encoding = "UTF-8")
# temp_table5 <- fread("201805_expense_list.csv", encoding = "UTF-8")
# temp_table6 <- fread("201806_expense_list.csv", encoding = "UTF-8")
# temp_table7 <- fread("201807_expense_list.csv", encoding = "UTF-8")
# temp_table8 <- fread("201808_expense_list.csv", encoding = "UTF-8")
# temp_table9 <- fread("201809_expense_list.csv", encoding = "UTF-8")
# temp_table10 <- fread("201810_expense_list.csv", encoding = "UTF-8")
# temp_table11 <- fread("201811_expense_list.csv", encoding = "UTF-8")
# temp_table12 <- fread("201812_expense_list.csv", encoding = "UTF-8")
# #combine
# combined_table <- rbind(temp_table1,temp_table2,temp_table3,temp_table4,temp_table5,temp_table6,temp_table7,temp_table8,temp_table9,temp_table10,temp_table11,temp_table12)
#full data
#write.table(combined_table, file = "filtered_jmt_2018_seoul_city_ful.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")
# We need preprocessing. 
# store's name is weird

combined_table <- fread("filtered_list.txt")

#### ####




# to calculate the freq
combined_table <- combined_table[,c("dept_nm_lvl_2","exec_loc","exec_amount")]
combined_table <- combined_table %>% filter(!is.na("dept_nm_lvl_2"))
combined_table <- combined_table %>% filter(!is.na("exec_loc"))
combined_table <- combined_table %>% filter(!is.na("exec_amount"))
ranking_table <- table(combined_table$exec_loc)
#View(ranking_table)

# TODO : we need more filter..
# Special thanks to byh92
# combined_table <- subset(combined_table, exec_loc!=""&exec_loc!="0"&exec_loc!="()"&exec_loc!="ㅡ"&exec_loc!="-")

# frequency distribution
hist(ranking_table)

#store and frequency
ranking_table <- table(combined_table$exec_loc)
#View(ranking_table)

# frequency cut. 
# prototype >= 30
# next >= 50
ranking_table <- as.data.frame(ranking_table)
ranking_table_cut <- subset(ranking_table, Freq>=100)
#View(ranking_table_cut)

# check
# frequency distribution
hist(ranking_table_cut$Freq)
ranking_table_cut$Var1 <- as.character(ranking_table_cut$Var1)
# length(ranking_table_cut$Freq)
# class(ranking_table_cut$Var1)
# class(combined_table$dept_nm_lvl_2)
colnames(ranking_table_cut) <- c("exec_loc","Freq")

#combine node's frequency
filtered_jmt <- inner_join(ranking_table_cut,combined_table)
#View(ranking_table_cut)
#View(combined_table)
#View(filtered_jmt)


# [ ] what what what? I can remmeber. insert plz. 
# what is filtered_jmt[,c(1,2,3)]
filtered_jmt <- unique(filtered_jmt[,c(1,2,3)])
filtered_jmt <- subset(filtered_jmt,dept_nm_lvl_2 != "")
#View(filtered_jmt)

# edges.
mapping_to <- as.data.frame(unique(filtered_jmt[,1]))
mapping_from <- as.data.frame(unique(filtered_jmt[,3]))

# to mapping...
# to fix cytoscape's issue.
mapping_to <- mapping_to %>% mutate(to_id = paste0("to_",seq_len(n())))
colnames(mapping_to) <- c("exec_loc","to_id")
mapping_from <- mapping_from %>% mutate(from_id = paste0("from_",seq_len(n())))
colnames(mapping_from) <- c("dept_nm_lvl_2","from_id")
#View(mapping_to)
filtered_jmt <- left_join(filtered_jmt,mapping_to, by="exec_loc")
filtered_jmt <- left_join(filtered_jmt,mapping_from, by="dept_nm_lvl_2")
#View(filtered_jmt)


# save files
# write.table(combined_table, file = "combined_2018_seoul_city.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")
# write.table(filtered_jmt, file = "filtered_jmt_2018_seoul_city.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")
#write.csv(filtered_jmt,"network_jmt_2018_soul_city.csv", fileEncoding = "euc-kr")

write.table(filtered_jmt, file = "network_jmt_2018_soul_city.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")

#####################
# build the web app #
#####################


# to fix cytoscape's issue...
# handling json data. (network.js)

# loading
setwd("D:/projects/jmt/web_session/data")
temp_data <- fromJSON("document.json")
important_data <- temp_data[["filtered_jmt_2018_seoul_city_mapping.txt"]][["elements"]][["nodes"]][["data"]]

View(important_data)

#mapping
important_data <- left_join(important_data,mapping_to, by = c("name" = "to_id"))
important_data <- left_join(important_data,mapping_from, by = c("name" = "from_id"))

#to merge.
important_data$exec_loc[is.na(important_data$exec_loc)] <- ""
important_data$dept_nm_lvl_2[is.na(important_data$dept_nm_lvl_2)] <- ""
View(important_data)

important_data$name <- paste0(important_data$exec_loc,important_data$dept_nm_lvl_2)

# return
important_data <- important_data[c(1,2,3,4,5,6)]
View(important_data)
temp_data[["filtered_jmt_2018_seoul_city_mapping.txt"]][["elements"]][["nodes"]][["data"]] <- important_data

# save
exportJson<-toJSON(temp_data)
write(exportJson,file='e_document.json')

# edit something. and complete.

















