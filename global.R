library(leaflet.extras)
library(shiny)
library(ggplot2)
library(data.table)
library(leaflet)
library(shinydashboard)
library(dplyr)
library(plotly)

# convert matrix to dataframe
crime=fread("crime.csv", stringsAsFactors=F)
crime=as.data.frame(crime)
# create variable subsets
count.type=crime %>%
  group_by(Year, Type) %>%
  summarise(Count=n())

count.month=crime %>%
  group_by(Year, Month) %>%
  summarise(Count=n())

count.hour=crime %>%
  group_by(Year, Hour) %>%
  summarise(Count=n())

count.boro=crime %>%
  group_by(Year, Boro) %>%
  summarise(Count=n())

count.premises=crime %>%
  group_by(Year, Premises) %>%
  summarise(Count=n())

choice1=unique(count.type$Type)
choice2=c('ALL',unique(count.type$Year))
choice3=unique(count.premises$Premises)
choice4=unique(count.boro$Boro)

groupColors=colorFactor(c('#E03A3C', '#009DDC','#62BB47'),
                           domain = c('VIOLATION','MISDEMEANOR','FELONY'))
