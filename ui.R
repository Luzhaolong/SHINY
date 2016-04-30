library(shiny)
shinyUI(fluidPage(
    titlePanel(strong("ChicagoCensus-Project")),
    
    sidebarLayout(
        sidebarPanel(
            p("Visit", a('IHS', href = 'https://www.housingstudies.org/'), " for more information"
            ),
            img(src = 'ihs.png',height = 80, width = 250),
            br(),
            br(),
            hr(),
            
            selectInput("clnum", label = strong('Select a cluster for mapping'),
                        choices = list("Cluster 1" ,"Cluster 2" , 
                                       "Cluster 3" , "Cluster 4" ,
                                       "Cluster 5" ,"Cluster 6" ,
                                       "Cluster 7" ,"Cluster 8")),
            br(),
            
            selectInput("var", label = strong('Select a variable'),
                        choices = list("Change_Population" ,
                                       "Change_HouseUnits" , 
                                       "Change_5To7_or_more_person_household" , 
                                       "Change_Builst1939earlier" ,
                                       "Change_Built_1940to1959" ,
                                       "Change_VacantUnits" ,
                                       "Y00_PCT_Units_HHIncome_25to50k" ,
                                       "Y00_PCT_Units_HHIncome_50to75k" ,
                                       "Chg_Educate_HighSchool_orLess",
                                       "Chg_Educate_SomeCollege")),
            br(),
            
            sliderInput("slider", label = "Choose Value Range 'in %'",
                        min = 0, max = 100, value = c(30, 70)),
            br(),
            hr(),
            
            textInput("note", label = "Notes",value = "What's your thought?"),
            br(),
            hr(),
            img(src = 'bigorb.png',height = 50, width = 55),
            "Shiny is a product of", a("RStudio", href = 'https://www.rstudio.com/home/')
        ),
        
        mainPanel(
            h3('Description of Tabsets: '),
            hr(),
            h5('1. CLUSTERMAP: Presenting tracts of chosen cluster number within Cook County'),
            h5('2. Var_Boxplots: Orded Boxplots acorss Clusters for chosen Variable'),
            h5('3. Var_HeatMaps: Heatmap for chosen Variable in a selected range'),
            h5("4. Summary: general summary and conclusion, users' comments"  ),
            h5('5. Further Work, Q&A part'),
            br(),
            h3(' Each part can be discovered by clicking tabs below'),
            hr(),
            tabsetPanel(
                tabPanel("ClusterMap",plotOutput("mapc",height=500,width=700)),
                tabPanel("Var_Boxplots",plotOutput("boxp",height=500,width=700)),
                tabPanel("Var_HeatMaps",plotOutput("heatmap",height = 700,width=500)),
                tabPanel("Summary",
                         br(),
                         pre(includeText('summary.txt')),
                         br(),
                         div('Comments on the previous analysis:',style = "color : blue"),
                         hr(),
                         textOutput("note")),
                tabPanel("Further Work Q&As",
                         br(),
                         p('1. Map need to be interactive'),
                         p('2. Range should be optimized with 0 value indicating increasing or decreasing'),
                         hr(),
                         h3('Q&A is Welcomed'),
                         img(src = 'kcjk.png',height = 240, width = 200)))
            )
        )
    )
)



