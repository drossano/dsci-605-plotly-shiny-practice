# load required packages
library(plotly)
library(shiny)
library(xlsx)

# set the working directory
setwd("Module9")

# get the data from xlsx file
my_data <- read_xlsx("Sampledata2.xlsx")
setui <- fluidPage(
  selectInput(inputId = "input_states",
              label = "Select a state",
              choices = my_data$State),
  plotlyOutput(outputId = "out_states"),
  selectInput(inputId = "input_years",
              label = "Select a year",
              choices = my_data$Year),
  plotlyOutput(outputId = "out_years")
)

server <- function(input, output) {
  output$out_states <- renderPlotly({
    plot_ly(my_data, x = ~Year, y = ~CrimeRate, color = ~State) %>% 
      filter(State %in% input$input_states) %>% 
      add_markers() %>% 
      group_by(State) %>% 
      add_lines()
  })
  
  output$out_years <- renderPlotly({
    plot_ly(my_data,x = ~CrimeRate) %>% 
      filter(Year %in% input$input_years) %>% 
      add_histogram()
  })
}

shinyApp(setui, server) 
