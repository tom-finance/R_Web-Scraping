
# Download data from ECB Webpage

link <- "https://www.ecb.europa.eu/mopo/implement/omo/html/tops.zip?08720a8fb6d477d0008300e47e81d0b9"

# download zip-file into current working directory
download.file(link, destfile = "data.zip", mode = "wb") # important: use "wb" to treat as binary for correct download

# unzip file
unzip("data.zip")

# get names
test <- unzip("data.zip", list = TRUE)$Name

# delete file
file.remove("data.zip")

# load data into R
data_ecb <- read.csv(file = test)

# alternative: read table from website with rvest...
# node: .number , .header, td, .header

# ------------------------------------------------------------------------------