library(shiny)
if(!require("reshape")) install.packages("reshape")
library(reshape)

# Showcase of simple to advanced Shiny visualizations and dashboards: https://shiny.posit.co/r/gallery/
# More info on hosting your own Shiny server: https://shiny.posit.co/r/deploy

# Read in truthed data
data = read.csv("https://raw.githubusercontent.com/atet/ml_maneuver/main/dat/turns.csv")

# Data format conversion for plotting
data$id = 1:nrow(data)
data_ls = split(data, data$id)
data2 = do.call(rbind, lapply(data_ls, function(x){ # x = data_ls[[1]]
  id = x[1,15]
  label = x[1,1]
  speed = x[1,2]
  distance = x[1,3]
  split = x[1,14]
  subset = data.frame(
    x = c(x[1,4], x[1,6], x[1,8], x[1,10], x[1,12]),
    y = c(x[1,5], x[1,7], x[1,9], x[1,11], x[1,13]),
    stringsAsFactors = FALSE
  )
  subset$id = id
  subset$label = label
  subset$speed = speed
  subset$distance = distance
  subset$split = split
  return(subset)
}))

# Define UI for application that draws a line plot
ui <- fluidPage(
  
  # Application title
  titlePanel("Visualizing Training and Test Truthed Data"),
  
  # Sidebar with a slider input for data set ID 
  sidebarLayout(
    sidebarPanel(
      sliderInput("id",
                  "Data Set ID:",
                  min = 1,
                  max = 50,
                  value = 1)
    ),
    
    # Show a plot of the X and Y coordinates
    mainPanel(
      plotOutput("linePlot")
    )
  )
)

# Define server logic required to draw a line plot
server <- function(input, output) {
  output$linePlot <- renderPlot({
    # Draw the line plot with the specified data set's X and Y coordinates and other information
    plot(
      x = data2[data2$id == input$id,]$x,
      y = data2[data2$id == input$id,]$y,
      type = "b",
      xlim = c(0,255),
      ylim = c(-5,145),
      xlab = "Feet",
      ylab = "Feet",
      main = paste("Sample ", input$id, " (Label ", unique(data2[data2$id == input$id,]$label), ")\nSpeed = ", round(unique(data2[data2$id == input$id,]$speed), 1), ", Distance = ", round(unique(data2[data2$id == input$id,]$distance), 1), sep = ""))
  })
}

# Run the Shiny application 
shinyApp(ui = ui, server = server)
