library(httr)
library(jsonlite)
library(tidyverse)
library(rvest)
library(stringr)

#reading the api key from a csv file
api_key_data <- read.csv("api_key.csv", header = FALSE)

#extracting the api key from the first column
api_key <- api_key_data$V1[1]

#storing the API endpoint to a variable
url <- "https://content.guardianapis.com/search"

#retrieving all the articles with a keyword through the API

get_guardian_data <- function(page_number) {
  query_params <- list(
    "api-key" = api_key,
    "q" = "Balkan",
    "page" = page_number,
    "page-size" = 200,  # MAx articles per request
    "show-fields" = "body",  # Getting the whole text
    "from-date" = "1999-01-01"  # From this date
  )
  
  response <- GET(url, query = query_params)
  data <- content(response, "text", encoding = "UTF-8")
  parsed_data <- fromJSON(data)
  if (!is.null(parsed_data$response$results)) {
    # Avoiding double row names
    df <- as.data.frame(parsed_data$response$results)
    rownames(df) <- NULL
    return(df)
  } else {
    return(data.frame())  # Gives an empty data frame when there's no response
  }
}

#Gathering the needed data
all_pages <- lapply(1:10, get_guardian_data)  #first 10 pages
all_articles <- bind_rows(all_pages)

#Checking if it worked by looking at the first article
str(all_articles$fields[1])

#Extracting the texts from the body field
all_articles$body_text <- all_articles$fields$body

#checking how it looks
all_articles$body_text[1]





