library(httr)
library(magrittr)

getTimestamps <- function(dayByTime) {
  dayByTime %>%
    as.data.frame  %>%
    dplyr::rename(day = Var1, time = Var2) %>%
    dplyr::mutate(timestampStr = paste0("2016-11-", day, " ", time, ":00 CET")) %>%
    dplyr::mutate(timestamp = as.numeric(as.POSIXct(timestampStr)))
}

departureMorning <- expand.grid(seq(7, 11), c("7:30", "8:30", "9:30")) %>% getTimestamps
departureEvening <- expand.grid(seq(7, 11), c("16:30", "17:30", "18:30")) %>% getTimestamps

travelTime <- function(from, to, departure_time = "now") {
  apiKey <- "AIzaSyDZGiJe31vB1ttMrCLlV-kvEowKCeOVzM8"
  apiParts <- list("https://maps.googleapis.com/maps/api/distancematrix/json?")
  apiParts <- c(apiParts, "origins=", from$lat, ",", from$lng)
  apiParts <- c(apiParts, "&destinations=", to$lat, ",", to$lng)
  apiParts <- c(apiParts, "&departure_time=", departure_time)
  apiParts <- c(apiParts, "&mode=transit")
  apiParts <- c(apiParts, "&key=", apiKey)
  apiURL <- do.call(paste0, apiParts)

  request <- GET(url = apiURL)
  content(request)$rows[[1]]$elements[[1]]$duration$text
}

podchorazych = list(lat = 52.209179, lng = 21.0342572)
leszno = list(lat = 52.2387176, lng = 20.9788261)
listopada =  list(lat = 52.215298, lng = 21.0405653)

# travelTime(podchorazych, leszno)
# travelTime(podchorazych, listopada)
# travelTime(listopada, leszno)
