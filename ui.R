##-------- UI Script ---------

###-------- Header ---------

header <- dashboardHeader(
  title = "IMDB Rating Analysis"
)


###-------- Sidebar ---------

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Rating Analysis", tabName = "rating_analysis", icon = icon("search")),
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
          title = "Overall Rting Score Comparison",
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
      tabName = "information"
    )
  )
)

##--------- Wrap Up --------

ui <- dashboardPage(header, sidebar, body)