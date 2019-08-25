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
# https://rfriend.tistory.com/10 한글 깨질 때
setwd("d:/projects/jmt")

temp_table1 <- fread("201801_expense_list.csv", encoding = "UTF-8")
temp_table2 <- fread("201802_expense_list.csv", encoding = "UTF-8")
temp_table3 <- fread("201803_expense_list.csv", encoding = "UTF-8")
temp_table4 <- fread("201804_expense_list.csv", encoding = "UTF-8")
temp_table5 <- fread("201805_expense_list.csv", encoding = "UTF-8")
temp_table6 <- fread("201806_expense_list.csv", encoding = "UTF-8")
temp_table7 <- fread("201807_expense_list.csv", encoding = "UTF-8")
temp_table8 <- fread("201808_expense_list.csv", encoding = "UTF-8")
temp_table9 <- fread("201809_expense_list.csv", encoding = "UTF-8")
temp_table10 <- fread("201810_expense_list.csv", encoding = "UTF-8")
temp_table11 <- fread("201811_expense_list.csv", encoding = "UTF-8")
temp_table12 <- fread("201812_expense_list.csv", encoding = "UTF-8")
combined_table <- rbind(temp_table1,temp_table2,temp_table3,temp_table4,temp_table5,temp_table6,temp_table7,temp_table8,temp_table9,temp_table10,temp_table11,temp_table12)
#write.table(combined_table, file = "filtered_jmt_2018_seoul_city_ful.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")
combined_table <- combined_table[,c("dept_nm_lvl_2","exec_loc","exec_amount")]
combined_table <- combined_table %>% filter(!is.na("dept_nm_lvl_2"))
combined_table <- combined_table %>% filter(!is.na("exec_loc"))
combined_table <- combined_table %>% filter(!is.na("exec_amount"))
ranking_table <- table(combined_table$exec_loc)
View(ranking_table)
combined_table <- subset(combined_table, exec_loc!=""&exec_loc!="0"&exec_loc!="()"&exec_loc!="ㅡ"&exec_loc!="-")
ranking_table <- table(combined_table$exec_loc)
View(ranking_table)
hist(ranking_table)
ranking_table <- as.data.frame(ranking_table)
ranking_table_cut <- subset(ranking_table, Freq>=30)
View(ranking_table_cut)
hist(ranking_table_cut$Freq)
length(ranking_table_cut$Freq)
ranking_table_cut$Var1 <- as.character(ranking_table_cut$Var1)
class(ranking_table_cut$Var1)
class(combined_table$dept_nm_lvl_2)
colnames(ranking_table_cut) <- c("exec_loc","Freq")
filtered_jmt <- inner_join(ranking_table_cut,combined_table)
View(ranking_table_cut)
View(combined_table)
View(filtered_jmt)


filtered_jmt <- unique(filtered_jmt[,c(1,2,3)])
View(filtered_jmt)

mapping_to <- as.data.frame(unique(filtered_jmt[,1]))
mapping_from <- as.data.frame(unique(filtered_jmt[,3]))

mapping_to <- mapping_to %>% mutate(to_id = paste0("to_",seq_len(n())))
mapping_from <- mapping_from %>% mutate(from_id = paste0("from_",seq_len(n())))

View(mapping_to)

filtered_jmt <- left_join(filtered_jmt,mapping_to, by="exec_loc")
filtered_jmt <- left_join(filtered_jmt,mapping_from, by="dept_nm_lvl_2")

View(filtered_jmt)

write.table(combined_table, file = "combined_2018_seoul_city.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")
#write.table(filtered_jmt, file = "filtered_jmt_2018_seoul_city.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")
write.table(filtered_jmt[c(2,4,5)], file = "filtered_jmt_2018_seoul_city_mapping.txt", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t", fileEncoding = "utf-8")

#############################

setwd("D:/projects/jmt/web_session/data")

temp_data <- fromJSON("document.json")


important_data <- temp_data[["filtered_jmt_2018_seoul_city_mapping.txt"]][["elements"]][["nodes"]][["data"]]

View(important_data)

important_data <- left_join(important_data,mapping_to, by = c("name" = "to_id"))
important_data <- left_join(important_data,mapping_from, by = c("name" = "from_id"))

important_data$exec_loc[is.na(important_data$exec_loc)] <- ""
important_data$dept_nm_lvl_2[is.na(important_data$dept_nm_lvl_2)] <- ""
View(important_data)

important_data$name <- paste0(important_data$exec_loc,important_data$dept_nm_lvl_2)

important_data <- important_data[c(1,2,3,4,5,6)]
View(important_data)

temp_data[["filtered_jmt_2018_seoul_city_mapping.txt"]][["elements"]][["nodes"]][["data"]] <- important_data


exportJson<-toJSON(temp_data)

write(exportJson,file='e_document.json')

















