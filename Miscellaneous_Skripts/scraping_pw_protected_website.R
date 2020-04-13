################################################################################
# Web Scraping from PW protected website
################################################################################

# ------------------------------------------------------------------------------

# load packages

library(rvest)
library(httr)

# ------------------------------------------------------------------------------

# actual scraping starting here!
# target site: https://www.traintosmile.com/

# url to login page
url <- "https://www.traintosmile.com/wp-login.php?redirect_to=https%3A%2F%2Fwww.traintosmile.com%2Fwp-admin%2F&reauth=1"

url <- "https://me.traintosmile.com/"


# start html session
session <- html_session(url)

# get login form
form <- html_form(session)[[1]]

# fill form with user and pw
filled_form <- set_values(form,
                          log = "Innsbruck2019",
                          pwd = "Innsbruck2019")

# submit form --> Status 200 means log-in request was succesful
submit_form(session, filled_form)

# now go to site with information of interest
url_2 <- jump_to(session, "https://www.traintosmile.com/iscrizione-ai-corsi/")

# read html of site of interest
spinning <- read_html(url_2)

# extract html table as data frame
data <- spinning %>%
  html_node("table.easy-table") %>%
  html_table(header = TRUE)

# inspect result and some basic plotting

# change format into date format for plotting
data$Data <- as.Date(data$Data, "%Y-%m-%d")

plot(data$Iscritti/data$Posti, 
     type = "l", 
     main = "booked/available ratio", ylab = "ratio", xlab = "event")
abline(h = mean(data$Iscritti/data$Posti), col = "blue")

# ------------------------------------------------------------------------------

# useful links:

# https://stackoverflow.com/questions/43700708/using-rvest-to-scrape-a-website-w-a-login-page

# ------------------------------------------------------------------------------