#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    Prod<-read.csv("production-quotidienne-filiere.csv",sep=";",na.strings=0)
    Conso<-read.csv("consommation-quotidienne-brute-regionale.csv",sep=";",na.strings=0)
    
    #Cleaning data
    Prod_clean<-Prod[,-c(1,3,14)]
    Prod_clean<-aggregate(.~Date,Prod_clean,FUN=sum)
    Prod_clean<-Prod_clean[order(Prod_clean$Date),]
    colnames(Prod_clean)=c("Date","TotalProd","FossilFuelProd","FuelOilProd","CoalProduction","GazProd","HydraulicProd","NuclearProd",
                           "SunProd","WindProd","GreenProd")
    
    Conso_clean<-Conso[,-c(1,3,4,5,6,7,8,9,10,12)]
    Conso_clean<-aggregate(.~Date,Conso_clean,sum)
    Conso_clean$Date <- as.Date(Conso_clean$Date, "%d/%m/%Y")
    Conso_clean<-Conso_clean[order(Conso_clean$Date),]
    colnames(Conso_clean)=c("Date","EleclConso","TotalConso")
    
    TTEnergi<-cbind(Prod_clean,Conso_clean[,2:3])
    
    output$distPlot1 <- renderPlotly({
        distPlot<-plot_ly(x=TTEnergi$Date,y=TTEnergi$EleclConso,type = "scatter",mode="lines",name="Consumption")
        distPlot<-add_lines(distPlot,x=TTEnergi$Date, y=TTEnergi$TotalProd, name="Production Elec")
        distPlot<-rangeslider(distPlot)
    })
    output$distPlot2 <- renderPlotly({
        distPlot2<-plot_ly(x=TTEnergi$Date, y=TTEnergi$TotalProd,type = "scatter",mode="lines", name="Production Elec")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$FossilFuelProd, name="Fossil Fuel")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$FuelOilProd, name="Fuel oil")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$CoalProduction, name="Coal")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$GazProd, name="Gaz")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$HydraulicProd, name="Hydraulic")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$NuclearProd, name="Nuclear")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$SunProd, name="Sun")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$WindProd, name="Wind")
        distPlot2<-add_lines(distPlot2,x=TTEnergi$Date, y=TTEnergi$GreenProd, name="Green")
        distPlot2<-rangeslider(distPlot2)
    })
    output$Conso<-renderText({
        TTEnergi[input$date-as.Date("2013-01-01")+1,"EleclConso"]
        
    })
    output$Prod<-renderText({
        TTEnergi[input$date-as.Date("2013-01-01")+1,"TotalProd"]
        
    })
    
    output$texteDoc<-renderText(
    "This software show the production and the consumption of electricity in France.
    You can modify the Date to know the exact production and consumption of the days.")
    
})
