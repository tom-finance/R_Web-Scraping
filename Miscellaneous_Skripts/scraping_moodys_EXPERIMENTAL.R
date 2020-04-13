
# https://www.moodys.com/credit-ratings/Cassa-Centrale-Raiffeisen-SpA-credit-rating-600069654


library(rvest)
url <- "https://www.moodys.com/credit-ratings/Cassa-Centrale-Raiffeisen-SpA-credit-rating-600069654"
session <-html_session(url)
form <-html_form(session)[[1]]

# this guy seems to wo

filled_form <- set_values(form,
                          `MdcUserName` = "Thomas.Ludwig@raiffeisen.it", 
                          `MdcPassword` = "Bolzano2019")

submit_form(session, filled_form)

url_2 <- jump_to(session, "https://www.moodys.com/credit-ratings/Cassa-Centrale-Raiffeisen-SpA-credit-rating-600069654")

spinning <- read_html(url_2)

# data <- spinning %>%
#   html_nodes(".mdcAGHeader") %>%
#   html_text()


population <- url_2 %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="Corporate"]/div[1]/div[2]')

html_children()

spinning[[2]]

# next, we have to submit the form and to select the CSS selector for scraping the website
# if you run it in a loop be careful to work with system.sleep

# ------------------------------------------------------------------------------

# THIS IS SOME SAMPLE CODE - NOT USED NOR TESTED!!

start_table <- submit_form(session, filled_form) %>%
  jump_to(url from which to scrape first table within quotes) %>%
  html_node("table.inlayTable") %>%
  html_table()
data_table <- start_table

for(i in 1:nrow(data_ids))
{
  current_table <- try(submit_form(session, filled_form) %>%
                         jump_to(paste(first part of url within quotes, data_ids[i, ], last part of url within quotes, sep="")) %>%
                         html_node("table.inlayTable") %>%
                         html_table())
  
  data_table <- rbind(data_table, current_table)
}

# ------------------------------------------------------------------------------

# taken from this post:
# https://stackoverflow.com/questions/35108711/r-using-rvest-to-scrape-a-password-protected-website-without-logging-in-at-eac
# https://stackoverflow.com/questions/30146723/rvest-unknown-field-names-when-attempting-to-set-form

# ------------------------------------------------------------------------------

TRY
