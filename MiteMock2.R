
library(sf)
library(spData)
library(readr)
library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("cosmo"),
  titlePanel("Varroa mite prediction simulation"),
  navbarPage("",
             tabPanel("",
                      br(),
                      br(),
                      sidebarLayout(
                        sidebarPanel(width =4,
                                     
          dateInput("datetested", "What date did you test your hive?", value =
                      "2021-03-22", format = "dd/mm/yyyy"),

                # sliderInput(inputId = "DaySampled",
                    #             label = "What day of the year (1-365) did you sample?",
                    #             min = 1,
                    #             max = 365,
                    #             value = 6),


          numericInput("MiteRate", "What was your measured mite rate? (mites per 100 bees)", 3, min = 1, max = 500),
          numericInput("SimulationDays", "How many days would you like to run the simulation", 250, min = 10, max = 365),

                                     br(),
                                     actionButton("goButton1", "Go"),

                                     br(),
                                     br(),
                                     br(),

                                     # Treating mites:

                                     #Radio buttons for "would you like to simulate miticide treatment in autumn?"
                                     radioButtons("AutumnTreat", "Would you like to simulate treatment effects in autumn?",
                                                  c("Yes" = "Yes",
                                                    "No" = "No")),

                                     #Select box for Selecting treatment option
                                     selectInput("MiteTreat1", "Select mite treatment:",
                                                 c("Apistan" = "apistan",
                                                   "Amitraz" = "amitraz",
                                                   "Bayvarol" = "bayvarol",
                                                   "Apiguard" = "apiguard",
                                                   "Thymovar" = "thymovar",
                                                   "apiLifeVar" = "apilife_var",
                                                   "Formic acid" = "formic_acid"), selected = "thymovar"),

          dateInput("dateTreatAut", "What date would you like to treat your hive?", value = 
                      #             "2021-08-01", format = "dd/mm/yyyy"),
                      

                      
                      
                      
                                     #Radio buttons for "would you like to treat in spring?"
                                     radioButtons("SpringTreat", "Would you like to simulate treatment effects in spring?",
                                                  c("Yes" = "Yes",
                                                    "No" = "No")),

                                     #Select box for Selecting treatment option
                                     selectInput("MiteTreat2", "Select mite treatment:",
                                                 c("Apistan" = "apistan",
                                                   "Amitraz" = "amitraz",
                                                   "Bayvarol" = "bayvarol",
                                                   "Apiguard" = "apiguard",
                                                   "Thymovar" = "thymovar",
                                                   "apiLifeVar" = "apilife_var",
                                                   "Formic acid" = "formic_acid"), selected = "thymovar"),

          
          dateInput("dateTreatSpring", "What date would you like to treat your hive?", value = 
                      #             "2021-10-01", format = "dd/mm/yyyy"),


                                     radioButtons("OtherTreat", "Would you like to apply treatment at another time of year?",
                                                  c("Yes" = "Yes",
                                                    "No" = "No")),

                    # numericInput("SimulationDays", "How many days would you like to run the simulation", 250, min = 10, max = 365),       
    
                                     br(),

                                     #Go button to generate second plot
                                     actionButton("goButton2", "Go"),

                        ),
                        mainPanel (width =8, plotOutput("regPlot", width = "700px", height = "400px"))
                      ))))


server <- function(input, output) {}
shinyApp(ui = ui, server = server)
