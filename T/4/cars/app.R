library(shiny)
library(ggplot2)
ui <- (fluidPage(
  titlePanel(HTML('<h1>Cars</h1>
        <hr><br>
        <p>Marta Coronado Zamora<br>')),
  sidebarLayout(
    sidebarPanel(
      sliderInput("nrows",
                  "Number of rows:",
                  min = 1,
                  max = 50,
                  value = 10)
    ),
    mainPanel(
      plotOutput("carsPlot"),
      tableOutput("carsTable")
    )
  )
))

server <- function(input, output) {
  output$carsPlot <- renderPlot({
    ggplot(cars[1:input$nrows,], aes(x=speed, y=dist)) + geom_point()
  })
  output$carsTable <- renderTable({
    cars[1:input$nrows,]
  })
}
shinyApp(ui = ui, server = server)





































