### App for working out breeding pairs and productivity for Redshank from BBS data ##
## James E. Jepson, 2024

# Redshank Breeding Pairs:

# Estimated pairs = the mean of total birds from visit 1 and visit 2

# Redshank Productivity:

# Alarming adults on third visit divided by estimated pairs


# Install shiny
install.packages("shiny")

# Load shiny
library(shiny)

# Define the user interface (UI)
ui <- fluidPage(
  tags$style(HTML("
    h3 {
      font-size: 15px;  # Change h3 header font size
    }
    h4 {
      font-size: 13px;  # Change h4 header font size
    }
    .numeric-input-label {
      font-size: 12px;  # Change the font size of numeric input labels
    }
    .main-panel-output {
      font-size: 18px;  # Change the font size of output text
    }
    .bold-big-header {
      font-size: 20px;  # Set the font size to make it bigger
      font-weight: bold;  # Make the font bold
    }
  ")),
  titlePanel("Redshank Breeding Pairs and Productivity"),  # Title displayed at the top of the app
  
  sidebarLayout(
    sidebarPanel(
      # Input fields for RK visit data
      h3("Input total number of adult Redshanks from visits 1 and 2"),  # Section heading for visit data input
      numericInput("RK_visit_1", "Visit 1:", value = 0, min = 0),  # Input for Visit 1 with default value 12
      numericInput("RK_visit_2", "Visit 2:", value = 0, min = 0),  # Input for Visit 2 with default value 12
      
      # Input for RK_alarm_adults
      h3("Input number of alarming adult Redshanks from Survey 3"),  # Section heading for alarming adults data input
      numericInput("RK_alarm_adults", "Alarming Adults:", value = 0, min = 0)  # Input for alarming adults with default value 8
    ),
    
    mainPanel(
      # Display results for RK_pairs and RK_prod
      h3("Redshank Breeding Pairs and Productivity:", class = "bold-big-header"),  # Added class for bigger and bold header
      h4(""),  # Label for RK_pairs
      textOutput("RK_pairs"),  # Placeholder to display the RK_pairs calculation result
      
      h4(""),  # Label for RK_prod
      textOutput("RK_prod")  # Placeholder to display the RK_prod calculation result
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Calculate RK_pairs as the mean of RK_visit_1 and RK_visit_2
  output$RK_pairs <- renderText({
    RK_pairs <- mean(c(input$RK_visit_1, input$RK_visit_2))  # Calculate the mean of visit 1 and visit 2
    paste("Redshank Pairs: ", round(RK_pairs, 2))  # Display the result rounded to 2 decimal places
  })
  
  # Calculate RK_prod as RK_alarm_adults / RK_pairs
  output$RK_prod <- renderText({
    RK_pairs <- mean(c(input$RK_visit_1, input$RK_visit_2))  # Recalculate RK_pairs to use in RK_prod
    
    if (RK_pairs == 0) {  # Check if RK_pairs is zero
      return("Redshank Productivity: 0")  # Return a message instead of NaN
    } else {
      RK_prod <- input$RK_alarm_adults / RK_pairs  # Calculate the productivity
      paste("Redshank Productivity:", round(RK_prod, 2))  # Display the result rounded to 2 decimal places
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
