library(shiny)
library(shinydashboard)

# Loading external scripts and files (adapt to local directory)
load("~/Google Drive/hackathon-datapower/r/dashboard/data/model_Eolienne.RData")
source("data/ScriptR_05.r")
source("data/OpenWeatherMap.R")

# Dashboard server
shinyServer( function(input, output) {
  
  # Reactive data
  tempMin <- reactive({ input$sliderMin[1] })
  tempTarget <- reactive({ input$sliderMin[2] })
  estimate <- reactive({ round(x = as.numeric(
    estimation(
      tempTarget(),
      input$postcode,
      input$height,
      input$floors,
      input$construction,
      input$heating,
      input$surface,
      temperatureC
    )[2]), 
    digits = 2) 
  })
  
  # Outputs
  output$progressBox <- renderValueBox({ 
    valueBox(
      tempMin(), "Temperature Minimum", icon = icon("minus"),
      color = "purple"
    )
  })
  
  output$approvalBox <- renderValueBox({
    valueBox(
      tempTarget(), "Temperature Souhaitee", icon = icon("bullseye"),
      color = "yellow"
    )
  })

  output$estimateBox <- renderValueBox({
    valueBox(value = paste(estimate(), "€"),
    subtitle = "par an", 
    color = "green")
  })
  
  output$energieBox <- renderValueBox({
    if(input$green == T){
      eco = calculEco("paris")
      if(eco==1){
        valueBox(
          " - ", "Niveau faible", icon = icon("thumbs-down", lib = "glyphicon"),
          color = "red"
        )
      }else if (eco==2){
        valueBox(
          " = ", "Niveau moyen", icon = icon("hand-rock-o"),
          color = "blue"
        )
        
      }else if(eco==3){
        valueBox(
          " + ", "Niveau fort", icon = icon("thumbs-up", lib = "glyphicon"),
          color = "green"
        )
      }
    }else
    { 
      valueBox(
        " . ", "Preservez l'envrionnement !", icon = icon("globe"),
        color = "green"
      )
    }
  })
  
  output$peakBox <- renderValueBox({
    if(input$peak == T) {
      valueBox(
        paste(estimate() * 0.15, "€"), "d'economies", icon = icon("thumbs-up", lib = "glyphicon"),
        color = "green"
      )
    } else {
      valueBox(
        " . ", "Faites plus d'economies !", icon = icon("euro"),
        color = "green"
      )
    }
  })
  
  # /!\ NEST API CONNCETION NOT WORKING (API REQUEST TIMEOUT ISSUE)
  #     
  #   nest <- reactive({
  #     url = "https://developer-api.nest.com/devices/thermostats/ty2Igkuu0JaLpwlLjNCOk0z0LYT4YMOl"
  #     token = "c.1uCClV8AsTiTtkwZyjfU032WANKZhuMyeFU7fe0k6NreFRZCozqdhQxyEwwXFAuklMERvO1mpUsUQkjChVGusXtCCfZf89mmlKMIBxLfnDsZvlaS2NAeI50Aaso8zEXsx6DjT4uFPo7uCEkj"
  #     header <- list(auth=token)
  #     body <- list(target_temperature_c=18) #input$sliderMin[2]
  #     changetemp <- PUT(url=url, body=body, query=header, encode = "json", verbose())
  #     changetemp
  #   })

}) # END ShinyServer