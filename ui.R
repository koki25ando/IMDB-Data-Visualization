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
          title = "Recently Reviewed",
          width = 10, height = 350,
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