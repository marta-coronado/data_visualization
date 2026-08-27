library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

chic <- read.csv("nmmaps-data2022_12_8D13_4_0.csv")
chic$date <- as.Date(chic$date)

ui <- fluidPage(

  titlePanel(" Chicago Daily Deaths Explorer"),

  sidebarLayout(

    sidebarPanel(

      selectInput(
        inputId  = "xvar",
        label    = "Enviromental variable:",
        choices  = c("pm10", "o3", "temp"),
        selected = "temp"
      ),

      checkboxGroupInput(
        inputId  = "seasons",
        label    = "Filter by season:",
        choices  = c("Winter", "Spring", "Summer", "Autumn"),
        selected = c("Winter", "Spring", "Summer", "Autumn")
      )
    ),

    mainPanel(
      plotOutput("main_plot"),

      hr(),

      dataTableOutput("table")
    )
  )
)

server <- function(input, output, session) {

  output$main_plot <- renderPlot({

    df <- chic %>% filter(season %in% input$seasons)
    
    xvar <- input$xvar

    p <- ggplot(df, aes(x = .data[[xvar]], y = death)) +
      
      geom_point(aes(color = .data[[xvar]]), alpha = 0.5) +
      
      geom_smooth(method = "lm", color = "firebrick4") +
      
      facet_wrap(~ season) +
      
      scale_color_viridis_c(option = "plasma") +
      labs(
        y = "Daily deaths",
        caption = "Source: NMMAPS dataset"
      ) +
      theme_bw() +
      theme(
        legend.position = "bottom",
      )
    p
  })

  output$table <- renderDataTable({

    df <- chic %>% filter(season %in% input$seasons)
    df
  })
}

shinyApp(ui = ui, server = server)
