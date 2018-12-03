##-------- Server Script ---------

server <- function (input, output){
  
  ## Release Year Histogram
  output$year_hist <- renderPlotly(
    ggplotly(
      rating %>% 
        group_by(Year) %>% 
        mutate(Year_Count = sum(Year)/Year) %>% 
        ggplot(aes(Year)) +
        geom_histogram(aes(text = paste0("Year: ", Year,
                                         "<br>Count: ", Year_Count)),
                       binwidth = 1, fill = "#4F6CFF") +
        theme_minimal(),
      tooltip="text")
  )

  ## Movie Category Pie Chart
  output$movie_category <- renderPlotly(
    plot_ly(as.data.frame(table(Genres.tidy$Genre))[-1,], 
            labels = ~Var1, values = ~Freq, type = 'pie', 
            textposition = "inside") %>%
      layout(title = 'Movie Genres',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  )
  
  
  ## Rating Score Scatter Plot
  output$rating_score <- renderPlotly(
    plot_ly(data = rating, 
            x = ~IMDb.Rating, y = ~Your.Rating,
            hoverinfo = "text",
            text = ~paste0("Title: ", Title,
                           "<br>Director: ", Directors,
                           "<br>IMDb Rating: ", IMDb.Rating,
                           "<br>Your Rating: ", Your.Rating))
  )
  
  
###### Best Movies by year
  
  best.movies.by.year <- reactive({
    rating %>% 
      filter(Year == as.numeric(input$year_select))
  })
  
  output$movies_by_year <- DT::renderDataTable(
    best.movies.by.year()[,c(4, 2,7,9)] %>% 
      arrange(desc(Your.Rating), desc(IMDb.Rating)),
    options = list(
      lengthMenu = c(5, 10)
    )
  )
  
  ## Date Reviewed
  
  output$reviewed_month <- renderPlotly(
    data.frame(table(rating$Review_YearMonth)) %>% 
      plot_ly(x = ~Var1, y = ~Freq, type = "bar",
              hoverinfo = "text",
              text = ~paste0("Year-Month: ", Var1,
                             "<br>Count: ", Freq)) %>% 
      layout(yaxis = list(title = "Count"),
             xaxis = list(title = ""))
  )
  
  ## This Month's Review
  
  output$this_month_reviewed <- renderPlotly(
    ggplotly(
      rating %>%
        filter(Review_YearMonth == max(rating$Review_YearMonth)) %>% 
        ggplot(aes(x = Date.Rated, y = Run_Mins, group = Title, 
                   fill = Your.Rating)) +
        geom_bar(aes(text = paste0("Date Reviewed: ", Date.Rated,
                                   "<br>Title: ", Title, " (", Year, ")",
                                   "<br>Your Rating: ", Your.Rating,
                                   "<br>Run Minutes: ", Run_Mins, " Minutes")),
                 stat = "identity", colour = "grey") +
        theme_minimal() +
        labs(fill = "Rating", y = "Minutes"),
      tooltip="text"
    )
    )
  
  # Top Directors
  output$top_directors <- renderPlotly(
    ggplotly(
      dr.rating %>% 
        filter(Num >= 4) %>% 
        ggplot(aes(x = reorder(Directors, Num), y = Num/Num, group = Title,
                   fill = Your.Rating,
                   text = paste0("Director: ", Directors,
                                 "<br>Total Movies Reviewed: ", Num,
                                 "<br>Title: ", Title, " (", Year, ")",
                                 "<br>Rating Score: ", Your.Rating))) +
        geom_bar(stat = "identity"
                 # , fill = "#4F6CFF"
                 ) +
        coord_flip() +
        theme_minimal() +
        labs(fill = "Rating", x = "", y = "Count"),
      tooltip="text"
    )
  )
  
  
  ## Movie Poster
  
  image <- reactive({
    selected.movie <- rating %>% 
      filter(Title == as.character(input$movie_title))
    selected.poster.url <- read_html(as.character(selected.movie[,5])) %>% 
      html_nodes("div.poster") %>%
      html_nodes("img") %>%
      html_attr("src") %>% 
      as.character()
    image_read(selected.poster.url)
  })
  
  ## Rating Score Histogramr
  
  output$score_hist <- renderPlotly(
    ggplotly(
      rating %>% 
        group_by(Your.Rating) %>% 
        mutate(Rating.Count = sum(Your.Rating)/Your.Rating) %>% 
        ggplot(aes(Your.Rating)) +
        geom_histogram(aes(text = paste0(
          "Rating Score: ", Your.Rating,
          "<br>Movie Count: ", Rating.Count
        )),
        binwidth = 1, fill = "#4F6CFF") +
        theme_minimal(),
      tooltip="text"
    )
  )
  
  output$img <- renderImage({
    tmpfile <- image() %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = tmpfile, contentType = "image/jpeg", 
         width = "100%", height = "100%")
  })
  
  ## Poster Download
  
  # output$poster_download <- downloadHandler(
  #   filename = function() {
  #     paste0(as.character(input$movie_title), "_poster.png")
  #   },
  #   content = function(file) {
  #     png(file)
  #     print(img())
  #     dev.off()
  #   }
  # )
  
  
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
  
  
# ### Analyze User's Data
#   
  ## Data Input
  external_data <- reactive({
  require(input$file1)
  if (is.null(input$file1))
    return(NULL)
  
  # data.table::fread(input$file1$datapath, header = input$header)
  read.csv(input$file1$datapath, header = input$header)
  })
  
  output$contents <- DT::renderDataTable(
    external_data(),
    options = list(
      lengthMenu = c(2, 5, 10)
    )
  )
  
}
