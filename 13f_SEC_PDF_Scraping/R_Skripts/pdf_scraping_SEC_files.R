
# Extract Tables from PDF

# ------------------------------------------------------------------------------

# This would be the target pdf file available on the www:
# https://www.sec.gov/divisions/investment/13f/13flist2019q1.pdf

# ------------------------------------------------------------------------------

# install.packages("tabulizer")

library(tabulizer) # extract from pdf
library(xlsx) # write Excel files
library(readxl) # read Excel files
library(pdftools) # extract PDF information

# ------------------------------------------------------------------------------

# path to file of interest
f1 <- "13fq3.pdf"

# extract number of pages
n_pages <- pdf_info(f1)$pages

# locate areas in PDF file
check <- locate_areas(f1, 3) # use page 3

tab <- extract_tables(f1, 
                      pages = 3:n_pages, # be careful last page is critical; start with third page!
                      output = "data.frame", 
                      guess = FALSE, # don't use algorithm for table detection
                      area = check) # use area provided by user

# check whether dimensions are equal to 5
dimensions <- sapply(tab,  FUN = function(x) dim(x)[2]) == 5

# check what is wrong with this guys
mean(dimensions)
summary(dimensions)

# ------------------------------------------------------------------------------

dimensions_wrong <- sapply(tab,  FUN = function(x) dim(x)[2]) != 5

# which indices are problematic?
which(dimensions_wrong <- sapply(tab,  FUN = function(x) dim(x)[2]) != 5)

# problematic data in new list
tabs_wrong <- tab[c(dimensions_wrong)]

# cancel wrong column
tabs_wrong[[2]]$X.1 <- NULL

# problem with last page??
check_last <- locate_areas(f1, 528) # use last page here

tab_last <- extract_tables(f1, 
                      pages = 528, 
                      output = "data.frame", 
                      guess = TRUE)

# to finish: last two problematic pages...

# ------------------------------------------------------------------------------

# keep only pages which are ok
tab2 <- tab[c(dimensions)]

# create final data.frame
final <- do.call(rbind.data.frame, tab2)

# ------------------------------------------------------------------------------

# write result to new Excel workbook!

write.xlsx(final, 
           file = "C:/Users/User/Desktop/test.xlsx", 
           row.names = FALSE)

# ------------------------------------------------------------------------------