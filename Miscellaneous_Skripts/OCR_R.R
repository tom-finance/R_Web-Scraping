################################################################################
# OCR Engine Test with R
################################################################################

library(tesseract)
library(pdftools)

# we download a PDF file from this website:
# http://www.fallimentibolzano.com/index.php?where=ultime_procedure_dichiarate_mostra_tutte&altre=

# here we download the PDF file and safe it to the local machine.

# we convert the PDF into a PNG --> check dpi settings for improving the results
pngfile <- pdftools::pdf_convert('K:/scan.pdf', dpi = 300)

# check output
pngfile[1]

setwd("K:/")

# convert PNG into text and safe in variable "text"
text <- tesseract::ocr(pngfile[2])

# show results
cat(text)

# Sources
# https://cran.r-project.org/web/packages/tesseract/vignettes/intro.html

################################################################################