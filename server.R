
function(input, output) {
  
  reacttype=reactive({
    count.type %>% 
      filter_(ifelse(input$year1=="ALL",'Year %in% unique(count.type$Year)','Year==input$year1')) %>%
      group_by(Type) %>%
      summarise(Total=sum(Count))
  })
  output$plottype=renderPlotly({
    plot_ly(data=reacttype(), x = ~factor(Type, levels=c('VIOLATION','MISDEMEANOR','FELONY')), y = ~Total, 
            color=~factor(Type, levels=c('VIOLATION','MISDEMEANOR','FELONY')), type = 'bar', mode ='markers') %>% 
      layout(xaxis = list(title = "", showticklabels = TRUE),
             yaxis = list(title = ""), showlegend = TRUE)
  })
  reactmonth=reactive({
    count.month %>% 
      filter_(ifelse(input$year2=="ALL",'Year %in% unique(count.month$Year)','Year==input$year2')) %>%
      group_by(Month) %>%
      summarise(Total=sum(Count))
  })
  output$plotmonth=renderPlotly({
    plot_ly(data=reactmonth(), x = ~factor(Month, levels=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')), 
            y = ~Total, color=~factor(Month, levels=c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')),
            type = 'bar', mode ='markers') %>% 
      layout(xaxis = list(title = "", showticklabels = TRUE),
             yaxis = list(title = ""), showlegend = TRUE)
  })
  reacthour=reactive({
    count.hour %>% 
      filter_(ifelse(input$year3=="ALL",'Year %in% unique(count.hour$Year)','Year==input$year3')) %>%
      group_by(Hour) %>%
      summarise(Total=sum(Count))
  })
  output$plothour=renderPlotly({
    plot_ly(data=reacthour(), x = ~Hour, y = ~Total, color=~Hour, type = 'bar', mode ='markers') %>% 
      layout(xaxis = list(title = "", showticklabels = TRUE),
             yaxis = list(title = ""), showlegend = TRUE)
  })
  reactboro=reactive({
    count.boro %>% 
      filter_(ifelse(input$year4=="ALL",'Year %in% unique(count.boro$Year)','Year==input$year4')) %>%
      group_by(Boro) %>%
      summarise(Total=sum(Count))
  })
  output$plotboro=renderPlotly({
    plot_ly(data=reactboro(), x = ~factor(Boro, levels=c('QUEENS','BROOKLYN','MANHATTAN','BRONX','STATEN ISLAND')), 
            y = ~Total, color=~factor(Boro, levels=c('QUEENS','BROOKLYN','MANHATTAN','BRONX','STATEN ISLAND')), type = 'bar', mode ='markers') %>% 
      layout(xaxis = list(title = "", showticklabels = TRUE),
             yaxis = list(title = ""), showlegend = TRUE)
  })
  reactpremises=reactive({
    count.premises %>% 
      filter_(ifelse(input$year5=="ALL",'Year %in% unique(count.premises$Year)','Year==input$year5')) %>%
      group_by(Premises) %>%
      summarise(Total=sum(Count))
  })
  output$plotpremises=renderPlotly({
    plot_ly(data=reactpremises(), x = ~factor(Premises, levels=c('Restaurant','Public Venue','Stores','Residence','Street','Transportation','Other')), 
            y = ~Total, color=~factor(Premises, levels=c('Restaurant','Public Venue','Stores','Residence','Street','Transportation','Other')), type = 'bar', mode ='markers') %>% 
      layout(xaxis = list(title = "", showticklabels = TRUE),
             yaxis = list(title = ""), showlegend = TRUE)
  })
  reactmap=reactive({
    crime %>% 
      filter(Type %in% input$type1 &
               Premises %in% input$premises1 &
               Year >= input$year6[1] &
               Year <= input$year6[2])
  })
  output$map=renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap") %>% 
      setView(-73.9485,40.7447,zoom=12)
  })
  observe({
    proxy=leafletProxy("map", data=reactmap()) %>% 
      clearMarkers() %>% 
      clearMarkerClusters() %>%
      addCircleMarkers(clusterOptions=markerClusterOptions(), 
                       lng=~Longitude, lat=~Latitude,
                       color=~groupColors(Type), radius=5, group='Cluster',
                       popup=~paste('<b><font color="Red">','Crime Information','</font></b><br/>',
                              'Crime Type:', Type,'<br/>',
                              'Date:', Date,'<br/>',
                              'Time:', Time,'<br/v',
                              'Status:', Status, '<br/>',
                              'Borough:', Boro,'<br/>')) %>%
      addCircleMarkers(lng=~Longitude, lat=~Latitude, radius=5,
                       group='Point', color=~groupColors(Type),
                       popup=~paste('<b><font color="Red">','Crime Information','</font></b><br/>',
                                    'Crime Type:', Type,'<br/>',
                                    'Date:', Date,'<br/>',
                                    'Time:', Time,'<br/v',
                                    'Status:', Status, '<br/>',
                                    'Borough:', Boro,'<br/>')) %>%
      addLayersControl(
          baseGroups = c("Cluster","Point"),
          options=layersControlOptions(collapsed = FALSE)
    )
  })
  reactheatmap=reactive({
    crime %>% 
      filter(Type %in% input$type2 &
               Premises %in% input$premises2 &
               Year >= input$year7[1] &
               Year <= input$year7[2])
  })
  output$heatmap=renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.DarkMatter) %>% 
      setView(-73.9485,40.7447,zoom=12)
  })
  observe({
    proxy=leafletProxy("heatmap") %>% 
      removeWebGLHeatmap(layerId='a') %>% 
      addWebGLHeatmap(layerId='a',data=reactheatmap(),
                        lng=~Longitude, lat=~Latitude, size=180)
  })
  reacttimeseries=reactive({
    crime %>% 
      filter(Boro %in% input$boro1) %>%
      group_by(Boro, Year_Month_New, Population) %>%
      summarise(n=n()) %>%
      mutate(Crime.Rate=n*55/Population)
  })
  output$timeseries=renderPlotly({
      plot_ly(data=reacttimeseries(), x = ~Year_Month_New, y = ~Crime.Rate, color=~Boro, type = 'scatter', mode ='markers', linetype = I('solid')) %>% 
        layout(xaxis = list(title = "", showticklabels = TRUE),
               yaxis = list(title = "Crime Rate"), showlegend = TRUE)
  })
  output$table=DT::renderDataTable({
    datatable(crime, rownames=FALSE, options=list(scrollX=TRUE))
  })
}
