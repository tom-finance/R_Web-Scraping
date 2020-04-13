
# Web Scraping of Emails from Website

library(rvest)

names <- "https://www.steger.bz/de/team.php" %>%
  read_html() %>%
  html_nodes(".team-ueberschrift") %>%
  html_text()

mails <- "https://www.steger.bz/de/team.php" %>%
  read_html() %>%
  html_nodes("#team-block a") %>%
  html_attr("href")

mails <- substr(mails, start = 8, stop = length(mails))

data <- data.frame(name = names,
                   mail = mails)

################################################################################