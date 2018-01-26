
dashboardPage(
  skin='purple',
  dashboardHeader(title='New York City Crime'),
  dashboardSidebar(
    sidebarUserPanel('James Jiang Shiny Project'),
    sidebarMenu(
      menuItem("Overview", icon = icon("bar-chart"),
               menuSubItem('Crime by Type',tabName='type',icon = icon("file-text-o")),
               menuSubItem('Crime by Month',tabName='month',icon = icon("calendar")),
               menuSubItem('Crime by Hour',tabName='hour',icon = icon("clock-o")),
               menuSubItem('Crime by Borough',tabName='boro',icon = icon("map-marker")),
               menuSubItem('Crime by Premises',tabName='premises',icon = icon("institution"))),
      menuItem("Map",tabName = "map",icon = icon("globe")),
      menuItem("Heat Map",tabName = "heatmap", icon = icon('fire')),
      menuItem("Time Series",tabName = "timeseries", icon = icon('line-chart')),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Info",tabName = "info", icon = icon("info"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName='type',
              h2('Crime Counts by Type'),
              fluidRow(box(selectizeInput("year1","Select Year", 
                            choice2, selected=2016), width=10)),
              fluidRow(box(plotOutput("plottype"), width=10))
      ),
      tabItem(tabName='month',
              h2('Crime Counts by Month'),
              fluidRow(box(selectizeInput("year2","Select Year", 
                             choice2, selected=2016), width=10)),
              fluidRow(box(plotOutput("plotmonth"), width=10))
      ),
      tabItem(tabName='hour',
              h2('Crime Counts by Hour'),
              fluidRow(box(selectizeInput("year3","Select Year", 
                                          choice2, selected=2016), width=10)),
              fluidRow(box(plotOutput("plothour"), width=10))
      ),
      tabItem(tabName='boro',
              h2('Crime Counts by Borough'),
              fluidRow(box(selectizeInput("year4","Select Year",
                             choice2, selected=2016), width=10)),
              fluidRow(box(plotOutput("plotboro"), width=10)),
              br(),
              fluidRow(img(src='districtmap.jpg'))
      ),
      tabItem(tabName='premises',
              h2('Crime Counts by Premises'),
              fluidRow(box(selectizeInput("year5","Select Year",
                             choice2, selected=2016), width=10)),
              fluidRow(box(plotOutput("plotpremises"), width=10))
      ),
      tabItem(tabName='map',
              h2("Mapping"),
              div(class="outer",
                  tags$head(
                    includeCSS("styles.css")),
              leafletOutput("map",width = '100%',height = '100%'),
              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                            top = 100, left = "auto", right = 15, bottom = "auto",
                            width = 200, height = "auto",
                            h2("Crime in NYC"),
                            checkboxGroupInput(inputId = "type1", label = h4("Select Crime Type"), 
                                               choices = choice1, selected = 'FELONY'),
                            checkboxGroupInput(inputId = "premises1", label = h4("Select Premises"), 
                                               choices = choice3, selected = 'Residence'),
                            sliderInput(inputId = "year6", label = h4("Select Year"), min=2006, max=2016, step =1,
                                        value = c(2012, 2016)))
      )),
      tabItem(tabName='heatmap',
              h2("Heat Map"),
              div(class="outer",
                  tags$head(
                    includeCSS("styles.css")),
                  leafletOutput("heatmap",width = '100%',height = '100%'),
                  absolutePanel(id = "controls1", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                                top = 150, left = "auto", right = 15, bottom = "auto",
                                width = 200, height = "auto",
                                checkboxGroupInput(inputId="type2", label=h4("Select Crime Type"), 
                                                   choices=choice1, selected='FELONY'),
                                checkboxGroupInput(inputId="premises2", label=h4("Select Premises"), 
                                                   choices=choice3, selected='Residence'),
                                sliderInput(inputId = "year7", label = h4("Select Year"), min=2006, max=2016, step =1,
                                            value = c(2012, 2016)))
      )),
      tabItem(tabName='timeseries',
              h2('Crime Rates Visualization'),
              fluidRow(box(checkboxGroupInput(inputId="boro1", label=h4("Select Borough"), 
                                              choices=choice4, selected=c('BROOKLYN','MANHATTAN'), inline=TRUE), width=12)),
              fluidRow(box(plotlyOutput(outputId="timeseries", width=1000, height=500), width=12))
      ),
      tabItem(tabName='data',
              fluidRow(box(DT::dataTableOutput("table"), width=12))
      ),
      tabItem(tabName = "info",
          h4("Data Source: http://opendata.dc.gov/"),
          h4("Author: Yinan Jiang"),
          h4("Email: yinanjia@usc.com"))
    )
  )
)