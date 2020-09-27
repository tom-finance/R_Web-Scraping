################################################################################
# AUTOMATED DOWNLOAD FROM ECB WEBSITE
# 
# (c) Thomas Ludwig. This version: 19/05/2020.
################################################################################

# package
library(rvest)

# target website for automated download
# https://www.ecb.europa.eu/paym/coll/assets/html/list-MID.en.html

# extract most recent download link
link <- read_html("https://www.ecb.europa.eu/paym/coll/assets/html/list-MID.en.html") %>%
  html_nodes("tr:nth-child(1) .csv") %>% # html node extracted with selector gadget
  html_attr("href") %>% # extract link to download
  paste0("https://www.ecb.europa.eu", .) # create full path from relative path


# construct path for saving/loading the data
path <- paste0("ecb_data_",
               substr(link, 
                      nchar(link)-9, 
                      nchar(link)-4),
               ".csv")


# download file into current working directory
download.file(link, path, mode = "wb")


# read data into R
data <- read.csv(path, skipNul = TRUE, sep = '\t',header = TRUE, fileEncoding = "UTF-16LE")


# alternative: direkt import into R without file download
data <- read.csv(link, skipNul = TRUE, sep = '\t',header = TRUE, fileEncoding = "UTF-16LE")

################################################################################