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
  
  
###### Best Movies by year
  year.range <- rating[!duplicated(rating$Year), ][,"Year"]
  year.range <- data.frame(year.range) %>% 
    arrange(desc(year.range))
  
  best.movies.by.year <- reactive({
    rating %>% 
      filter(Year == input$year_select)
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
        ggplot(aes(Date.Rated)) +
        geom_bar(aes(group = Title,
                     text = paste0("Date Reviewed: ", Date.Rated,
                                   "<br>Title: ", Title, " (", Year, ")",
                                   "<br>Your Rating: ", Your.Rating,
                                   "<br>IMDb Rating: ", IMDb.Rating)),
                 fill = "#4F6CFF", colour = "grey") +
        theme_minimal(),
      tooltip="text"
    ) %>% 
      hide_legend()
  )
  
  # Top Directors
  output$top_directors <- renderPlotly(
    ggplotly(
      dr.rating %>% 
        filter(Num >= 4) %>% 
        ggplot(aes(x = reorder(Directors, Num), y = Num/Num, group = Title,
                   text = paste0("Director: ", Directors,
                                 "<br>Total Movies Reviewed: ", Num,
                                 "<br>Title: ", Title, " (", Year, ")",
                                 "<br>Rating Score: ", Your.Rating))) +
        geom_bar(stat = "identity", fill = "#4F6CFF") +
        coord_flip() +
        theme_minimal() +
        labs(x = "", y = "Count"),
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
  
  # output$test_output <- renderText(
  #   as.character(img())
  # )
  # 
  # # image <- reactive({
  # #   image_read(as.character(selected.poster.url))
  # # })
  
  output$img <- renderImage({
    tmpfile <- image() %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    list(src = tmpfile, contentType = "image/jpeg", 
         width = "100%", height = "100%")
  })
  
  

  
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
  infile <- reactive({
    infile <- input$datafile

    if (is.null(infile)) {
      return(NULL)
      }

    objectsLoaded <- load(input$datafile)
    return(objectsLoaded)
  })


  ## Showing first rows of data

  # myData <- reactive({
  #   objectsLoaded<-infile()
  #   if (is.null(objectsLoaded)) return(NULL)
  #   return(objectsLoaded)
  # })

  # tryCatch(
  #   {
  #     objectsLoaded <- read.csv(input$file1$datapath)
  #   },
  #   error = function(e) {
  #     # return a safeError if a parsing error occurs
  #     stop(safeError(e))
  #   }
  # )
  
  output$overview <- DT::renderDataTable(
    myData[,c(4, 2,7, 8,12,3)] %>%
      arrange(desc(Date.Rated)),
    options = list(
      lengthMenu(c(5,10))
    )
)
  
  
}
