################################################################################
# Automated PDF Data Cleansing Skript
################################################################################

# packages
library(openxlsx)
library(pdftools)
library(dplyr)
library(stringi)

################################################################################

# path to input file
pfad <- "K:/fax1.pdf"


text <- pdf_text(pfad) %>% # read data into R
  stri_split_lines() %>% # turn \n to a separate character vector element
  unlist() # simplify output to one string vector

# check cancelled/not cancelled
pat_cancel <- "our ref" # pattern for line in which the term "cancelled" might occur

cancel_check <- ifelse(grepl("cancelled", text[grepl(pat_cancel, text)]),
       yes = "cancelled", # if we find the pattern "cancelled" label output with "cancelled"
       no = "not cancelled")

# buy/sell
pat_buy <- 'for you by order and for account of'
buy_sell <- gsub(" :", "", gsub("we ", "", gsub(pat_buy, "", text[grepl(pat_buy, text)])))

# date
pat_sd <- "s/d"
date <- gsub(" : ", "", gsub(".*s/d", "", text[grepl(pat_sd, text)]))
date <- as.Date(date, "%d.%m.%Y") # convert to R date format (useful for filtering)

# betrag/valuta
pat_val <- "total consideration"
value <- text[grepl(pat_val, text)]

number <- as.numeric(gsub("[^0-9.]", "",  gsub(",", ".", gsub("\\.", "", value))))
# https://stackoverflow.com/questions/21027806/replacing-commas-and-dots-in-r

currency <- gsub("[^[:alnum:] ]", "", 
                 gsub(" ", "", gsub("[[:digit:]]+", "", 
                                    gsub("total consideration", "", value)), fixed = TRUE))
# https://stackoverflow.com/questions/8959243/r-remove-non-alphanumeric-symbols-from-a-string

# output summary
result <- data.frame(Geschäft = buy_sell,
                     Währung = currency,
                     Betrag = number,
                     Valuta = date,
                     Cancelled = cancel_check,
                     stringsAsFactors = FALSE)

# write result to Excel file (use current working directory)
write.xlsx(result,
           "Ergenis.xlsx")

################################################################################
