
dashboardPage(
  skin='purple',
  dashboardHeader(title='New York City Crime'),
  dashboardSidebar(
    sidebarUserPanel('James Jiang',
                     image="https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("info")),
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
      menuItem("Potential Expansions",tabName = "expand", icon = icon("hourglass-2"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "intro",
              div(class="outer2",
                  tags$head(
                    includeCSS("styles.css")),
              br(),
              h1("Background"),
              h3("*  Just 20 years ago, Streets in NYC were racked with crime: murders, burglaries, drug deals, car thefts...
                 Since 90s the city has seen a significant drop in crime thanks to increased police oversight, change in demographics etc."),
              h3("*  However, public Satefy still remains a major concern. 
                 We need a convinient crime visualization tool for city's new comers"),
              br(),
              h1("The Dataset"),
              h3("--  Data Source: http://opendata.dc.gov/"),
              h3("--  Original Dataset Size: 5.5M Obs"),
              h3("--  Sampled Dataset Size: 100,000 Obs"),
              br(),
              br(),
              br(),
              h5("Author: Yinan Jiang"),
              h5("Email: yinanjia@usc.com")
      )),
      tabItem(tabName='type',
              h2('Crime Counts by Type'),
              fluidRow(box(selectizeInput("year1","Select Year", 
                            choice2, selected=2016), width=10)),
              fluidRow(box(plotlyOutput("plottype"), width=10))
      ),
      tabItem(tabName='month',
              h2('Crime Counts by Month'),
              fluidRow(box(selectizeInput("year2","Select Year", 
                             choice2, selected=2016), width=10)),
              fluidRow(box(plotlyOutput("plotmonth"), width=10))
      ),
      tabItem(tabName='hour',
              h2('Crime Counts by Hour'),
              fluidRow(box(selectizeInput("year3","Select Year", 
                                          choice2, selected=2016), width=10)),
              fluidRow(box(plotlyOutput("plothour"), width=10))
      ),
      tabItem(tabName='boro',
              h2('Crime Counts by Borough'),
              fluidRow(box(selectizeInput("year4","Select Year",
                             choice2, selected=2016), width=10)),
              fluidRow(box(plotlyOutput("plotboro"), width=10))
      ),
      tabItem(tabName='premises',
              h2('Crime Counts by Premises'),
              fluidRow(box(selectizeInput("year5","Select Year",
                             choice2, selected=2016), width=10)),
              fluidRow(box(plotlyOutput("plotpremises"), width=10))
      ),
      tabItem(tabName='map',
              h2("Mapping"),
              div(class="outer",
                  tags$head(
                    includeCSS("styles.css")),
              leafletOutput("map",width = '100%',height = '100%'),
              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                            top = 150, left = "auto", right = 15, bottom = "auto",
                            width = 200, height = "auto",
                            checkboxGroupInput(inputId = "type1", label = h4("Select Crime Type"), 
                                               choices = choice1, selected = 'FELONY'),
                            checkboxGroupInput(inputId = "premises1", label = h4("Select Premises"), 
                                               choices = choice3, selected = 'Residence'),
                            sliderInput(inputId = "year6", label = h4("Select Year"), min=2006, max=2016, step =1,
                                        sep='', value = c(2012, 2016)))
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
                                            sep='', value = c(2012, 2016)))
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
      tabItem(tabName = "expand",
              div(class="outer3",
                  tags$head(
                    includeCSS("styles.css")),
          br(),
          h2("#1 Every year new data will be available on http://opendata.dc.gov/"),
          br(),
          h2("#2 There are over 300 distinct crime type, can add more details"),
          br(),
          h2("#3 Overlay with apartment/house rental rates info")))
    )
  )
)