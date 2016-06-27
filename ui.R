library(shiny)
library(shinydashboard)

# Dashboard UI
shinyUI( dashboardPage( 
  skin = "green",
    dashboardHeader(
      title = "Ecodomia"
    ),
    dashboardSidebar(
      # Menu items of the sidebar menu panel
      sidebarMenu(
        menuItem("Mon logement", tabName = "logement", icon = icon("home")),
        menuItem("Tableau de bord", tabName = "dashboard", icon = icon("dashboard"))
      )
    ),
    dashboardBody(
      # Generates HTML head tag to include CSS and Fonts
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
        tags$link(href='https://fonts.googleapis.com/css?family=Raleway:400,700', rel='stylesheet', type='text/css')
      ),
      tabItems(
        tabItem(tabName = "logement", # BEGIN FIRST TAB
                fluidRow(
                  box(title = "Localisation", solidHeader = TRUE, status = "success",
                      numericInput("postcode", label = "Code postal", value = 75015)
                  )
                ),
                fluidRow(
                  box(title = "Taille du logement", solidHeader = TRUE, status = "success",
                      numericInput("surface", label = "Surface", value = 50)
                  ),
                  box(title = "Nombre de pièces", solidHeader = TRUE, status = "success",
                      numericInput("rooms",label = "", value = 3)
                  )
                ),
                fluidRow(
                  box(title = "Hauteur de plafond", solidHeader = TRUE, status = "success",
                      numericInput("height",label = "", value = 3)
                  ),
                  box(title = "Nombre d'étages", solidHeader = TRUE, status = "success",
                      numericInput("floors",label = "", value = 5)
                  )
                ),
                fluidRow(
                  box(title = "Date de construction", solidHeader = TRUE, status = "success",
                      radioButtons("construction", 
                                   label = "", 
                                   choices = c("Avant 1990" = TRUE,
                                               "Après 1990" = FALSE))
                  ),
                  box(title = "Type de chauffage", solidHeader = TRUE, status = "success",
                      radioButtons("heating",
                                   label = "",
                                   choices = c("Electricite" = "electricite",
                                               "Gaz" = "gaz",
                                               "Autre" = "autre"))
                  )
                )
                
        ), # END FIRST TAB
        
        tabItem(tabName = "dashboard", # BEGIN SECOND TAB

                fluidRow(
                  column(width = 10, offset = 1,
                         box(width = 12 , 
                             
                             fluidRow( column(width = 12, sliderInput("sliderMin", "Choisisez votre minimum et votre objectif de temperature:",
                                                                      min = 15, max = 21, value = c(17,20)))),
                             fluidRow(infoBoxOutput("progressBox" , width = 6),
                                      infoBoxOutput("approvalBox" , width = 6)
                             )
                         )
                  )
                ),
                
                fluidRow(
                  column(width = 6 , offset = 3, 
                         valueBoxOutput("estimateBox", width = '100%')
                  )
                ),
                
                fluidRow(
                  column(width = 10, offset = 1,
                         box(
                           checkboxInput("peak", label = tagList(shiny::icon("area-chart"), "Eviter les pics de consommation"), value = TRUE),
                           valueBoxOutput("peakBox" , width = '100%')
                         ),
                         box(
                           checkboxInput("green", label = tagList(shiny::icon("leaf"),"Favoriser l'energie verte"), value = TRUE),
                           valueBoxOutput("energieBox" , width = '100%')
                           
                         )
                  ))
                
        ) # END SECOND TAB
        
      ) # END TABS
    ) # END BODY 
  ) # END PAGE 
) # END ShinyUI