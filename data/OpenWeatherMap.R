### OpenWeatherMap Data API call
library(ROpenWeatherMap)

key = "5a3167b76fef776330af151a62afba29"
data=get_current_weather(api_key=key,city="paris")%>% as.data.frame()
temperatureC = data$main.temp - 273.15