library(shiny)
library(shinydashboard)


# Dashboard
dashboardPage(
  skin = "green",
  dashboardHeader(
    title = "Ecodomia"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Mon logement", tabName = "logement", icon = icon("home"))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    tabItems(
      tabItem(tabName = "logement",
        fluidRow(
          box(title = "Localisation", solidHeader = TRUE, status = "primary",
              textInput("postcode", label = "Code postal"))
        ),
        fluidRow(
          box(title = "Taille du logement", solidHeader = TRUE, status = "primary",
              numericInput("surface", label = "Surface", value = 50))
        )
              
      ),
      tabItem(tabName = "dashboard")
    )
  )
)

# # First panel layout
# overviewPanel = fluidPage(
#   titlePanel("Overview"),
#   fluidRow(
#     column(4,selectInput("listTypes", 
#                          label = "Choose which type of donation to show",
#                          choices = c("ALL",
#                                      distinctType),
#                          selected = "ALL"),
#            radioButtons("radioMeasure1", 
#                          label = "Measure",
#                          choices = list("Total amount" = 1,
#                                         "Number of donors" = 2,
#                                         "Total amount per donor" = 3)),
#            sliderInput("periodobs1", "Periods to consider:",
#                        min = 0, max = max(tabActType$period),
#                        value = c(0,max(tabActType$period)),
#                        step = 1)
#            ),
#     column(8, plotOutput("overviewActType"))
#   ),
#   fluidRow(
#     column(4,selectInput("listChannels", 
#                          label = "Choose which channel to show",
#                          choices = c("ALL",
#                                      distinctChannel),
#                          selected = "ALL"),
#            radioButtons("radioMeasure2", label = "Measure",
#                         choices = list("Total Amount" = 1,
#                                        "Number of donors" = 2,
#                                        "Total amount per donor" = 3),
#                         selected = 1),
#            sliderInput("periodobs2", "Periods to consider:",
#                        min = 0, max = max(tabPeriodsChannel$period),
#                        value = c(0,max(tabPeriodsChannel$period)),
#                        step = 1)
#            ),
#     column(8, plotOutput("overviewPeriodsChannel"))
#   ),
#   
#   fluidRow(
#     column(4, sliderInput("rankobs", "Number of donations to consider:",
#                           min = 1, max = length(tabActRank$nbDonors), value = c(1,25),
#                           step = 1),
#            radioButtons("radioMeasure3", label = "Measure",
#                         choices = list("Average Amount" = 1, 
#                                        "Number of donors" = 2),
#                         selected = 1)),
#     column(8, plotOutput("overviewActRank"))
#   )
# )
# 
# #Second panel layout
# panelDonors = fluidPage(
#   titlePanel("Donors & Loyalty"),
#   fluidRow(
#   column(4,selectInput("listChannels2", 
#                        label = "Choose which channel to show",
#                        choices = c("ALL",
#                                    distinctChannel),
#                        selected = "ALL"),
#          sliderInput("rankobs2", "Number of donations to consider:",
#                      min = 2, max = max(tabRankLapse$ActRank), value = c(2,40),
#                      step = 1)
#   ),
#   column(8, plotOutput("loyaltyRankLapse"))
#   ),
#   fluidRow(
#   column(6, plotOutput("loyaltyChannelLapse"))  #A FIXER... ERROR SUR server.R
#   )
# )
# 
# #Third panel layout
# panelGeo = fluidPage(
#   titlePanel("Geographic"),
#   fluidRow(
#     column(2, radioButtons("deptvar", label = "Choose a variable to display",
#                            choices = list("Average Amount" = "Avg_amount", 
#                                           "Active Ratio" = "Active_ratio"))),
#     column(6, plotOutput("geographic"))
#   )
# )
# 
# #Fourth panel layout
# panelSurv = fluidPage(
#   titlePanel("Survival Analysis"),
#   fluidRow(
#     column(12, plotOutput("survivalCurve"))
#   ),
#   fluidRow(
#     column(12, tableOutput("survivalTable"))
#   )
# )
# 
# # Define navbar elements
# shinyUI(navbarPage(title = "Executive Dashboard",
#                    theme = "bootstrap.css",
#                    position = "fixed-top",
#                    inverse = TRUE,
#                    collapsible = TRUE,
#                    tabPanel("Overview", overviewPanel),
#                    tabPanel("Donors", panelDonors),
#                    tabPanel("Geographic", panelGeo),
#                    tabPanel("Survival", panelSurv)
# ))