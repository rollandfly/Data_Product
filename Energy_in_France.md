Energy consumption and production in France
========================================================
author: DV
date: 2020-04-24
autosize: true

First Slide
========================================================

Data comes from :

- https://www.data.gouv.fr/en/datasets/consommation-quotidienne-brute-regionale-2013-a-2020/
- https://www.data.gouv.fr/en/datasets/production-regionale-annuelle-par-filiere-2008-a-2018/

Library:
- plotly
- dplyr

You can view the plot in the app

Import and cleaning data
========================================================


```r
  library(dplyr)
  library(plotly)
  library(ggplot2)
  
  Prod<-read.csv("production-quotidienne-filiere.csv",sep=";",na.strings=0)
  Conso<-read.csv("consommation-quotidienne-brute-regionale.csv",sep=";",na.strings=0)
    
  #Cleaning data
  Prod_clean<-Prod[,-c(1,3,14)]
  Prod_clean<-aggregate(.~Date,Prod_clean,FUN=sum)
  Prod_clean<-Prod_clean[order(Prod_clean$Date),]
  colnames(Prod_clean)=c("Date","TotalProd","FossilFuelProd","FuelOilProd"
                         ,"CoalProduction","GazProd","HydraulicProd"
                         ,"NuclearProd","SunProd","WindProd","GreenProd")
    
  Conso_clean<-Conso[,-c(1,3,4,5,6,7,8,9,10,12)]
  Conso_clean<-aggregate(.~Date,Conso_clean,sum)
  Conso_clean$Date <- as.Date(Conso_clean$Date, "%d/%m/%Y")
  Conso_clean<-Conso_clean[order(Conso_clean$Date),]
  colnames(Conso_clean)=c("Date","EleclConso","TotalConso")
    
  TTEnergi<-cbind(Prod_clean,Conso_clean[,2:3])
```

Code for Plot: Production vs Consumption
========================================================


```r
      g1<-plot_ly(x=TTEnergi$Date,y=TTEnergi$EleclConso,type = "scatter",mode="lines",name="Consumption")
      g1<-add_lines(g1,x=TTEnergi$Date, y=TTEnergi$TotalProd, name="Production Elec")
```

Code Plot: Type of Production
========================================================


```r
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
```
