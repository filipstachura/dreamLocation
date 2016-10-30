library(shiny)
library(leaflet)
library(semanticui)

source("./dreamLocation.R")

jsCode <- "
$('.ui.dropdown').dropdown({});
$('.rating').rating('setting', 'clearable', true);
$('.disabled .rating').rating('disable');
"

ui <- function() {
  shinyUI(semanticPage(
    style="min-height: 100%;",
    shinyjs::useShinyjs(),
    div(class = "ui grid",
        div(class = "three wide column",
            div(class = "ui raised segment",
                a(class="ui green ribbon label", "Kamila"),
                p(),
                DT::dataTableOutput("kamilaRaw")
                )
        ),
        div(class = "ten wide column",
         leaflet::leafletOutput("warsawMap")
        ),
        div(class = "three wide column",
            div(class = "ui raised segment",
                a(class="ui green ribbon label", "Filip"),
                p(),
                textOutput("filipRaw")
                )
        )
    )
  ))
}

server <- shinyServer(function(input, output) {

   output$kamilaRaw <- DT::renderDataTable({
     clicked <- input$warsawMap_click

     departureMorning %>%
       dplyr::mutate(travel = timestamp %>% purrr::map(~ travelTime(clicked, leszno, .))) %>%
       dplyr::select(day, time, travel) %>%
       spread(time, travel) %>%
       DT::datatable()
   })
   output$filipRaw <- renderText({
     clicked <- input$warsawMap_click
     times <- list(travelTime(clicked, listopada))

     do.call(paste, times)
   })


   output$warsawMap <- leaflet::renderLeaflet({
     map <- leaflet::leaflet() %>%
       leaflet::addProviderTiles("CartoDB.Positron") %>%
       addMarkers(lng = c(leszno$lng), lat = c(leszno$lat)) %>%
       addMarkers(lng = c(listopada$lng), lat = c(listopada$lat))

     if (!is.null(input$warsawMap_click)) {
       clicked <- input$warsawMap_click
       map %>%
         addMarkers(lng = c(clicked$lng), lat = c(clicked$lat), icon = makeIcon("markers/red.png", iconWidth = 18, iconHeight = 18))
     } else {
       return(map)
     }
   })
})

shinyApp(ui = ui, server = server)

