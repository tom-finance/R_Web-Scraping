################################################################################
# Web Scraping of most popular names from Website and small analysis
################################################################################

library(dplyr)
library(rvest)


links <- c(paste0("https://gfds.de/ausfuehrliche-auswertung-die-beliebtesten-vornamen-",
                                                                             2011:2017, "/"),
           "https://gfds.de/ausfuehrliche-auswertung-vornamen-2018/")

results <- list()

for (i in 1:length(links)) {
  
  daten <- read_html(links[i]) %>%
    html_nodes("table.table.table-hover")
  
  results[[i]] <- daten[[1]] %>%
    html_table(header = TRUE)
  
  print(i)
  
}


results <- lapply(results, setNames, c("v1", "v2", "v3", "v4"))

res_all <- do.call(rbind.data.frame, results)


# cleaning up data

res_all$v1 <- gsub("[()]", "", res_all$v1)
res_all$v1 <- gsub('[[:digit:]]+', "", res_all$v1)

res_all$v3 <- gsub("[()]", "", res_all$v3)
res_all$v3 <- gsub('[[:digit:]]+', "", res_all$v3)

substring(res_all$v1, 3)

# ------------------------------------------------------------------------------

# select random name

res_all[sample(1:80, 1),]

# ------------------------------------------------------------------------------

summen <- data.frame(year = 2011:2018,
                    women_top10 = sapply(results, FUN = function (x) sum(as.numeric(gsub(",", ".", gsub("\\.", "", x[, 2]))))),
                     men_top10 = sapply(results, FUN = function (x) sum(as.numeric(gsub(",", ".", gsub("\\.", "", x[, 4]))))),
                     women_top1 = sapply(results, FUN = function (x) max(as.numeric(gsub(",", ".", gsub("\\.", "", x[, 2]))))),
                     men_top1 = sapply(results, FUN = function (x) max(as.numeric(gsub(",", ".", gsub("\\.", "", x[, 4]))))))

matplot(summen[, c(2,3)], x = summen[, 1], 
        type="b", pch=15:19, xlab = "Jahr", 
        ylab = "Anteil Top 10 (%)")
grid()

matplot(summen[, c(4,5)], x = summen[, 1], 
        type="b", pch=15:19, xlab = "Jahr", 
        ylab = "Anteil Top 1 (%)")
grid()

# ------------------------------------------------------------------------------