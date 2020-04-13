
# Munich Appartment Rent Analysis inclusive Web Scraping Analysis

# ------------------------------------------------------------------------------

# packages

library(dplyr) # data manipulation
library(rvest) # web scraping
library(readr) # string manipulation
library(stringr) # string manipulation
library(rlist) # string manipulation

# ------------------------------------------------------------------------------

# reference website for web scraping
# https://www.immobilienscout24.de/Suche/S-T/P-559/Wohnung-Miete/archiv/Bayern/Muenchen

# create links for all apparments in Munich from Immoscout24 website

# to do: adapt the 600 to dynamic code + add first page!
links <- paste("https://www.immobilienscout24.de/Suche/S-T/P-", 2:628, "/Wohnung-Miete/archiv/Bayern/Muenchen", sep = "")


result <- list()

#run loop over created websites
for (i in 1:length(links)) {
  
  link <- read_html(links[i])
  
  result[[i]] <- link %>%
    # extract HTML node
    html_nodes(".font-nowrap.font-line-xs , #result-96579021 .font-line-xs, .font-line-xs .onlyLarge") %>%
    # convert to text
    html_text()
  
  print(i)
}

# delete everything which contains Zi
result <- lapply(result, FUN = function(x) x[!str_detect(x,pattern="Zi")])

# filter correct datasets
cond <- sapply(result, FUN = function(x) (length(x)/3) %% 1==0)
result <- result[cond]

# create data.frame in each list from 1...N
test <- lapply(result, FUN = function(x) as.data.frame(split(x, 1:3)))

# create large data.frame from all lists
finale <- do.call(rbind.data.frame, test)

# -------------------------

# now we need some additiona cleaning...

# to character
finale$X1 <- as.character(finale$X1)

# comma and point are wrong
finale$X1 <- gsub(",", ".", gsub("\\.", "", finale$X1))
finale$X2 <- gsub(",", ".", gsub("\\.", "", finale$X2))
finale$X3 <- as.numeric(gsub(",", ".", gsub("\\.", "", finale$X3)))

# as numeric (delete Euro sign)
finale$X1 <- parse_number(finale$X1)
finale$X2 <- parse_number(finale$X2)

# construct variable: price/qm

finale$qm <- finale$X1/finale$X2


# some basic plotting

hist(finale$X1[finale$X1<5000], breaks = 50, main = "Verteilung Miete")

hist(finale$X2[finale$X2<200], breaks = 50, main = "Verteilung QM")


hist(finale$qm, breaks = 50)

# count for barplot
counts <- table(finale$X3)

barplot(counts, main = "Zimmer/Wohnung", col = "green")

# preis als function von anzahl zimmer

boxplot_test <- finale[finale$X3 <5, -2]
boxplot_test <- boxplot_test[boxplot_test$X1 <5000, ]

boxplot_test <- boxplot_test %>%
  filter(!X3 %in% c(1.4, 2.2))

boxplot(X1 ~ X3, data = boxplot_test, main = "Boxplot Mieten vs. Zimmer")
abline(h = 1000, col = "red")

boxplot(X1 ~ X3, data = finale, main = "Boxplot Mieten vs. Zimmer")

# save data
setwd("C:/Users/User/Desktop")
write.csv2(finale, "mieten_MUC.csv")

# ------------------------------------------------------------------------------

# fit linear regression model with two independent variables

# transformy Y with logarithm --> more variance
plot(log(finale$X1) ~ finale$X2, col = "red")

model1 <- lm(log(X1) ~ X2 + X3, data = finale)
summary(model1)

# residual analysis

plot(model1)

# Now I would need to perform an out of the sample prediction

# Text Analysis of the titles..

# ------------------------------------------------------------------------------