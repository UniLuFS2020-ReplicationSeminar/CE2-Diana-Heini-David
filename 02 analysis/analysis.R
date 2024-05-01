all_articles <- read.csv("balkan_data.csv", header = TRUE)

#Count the keywords "war" and "tourism" in the articles
all_articles$war_count <- str_count(all_articles$body_text, regex("\\bWar\\b", ignore_case = TRUE))
all_articles$tourism_count <- str_count(all_articles$body_text, regex("\\bTourism\\b", ignore_case = TRUE))

# Combined count
total_war <- sum(all_articles$war_count, na.rm = TRUE)
total_tourism <- sum(all_articles$tourism_count, na.rm = TRUE)

#Results
cat("Total mentions of 'War':", total_war, "\n")
cat("Total mentions of 'Tourism':", total_tourism, "\n")

# Total mentions of 'War': 5603 
# War arcticles 992 obs

# Total mentions of 'Tourism': 469
# Tourism arcticles 147 obs

# Code for check up
war_articles <- all_articles[grep("\\bWar\\b", all_articles$body_text, ignore.case = TRUE), ]

tourism_articles <- all_articles[grep("\\bTourism\\b", all_articles$body_text, ignore.case = TRUE), ]

# Create a plot of the number of articles mentioning "war" and "tourism" by the article date

#parsing the date

war_articles$webPublicationDate <- as.Date(war_articles$webPublicationDate)
tourism_articles$webPublicationDate <- as.Date(tourism_articles$webPublicationDate)

#counting the number of articles by date
war_articles <- war_articles %>% group_by(webPublicationDate) %>% summarise(count = n())
tourism_articles <- tourism_articles %>% group_by(webPublicationDate) %>% summarise(count = n())

#draw a histogram of number of articles by date

ggplot() +
  geom_line(data = war_articles, aes(x = webPublicationDate, y = count, color = "War")) +
  geom_line(data = tourism_articles, aes(x = webPublicationDate, y = count, color = "Tourism")) +
  labs(title = "Number of articles by date", x = "Date", y = "Number of articles") +
  scale_color_manual(values = c("War" = "red", "Tourism" = "blue")) +
  theme_minimal()






