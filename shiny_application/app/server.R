################################
# AUTHOR : Angel Sevilla Camins 
################################
library(shiny)

# Load library Rspark already installed with spark
library(SparkR, lib.loc = "/opt/spark/R/lib")

# Stop SparkR in case it was still running
sparkR.stop()

## initialeze SparkR environment
sc = sparkR.init(sparkHome =  "/opt/spark")
sqlContext = sparkRSQL.init(sc)

#Transfrom mtcars into DataFrame format
DF <- createDataFrame(sqlContext, mtcars)
cache(DF)


shinyServer(function(input, output,session) {
  # Compute the formula text in a reactive expression
  formulaText <- reactive({
    if (is.null(input$variables)) return("mpg ~ wt")
    else return(paste("mpg ~ wt",
                      paste(input$variables, collapse = " + ")
                      , sep = " + "))
  })


  # Compute the GLM model
  model <- eventReactive(input$regression, {
    SparkR::glm(as.formula(formulaText()),
                data = DF, family = "gaussian")
  })
  
  
  # Return the formula text for printing
  output$formula <- renderText({
    formulaText()
  })
  # Return model coefficients for printing
  output$model <- renderTable({
    data.frame(summary(model())$coefficients)
  })
  
  
  # Stop SparkR after closing the session
  session$onSessionEnded(function() {
    sparkR.stop()
  })
})