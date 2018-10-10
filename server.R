##-------- Server Script ---------

server <- function (input, output){
  
  output$year_hist <- renderPlotly(
    ggplotly(
      rating %>% 
        ggplot(aes(Year)) +
        geom_histogram(aes(text = paste0("Year: ", Year,
                                         "<br>Count: ")),
                       binwidth = 1, fill = "#4F6CFF") +
        theme_minimal(),
      tooltip="text")
  )
  
  output$movie_category <- renderPlotly(
    plot_ly(as.data.frame(table(Genres.tidy$Genre))[-1,], 
            labels = ~Var1, values = ~Freq, type = 'pie', 
            textposition = "inside") %>%
      layout(title = 'Movie Genres',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  )
  
  output$rating_score <- renderPlotly(
    plot_ly(data = rating, 
            x = ~IMDb.Rating, y = ~Your.Rating,
            hoverinfo = "text",
            text = ~paste0("Title: ", Title,
                           "<br>IMDb Rating: ", IMDb.Rating,
                           "<br>Your Rating: ", Your.Rating))
  )
  
  rating.category <- reactive({
    rating %>% 
      filter(grepl(as.character(input$category_select), Genres))
  })
  
  output$category_movie_table <- DT::renderDataTable(
    rating.category()[,c(4, 2,7, 8,12,3)] %>% 
      arrange(desc(Your.Rating), desc(IMDb.Rating)),
    options = list(
      lengthMenu = c(5, 10)
    )
  )
  
  
  
  output$table <- DT::renderDataTable(
    rating[,c(4, 2,7, 8,12,3)] %>% 
      arrange(desc(Date.Rated)),
    options = list(
      lengthMenu = c(5, 10)
    )
  )
  
}
