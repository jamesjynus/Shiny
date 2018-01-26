
function(input, output) {
  
  reacttype=reactive({
    count.type %>% 
      filter_(ifelse(input$year1=="ALL",'Year %in% unique(count.type$Year)','Year==input$year1'))
  })
  output$plottype=renderPlot({
    ggplot(reacttype(), aes(x=factor(Type, levels=c('VIOLATION','MISDEMEANOR','FELONY')), y=Count, fill=Type)) + 
      geom_bar(stat='identity')+
      labs(x='Type', y='Total Number of Crimes', title='Total Count of Crimes per Type')
  })
  reactmonth=reactive({
    count.month %>% 
      filter_(ifelse(input$year2=="ALL",'Year %in% unique(count.month$Year)','Year==input$year2'))
  })
  output$plotmonth=renderPlot({
    ggplot(reactmonth(), aes(x=factor(Month, levels=c('Jan','Feb','Mar','Apr','May',
                                                     'Jun','Jul','Aug','Sep','Oct',
                                                     'Nov','Dec')), y=Count, fill=Month)) + 
      geom_bar(stat='identity')+
      labs(x='Month', y='Total Number of Crimes', title='Total Count of Crimes by Month')
  })
  reacthour=reactive({
    count.hour %>% 
      filter_(ifelse(input$year3=="ALL",'Year %in% unique(count.hour$Year)','Year==input$year3'))
  })
  output$plothour=renderPlot({
    ggplot(reacthour(), aes(x=Hour, y=Count, fill=Hour)) + 
      geom_bar(stat='identity')+
      labs(x='Hour', y='Total Number of Crimes', title='Total Count of Crimes by Hour')
  })
  reactboro=reactive({
    count.boro %>% 
      filter_(ifelse(input$year4=="ALL",'Year %in% unique(count.boro$Year)','Year==input$year4'))
  })
  output$plotboro=renderPlot({
    ggplot(reactboro(),aes(x=Boro, y=Count, fill=Boro)) + 
      geom_bar(stat='identity')+
      labs(x='Borough', y='Total Number of Crimes', title='Total Number of Crimes by Borough')
  })
  reactpremises=reactive({
    count.premises %>% 
      filter_(ifelse(input$year5=="ALL",'Year %in% unique(count.premises$Year)','Year==input$year5'))
  })
  output$plotpremises=renderPlot({
    ggplot(reactpremises(), aes(x=Premises, y=Count, fill=Premises)) + 
      geom_bar(stat='identity')+  
      labs(x='Premises', y='Total Number of Crimes', title='Total Number of Crimes by Premises')
  })
  reactivemap=reactive({
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
    proxy=leafletProxy("map", data=reactivemap()) %>% 
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
  reactiveheatmap=reactive({
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
      addWebGLHeatmap(layerId='a',data=reactiveheatmap(),
                        lng=~Longitude, lat=~Latitude, size=180)
  })
  reactivetimeseries=reactive({
    crime %>% 
      filter(Boro %in% input$boro1) %>%
      group_by(Boro, Year_Month_New, Population) %>%
      summarise(n=n()) %>%
      mutate(Crime.Rate=n*55/Population)
  })
  output$timeseries=renderPlotly({
      plot_ly(data=reactivetimeseries(), x = ~Year_Month_New, y = ~Crime.Rate, color=~Boro, type = 'scatter', mode ='markers', linetype = I('solid')) %>% 
        layout(xaxis = list(title = "", showticklabels = TRUE),
               yaxis = list(title = "Crime Rate"), showlegend = TRUE)
  })
  output$table=DT::renderDataTable({
    datatable(crime, rownames=FALSE)
  })
}
