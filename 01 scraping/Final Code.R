library(httr)
library(jsonlite)
library(tidyverse)
library(rvest)


rm(list = ls())

# CSV-Datei ohne Kopfzeile einlesen
api_key_data <- read.csv("api_key.csv", header = FALSE)

# API-Schlüssel extrahieren
api_key <- api_key_data$V1[1]  # V1 ist der Standardname für die erste Spalte, wenn keine Kopfzeile vorhanden ist

# API-Endpunkt
url <- "https://content.guardianapis.com/search"

# API-Anfrage mit dem geladenen API-Schlüssel
response <- GET(url, query = list("api-key" = api_key, "q" = "Balkan", "from-date" = "1999-01-01", "page-size" = 200))

# Antwort verarbeiten
content <- content(response, "text")
print(content)


get_guardian_data <- function(page_number) {
  query_params <- list(
    "api-key" = api_key,
    "q" = "Balkan",
    "page" = page_number,
    "page-size" = 200,  # Maximal erlaubte Anzahl von Artikeln pro Seite
    "show-fields" = "body",  # Erhalte den vollständigen Artikeltext
    "from-date" = "1999-01-01"  # Ab diesem Datum
  )
  
  response <- GET(url, query = query_params)
  data <- content(response, "text", encoding = "UTF-8")
  parsed_data <- fromJSON(data)
  if (!is.null(parsed_data$response$results)) {
    # Vermeide doppelte row.names
    df <- as.data.frame(parsed_data$response$results)
    rownames(df) <- NULL
    return(df)
  } else {
    return(data.frame())  # Gibt leeren DataFrame zurück, wenn keine Ergebnisse
  }
}

# Daten sammeln und zusammenführen
all_pages <- lapply(1:10, get_guardian_data)  # Beispiel: Erste 10 Seiten abrufen
all_articles <- bind_rows(all_pages)


# Überprüfe die ersten paar Einträge in der 'fields'-Spalte
if (!is.null(all_articles$fields) && length(all_articles$fields) > 0) {
  print(str(all_articles$fields[1]))
}

# Extrahieren des Textes aus der 'body' Spalte
all_articles$body_text <- all_articles$fields$body
