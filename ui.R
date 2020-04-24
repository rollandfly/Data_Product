#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Electricity production and consumption in France and"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
            sidebarPanel(

                dateInput('date',
                          label = 'Choose a date',
                          min="2013-01-01",
                          max="2020-01-01",
                          value="2015-01-01",
                         
                ),
                h3("Electricity production for this day in MW:"),
                textOutput("Prod"),  
                h3("Electricity consumption for this day in MW:"),
                textOutput("Conso"),
             
            
             ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Production VS Consumption", br(), plotlyOutput("distPlot1")),
                        tabPanel("Type Of Production", br(), plotlyOutput("distPlot2")),
                        tabPanel("Documentation", br(),textOutput("texteDoc"))
            )
        )
    )
))
