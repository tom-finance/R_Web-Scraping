################################################################################
# Ita Coin Analysis
################################################################################

# load packages
library(readxl)
library(ggplot2)
library(dplyr)

################################################################################

temp <- tempfile(fileext = ".xlsx")
link <- "https://www.bancaditalia.it/statistiche/tematiche/indicatori/indicatore-ciclico-coincidente/Itacoin_it.xlsx"
download.file(link, temp, mode = "wb")

Ita_Coin <- read_excel(temp, skip = 1) %>%
  mutate(Date = as.Date(as.character(Date)))

################################################################################

# Ita Coin is a "nowcasted" GDP proxy, which might be useful to analyze Italy's
# short term economic evolution. Here wer just download the data and plot some
# of it. A deeper explenation is available on the Bank of Italy's website.

# plot Ita Coin Data
ggplot(Ita_Coin %>% 
         filter(Date > "2015-01-01"), 
       aes(x = Date, y = `Ita-coin`)) +
  ggtitle("Entwicklung Ita Coin") +
  geom_point(color = "orangered") +
  geom_line(color = "steelblue") +
  theme_minimal() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black")

################################################################################
