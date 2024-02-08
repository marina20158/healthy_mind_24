library (shiny)
library (leaflet)
               
# UI
ui <- fluidPage(
  tags$head(tags$script(src = "index.html")),
  titlePanel("HEALTHY MIND"),              # title of the web-page 
  
  sidebarLayout(
    sidebarPanel(
      downloadButton("downloadButton", "download") # add download button 
    ),
    
    mainPanel(
      leafletOutput("map"), # map output
      
      tags$p(" Mental Helath encompasses emotional, psychological and social well-being, influencing cognition, perception, and behavior. 
               According to WHO, it is a state of well-being in which the individual realizes his or her abilities, can cope with the normal stresses of life, can work productively and fruitfully, and can contribute to his or her community. If you feel that you are not very well, know that you are not alone ! Moreover, you can show a little courage and curiosity and participate in our pilot program. The map above shows the distribution of BRAVE SOULS who have already joined.. 
             ") # paragraph with text
    )
  )
)

# Server
server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%                                           # render a map 
      addTiles() %>%                                        # add tiles (map background)
      addMarkers(data = eligible_patients,lat= ~lat, lng= ~lon)    # add patient labels to the map
  })
  
  map <- reactive({
    leaflet(options = leafletOptions(zoomControl = FALSE)) %>% 
      setView(lat= ~lat, lng= ~lon) %>% 
      addTiles ()                                                # create a reactive map with labels
  })
  
  observeEvent(input$downloadButton, {
    map_file <- "map.html"               # the name of the file where the map will be saved
    saveWidget(map(), file = map_file)
    
    # call the function to download the file
    session$sendCustomMessage(
      type = "download",
      list(
        url = map_file,
        rename = "map.html",
        contentType = "text/html"
      )
    )
  })
  
}

# Launching the application 
shinyApp(ui, server)
