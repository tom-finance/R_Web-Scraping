################################################################################
# Download File from Prometeia Website
################################################################################

library(rvest)
library(httr)

# a bit tricky because of HTTP Basic Access Authentification but should work!

url <- GET(url = "http://www.risksize.com/RiskSize/down_base/Matrici",
            authenticate(user = "USER", password = "PW")) %>%
  read_html() %>%
  html_node(".testopicc:nth-child(1) .linkpicc-bold") %>%
  html_attr("href")

# download file
download.file(url, destfile = "test.zip", mode = "wb")

# ------------------------------------------------------------------------------
