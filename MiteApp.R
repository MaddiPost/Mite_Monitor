install.packages("shiny")
library(shiny)
install.packages("shinyWidgets")
library(shinyWidgets)
install.packages("tidyverse")
library(tidyverse)
install.packages("shinythemes")
library(shinythemes)

#Plan of attack:

#Slider for day of year sampled (1-365)
#Text input for measured mite rate
#Slider for days run simulation (1-365)
#Go button to generate first plot

#Treating mites:
#Select box for Selecting treatment option
#Radio buttons for "would you like to treat in autumn?"
#Slider for what day in autumn to treat?
#Radio buttons for "would you like to treat in spring?"
#Slider for what day in spring to treat?
#Slider for days run simulation (1-365)
#Go button to generate second plot

# sliderInput(inputId = "DaySampled",
#             label = "What day of the year (1-365) did you sample?",
#             min = 1,
#             max = 365,
#             value = 1),
# 
# textInput("MiteRate", "Measured mite rate (mites per 100 bees)", value = "1", width = NULL, placeholder = NULL),
# 
# sliderInput(inputId = "DaySim",
#             label = "How many days would you like to run the simulation?",
#             min = 1,
#             max = 365,
#             value = 1),
# actionButton("goButton", "Go")


ui <- fluidPage(
  theme = shinytheme("united"),
  titlePanel("Varroa mite prediction simulation"),
  navbarPage("",
             tabPanel("",
                      br(),
                      br(),
             sidebarLayout(
                sidebarPanel(width =4,
                        sliderInput(inputId = "DaySampled",
                                         label = "What day of the year (1-365) did you sample?",
                                         min = 1,
                                         max = 365,
                                         value = 6),

      textInput("MiteRate", "Measured mite rate (mites per 100 bees)", value = "60", width = NULL, placeholder = NULL),

                    sliderInput(inputId = "DaySim1",
                    label = "How many days would you like to run the simulation?",
                                         min = 1,
                                         max = 365,
                                         value = 250),
      br(),
                             actionButton("goButton1", "Go"),

      br(),
      br(),
      br(),

      #Treating mites:
      #Radio buttons for "would you like to simulate miticide treatment in autumn?"
      radioButtons("AutumnTreat", "Would you like to predict treatment effects in autumn?",
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
                    "Formic acid" = "formic_acid", 
                    "Oxalic acid" = "oxalic_acid"), selected = "apiguard"),
      
      #Slider for what day in autumn to treat?
      sliderInput(inputId = "DayAutumn",
                  label = "What day in autumn would you like to treat your hive with Apiguard?",
                  min = 1,
                  max = 365,
                  value = 55),  
     
      
       #Radio buttons for "would you like to treat in spring?"
      radioButtons("SpringTreat", "Would you like to predict treatment effects in spring?",
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
                    "Formic acid" = "formic_acid", 
                    "Oxalic acid" = "oxalic_acid"), selected = "bayvarol"),
      
      #Slider for what day in spring to treat?
      sliderInput(inputId = "DaySpring",
                  label = "What day in spring would you like to treat your hive with Apiguard?",
                  min = 1,
                  max = 365,
                  value = 10),
      
      
      radioButtons("OtherTreat", "Would you like to apply treatment at another time of year?",
                   c("Yes" = "Yes",
                     "No" = "No")), 
      
      
         
      #Slider for days run simulation (1-365)
      sliderInput(inputId = "DaySim2",
                  label = "How many days would you like to run the simulation?",
                  min = 1,
                  max = 365,
                  value = 250),
      
      br(),
      
      #Go button to generate second plot
      actionButton("goButton2", "Go"),
      
                ),
                mainPanel (width =8, plotOutput("regPlot", width = "700px", height = "400px"))
             ))))


server <- function(input, output) {}
shinyApp(ui = ui, server = server)




#############################

# ui <- fluidPage(
#   theme = shinytheme("united"),
#   titlePanel("Varroa mite prediction simulation"),
#   navbarPage("",
#              tabPanel("",
#                       sidebarLayout(
#                         sidebarPanel(width =3,
#                                      sliderInput(inputId = "DaySampled",
#                                                  label = "What day of the year (1-365) did you sample?",
#                                                  min = 1,
#                                                  max = 365,
#                                                  value = 6),
#                                      
#                                      textInput("MiteRate", "Measured mite rate (mites per 100 bees)", value = "60", width = NULL, placeholder = NULL),
#                                      
#                                      sliderInput(inputId = "DaySim",
#                                                  label = "How many days would you like to run the simulation?",
#                                                  min = 1,
#                                                  max = 365,
#                                                  value = 250),
#                                      actionButton("goButton", "Go"),
#                         ),
#                         mainPanel (width =8, plotOutput("regPlot", width = "700px", height = "400px"))
#                       ))))
# 
# 
# server <- function(input, output) {}
# shinyApp(ui = ui, server = server)

