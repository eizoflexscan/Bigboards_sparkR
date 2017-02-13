################################
# AUTHOR : Angel Sevilla Camins 
################################

library(shiny)
shinyUI(fluidPage(
  
  # Application title.
  titlePanel("GLM with SparkR in a docker cluster"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      h3("GLM Model mpg ~ wt + ..."),
      checkboxGroupInput("variables",
                         label = h4("1. Variables:"),
                         choices = list("cyl [Number of cylinders]" = "cyl",
                                        "disp [Displacement (cu.in.)]" = "disp",
                                        "hp [Gross horsepower]" = "hp",
                                        "drat [Rear axle ratio]" = "drat",
                                        "qsec [1/4 mile time]" = "qsec",
                                        "vs [V/S]" = "vs",
                                        "am [Transmission type]" = "am",
                                        "gear [Number of forward gears]" = "gear",
                                        "carb [Number of carburetors]" = "carb"
                         )),
      
      actionButton("regression","Launch regression")
    ),
    
    # Main Panel
    mainPanel(
      h4("2. Model formula. ", span("Wait until the formula is shown to
        finish initialization of the SparkR server",
                                    style = "color:red")),
      verbatimTextOutput("formula"),
      
      h4("3. Model output. ",span("Be patient in the first run",
                                  style = "color:red")),
      tableOutput("model")
    )
  )
))