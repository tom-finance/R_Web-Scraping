
# Extract Tables from PDF

# ------------------------------------------------------------------------------

# This would be the target pdf file available on the www:
# https://www.sec.gov/divisions/investment/13f/13flist2019q1.pdf

# complete list with all historical data:
# https://www.sec.gov/divisions/investment/13flists.htm

# ------------------------------------------------------------------------------

# install.packages("tabulizer")

library(tabulizer) # extract from pdf
library(xlsx) # write Excel files
library(readxl) # read Excel files
library(pdftools) # extract PDF information, e.g. number of pages

# ------------------------------------------------------------------------------

# path to file of interest
f1 <- "13fq2.pdf"

# extract number of pages
n_pages <- pdf_info(f1)$pages

# locate areas in PDF file
check <- locate_areas(f1, 3) # use page 3

tab <- extract_tables(f1, 
                      pages = 3:(n_pages-1), # we exclude last page and do it later by hand
                      output = "data.frame", 
                      guess = FALSE, # don't use algorithm for table detection
                      area = check) # use area provided by user

# check whether dimensions are equal to 5
dimensions <- sapply(tab,  FUN = function(x) dim(x)[2] == 5)

# check what is wrong with this guys
mean(dimensions)


# ------------------------------------------------------------------------------

dimensions_wrong <- sapply(tab,  FUN = function(x) dim(x)[2]) != 5

# which indices are problematic?
which(dimensions_wrong)

##########################

mod_col <- function(x) {
  
  `%notin%` <- Negate(`%in%`)
  
  if("X.1" %in% colnames(x))
  {
    x$X.1 <- NULL
  }
  
  if("X" %notin% colnames(x))
    
  {
    x$X <- " "
    x <- x[, c(1,5,2,3,4)]
  }
  
  return(x)
}

#############################

# clean data
tab <- lapply(tab, mod_col)


# check again if everything is ok!
mean(sapply(tab,  FUN = function(x) dim(x)[2] == 5))

# ------------------------------------------------------------------------------

# create final data.frame by adding everything together!
final <- do.call(rbind.data.frame, tab)

# eliminate NA with empty string
final$STATUS[is.na(final$STATUS)] <- " "

# we compare the final number of rows with the indicated number to verify that
# we have everything. Number matches - we are ok!

check_last <- locate_areas(f1, n_pages) # use page 3

tab_last <- extract_tables(f1, 
                      pages = n_pages, # we exclude last page and do it later by hand
                      output = "data.frame", 
                      guess = FALSE, # don't use algorithm for table detection
                      area = check_last)[[1]] # use area provided by user

tab_last$STATUS <- " "
tab_last <- tab_last[-nrow(tab_last), ]
colnames(tab_last) <- colnames(final)

# merge rest together

final <- rbind(final, tab_last)

# ------------------------------------------------------------------------------

# write result to csv file

write.csv2(final, 
           "13fq2.csv", 
           row.names = FALSE)

file.show("13fq2.csv")

# we are done for this quarter!

################################################################################