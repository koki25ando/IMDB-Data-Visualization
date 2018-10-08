##-------- Server Script ---------

server <- function (input, output){
  
  output$year_hist <- renderPlotly(
    ggplotly(
      rating %>% 
        ggplot(aes(Year)) +
        geom_histogram(binwidth = 1, fill = "#4F6CFF") +
        theme_minimal())
  )
  
  output$movie_category <- renderPlotly(
    plot_ly(as.data.frame(table(Genres.tody$Genre))[-1,], 
            labels = ~Var1, values = ~Freq, type = 'pie', 
            textposition = "inside") %>%
      layout(title = 'Movie Genres',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  )
  
  output$table <- DT::renderDataTable(
    rating[,c(4, 2,7, 8,12,3)] %>% 
      arrange(desc(Date.Rated)),
    options = list(
      lengthMenu = c(5, 10)
    )
  )
  
}
