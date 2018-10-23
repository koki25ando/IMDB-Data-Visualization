##-------- UI Script ---------

###-------- Header ---------

header <- dashboardHeader(
  title = "IMDB Rating Analysis"
)


###-------- Sidebar ---------

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Rating Analysis", tabName = "rating_analysis", icon = icon("search")),
    menuItem("Analyze Your Data", tabName = "your_data", icon = icon("search")),
    menuItem("Information", tabName = "information", icon = icon("info"))
  )
)

###-------- Body ---------

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "rating_analysis",
      fluidRow(
        box(
          title = "Release Year",
          width = 6, height = 450,
          plotlyOutput(
            outputId = "year_hist"
          )
        ),
        box(
          title = "Movie Category",
          width = 6, height = 450,
          plotlyOutput(
            outputId = "movie_category"
          )
        ),
        box(
          title = "Overall Rating Score Comparison",
          width = 6, height = 460,
          plotlyOutput(
            outputId = "rating_score"
          )
        ),
        box(
          title = "Best Movies by Year",
          width = 6, height = 460,
          selectInput(
            inputId = "year_select", 
            label = "Select Year: ",
            selected = "2017",
            choices = year.range
          ),
          DT::dataTableOutput(
            outputId = "movies_by_year"
          )
        ),
        box(
          title = "Date Reviewed",
          width = 12, height = 450,
          plotlyOutput(
            outputId = "reviewed_month"
          )
        ),
        box(
          title = "Movies Reviewed This Month",
          width = 6, height = 450,
          plotlyOutput(
            outputId = "this_month_reviewed"
          )
        ),
        box(
          title = "Top Directors",
          width = 6, height = 450,
          plotlyOutput(
            outputId = "top_directors"
          )
        ),
        box(
          title = "Get Movie's Wallpaper",
          width = 6, height = 500,
          box(
            selectizeInput(
              label = "Type Movie's Title: ",
              inputId = "movie_title",
              choices = rating[!duplicated(rating$Title),]$Title,
              selected = "Argo"
              )),
          submitButton("Search Movie's Poster!", icon = icon("arrow-right")),
          imageOutput("img", width = "40%", height = "30%")
        ),
        box(
          title = "Movie Category",
          width = 11, height = 450,
          selectizeInput(
            inputId = "category_select",
            label = "Select Category",
            selected = "Action",
            choices = genre.option
          ),
          DT::dataTableOutput(
            outputId = "category_movie_table"
          )
        ),
        box(
          title = "Recently Reviewed",
          width = 11, height = 350,
          DT::dataTableOutput(
            outputId = "table"
          ))
      )
    ),
    tabItem(
      tabName = "your_data",
      fluidRow(
        box(
          width = 3, height = 250,
          title = "Input Your IMDb Data",
          fileInput(inputId = 'file1', label = 'Choose CSV File',
                    accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv'))
          # ,
          # submitButton(text = "Input Data", icon = icon("refresh"))
        ),
        box(
          width = 8, heiht = 400,
          title = "Overview of Data table",
          DT::dataTableOutput(
            outputId = "overview"
          )
        )
      )
    ),
    tabItem(
      tabName = "information"
    )
  )
)

##--------- Wrap Up --------

ui <- dashboardPage(header, sidebar, body)