
# Establishing stable programmatic access to Bancit statistical database using R (no stable API available?)

# this version: 17/02/2019

getwd()
setwd("C:/Users/User/Desktop")

# link provided by Bancit for programmatic access to database
link <- "https://a2a.bancaditalia.it/infostat/dataservices/export/IT/CSV/DATA/CUBE/BANKITALIA/DIFF/TDB20207"

# download zip-file into current working directory
download.file(link, destfile = "data.zip", mode = "wb") # important: use "wb" to treat as binary for correct download

# unzip file
unzip("data.zip")

# get all filenames listed in zipped file
test <- unzip("data.zip", list = TRUE)$Name

# get filename conditional on search criteria (e.g. only .csv files)
zipped_csv_names <- grep('\\.csv$', unzip('data.zip', list=TRUE)$Name, 
                         ignore.case=TRUE, value=TRUE)

# source:
# https://stackoverflow.com/questions/32870863/extract-certain-files-from-zip

# read data in R data frame
data <- read.csv2(zipped_csv_names)

# ------------------------------------------------------------------------------