
# Zählen der Wörter 'War' und 'Tourism' unter Ignorierung der Groß-/Kleinschreibung
all_articles$war_count <- str_count(all_articles$body_text, regex("\\bWar\\b", ignore_case = TRUE))
all_articles$tourism_count <- str_count(all_articles$body_text, regex("\\bTourism\\b", ignore_case = TRUE))

# Gesamtzählungen
total_war <- sum(all_articles$war_count, na.rm = TRUE)
total_tourism <- sum(all_articles$tourism_count, na.rm = TRUE)

# Ausgabe
cat("Total mentions of 'War':", total_war, "\n")
cat("Total mentions of 'Tourism':", total_tourism, "\n")

# Total mentions of 'War': 5603 
# War arcticles 992 obs

# Total mentions of 'Tourism': 469
# Tourism arcticles 147 obs

# Code for check up
war_articles <- all_articles[grep("\\bWar\\b", all_articles$body_text, ignore.case = TRUE), ]

tourism_articles <- all_articles[grep("\\bTourism\\b", all_articles$body_text, ignore.case = TRUE), ]