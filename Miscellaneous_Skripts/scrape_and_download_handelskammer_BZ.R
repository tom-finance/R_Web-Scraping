
handel <- "http://www.handelskammer.bz.it/it/servizi/agricoltura/frutticoltura/giacenze-mensili"

handels <- read_html("http://www.handelskammer.bz.it/it/servizi/agricoltura/frutticoltura/giacenze-mensili")

# ul:nth-child(3) a


test <- handels %>%
  html_nodes("#block-system-main a") %>% # html node extracted with selector gadget
  html_attr("href") # hre

links <- paste("http://www.handelskammer.bz.it", test, sep = "")


hoi <- "http://www.handelskammer.bz.it/sites/default/files/uploaded_files/Lagerbest%C3%A4nde%20TN-S%C3%BCdtirol%2001012019.xlsx"

download.file(links[1], destfile = "handels.xlsx", mode = "wb")


hoi <- grep(pattern = "handelskammer", test, perl = TRUE)

links_new <- paste("http://www.handelskammer.bz.it", test[-hoi], sep = "")

her <- c(1:length(links_new))

names <- paste(her, ".xls", sep = "")

for (i in 1:length(links_new)) {
  download.file(links_new[i], destfile = names[i], mode = "wb")
}

