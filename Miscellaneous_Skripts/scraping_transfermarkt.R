# all transfers from 2018/19

library(rvest)
library(dplyr)

################################################################################

# first we create our urls

# first url

url_1 <- "https://www.transfermarkt.de/spieler-statistik/wertvollstespieler/marktwertetop?ajax=yw1&altersklasse=alle&ausrichtung=alle&jahrgang=0&land_id=0&plus=1&spielerposition_id=alle"

# construct furter links

pages <- 2:20

basic <- "https://www.transfermarkt.de/spieler-statistik/wertvollstespieler/marktwertetop?ajax=yw1&altersklasse=alle&ausrichtung=alle&jahrgang=0&land_id=0&plus=1&spielerposition_id=alle&page="

links <- paste(basic, pages, sep = "")

links <- c(url_1, links)

# ------------------------------------------------------------------------------

# loop over, store and bind to one single data.frame!

results <- list()

for (i in 1:length(links)) {
  
  daten <- read_html(links[i])
  
  results[[i]] <- daten %>%
    html_node("table.items") %>%
    html_table(header = TRUE, fill=TRUE)
  
  print(i)
  
}

# create final data.frame with all results!

finale <- do.call(rbind.data.frame, results)


n <- 1:18

names <- paste("variable_", n, sep = "")

colnames(finale) <- names

# ------------------------------------------------------------------------------

hoi <- finale %>%
  filter(!is.na(variable_1)) %>%
  select(-c(variable_2, variable_3, variable_7, variable_8))

# now check problem with market value!

test <- strsplit(hoi$variable_9, split = " ", fixed = TRUE)

finale1 <- do.call(rbind.data.frame, test)

colnames(finale1) <- c("var1", "var2", "var3")

hoi$marktwert <- as.numeric(gsub(",", ".", gsub("\\.", "", finale1$var1)))

write.csv2(hoi, "daten.csv")

# ------------------------------------------------------------------------------

# start with data analysis

hist(hoi$marktwert)

hist(hoi$variable_6)

hist(hoi$variable_10)



cor(hoi$variable_10, hoi$variable_11)

test <- log(hoi$marktwert)

model1 <- lm(test ~ hoi$variable_10+hoi$variable_11+hoi$variable_12+hoi$variable_13+factor(hoi$variable_5))

summary(model1)

exp(model1$fitted.values)


test <- data.frame(fitted = exp(model1$fitted.values),
                   actual = hoi$marktwert)


hoi %>%
  group_by(variable_5) %>%
  summarise(anzahl = median(variable_6)) %>%
  arrange(desc(anzahl))


boxplot(hoi$marktwert ~ hoi$variable_5)

boxplot(hoi$variable_11 ~ hoi$variable_5)

################################################################################

link <- "https://www.transfermarkt.de/transfers/saisontransfers/statistik?land_id=0&ausrichtung=&spielerposition_id=&altersklasse=&leihe=&plus=1"

daten <- read_html(link)


ergebnis <- daten %>%
  html_node("table.items") %>%
  html_table(header = TRUE, fill=TRUE)

colnames(ergebnis) <- paste("variable_", 1:17, sep = "")

hoi <- ergebnis %>%
  filter(!is.na(variable_1)) %>%
  select(-c(variable_2, variable_3, variable_8, variable_9, variable_10, variable_14)) %>%
  filter(!grepl("Leihgeb?hr|Leihe",variable_17)) %>%
  replace(.=="abl?sefrei", 0)


# ------------------------------------------------------------------------------

# now use loop!

url_scrape <- paste("https://www.transfermarkt.de/transfers/saisontransfers/statistik?ajax=yw1&altersklasse=&ausrichtung=&land_id=0&leihe=&plus=1&spielerposition_id=&page=", 2:30, sep = "")
  
url_final <- c(link, url_scrape)

results <- list()

for (i in 1:length(url_final)) {
  
  daten <- read_html(url_final[i])
  
  results[[i]] <- daten %>%
    html_node("table.items") %>%
    html_table(header = TRUE, fill=TRUE)
  
  print(i)
  
}

# create final data.frame with all results!

ergebnis <- do.call(rbind.data.frame, results)

colnames(ergebnis) <- paste("variable_", 1:17, sep = "")

hoi <- ergebnis %>%
  filter(!is.na(variable_1)) %>%
  select(-c(variable_2, variable_3, variable_8, variable_9, variable_10, variable_14)) %>%
  filter(!grepl("Leihgeb?hr|Leihe|-",variable_17)) %>%
  replace(.=="abl?sefrei", 0)

# -----------------------

# split string to numeric

test <- strsplit(hoi$variable_17, split = " ", fixed = FALSE)

finale1 <- do.call(rbind.data.frame, test)

colnames(finale1) <- c("var1", "var2", "var3")

hoi$fee <- as.numeric(gsub(",", ".", gsub("\\.", "", finale1$var1)))



summary(hoi$fee)

hoi %>%
  filter(fee >100)

