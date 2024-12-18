### App for working out breeding pairs and productivity for Lapwings from BBS data ##
## James E. Jepson, 2024

# Lapwing Breeding Pairs:

# Worked out from MAX number of individuals from visit 1 or visit 2 divided by 2

# Lapwing Productivity:

# the number of chicks fledged in a season can be 
# reliably estimated from the total number of well-grown and fledged young seen
# over the course of all four surveys, provided that surveys are carried out 
# during the previously described survey periods and at least one week apart 
# from one another

# Install packages
install.packages("shiny")

# Load shiny library
library(shiny)  # Loads the Shiny package for creating interactive web applications in R

# Define the user interface (UI)
ui <- fluidPage(  # Add custom CSS for font size changes
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
  ")),
  
  titlePanel("Lapwing Breeding Pairs and Productivity"),  # Title displayed at the top of the app
  
  sidebarLayout(
    sidebarPanel(
      # Input for Visit 1 and Visit 2
      h3("Total number of adult Lapwings from visits 1 and 2"),  # Section heading for visit data input
      numericInput("L_visit_1", "Visit 1:", value = 0, min = 0),  # Input for Visit 1 with default value 0
      numericInput("L_visit_2", "Visit 2:", value = 0, min = 0),  # Input for Visit 2 with default value 0
      h4(""),  # Label to indicate what the output below represents
      textOutput("max_visit_div2"),  # Placeholder to display the result of max(L_visit) divided by 2
      
      hr(),  # Horizontal rule to visually separate sections
      
      # Input for survey data
      h3("Input Survey Data for Juvenile Lapwings"),  # Section heading for survey data input
      numericInput("well_feathered_1", "Well-Feathered (Survey 1):", value = 0, min = 0),  # Input for well-feathered count in Survey 1
      numericInput("fledged_1", "Fledged (Survey 1):", value = 0, min = 0),  # Input for fledged count in Survey 1
      numericInput("well_feathered_2", "Well-Feathered (Survey 2):", value = 0, min = 0),  # Input for well-feathered count in Survey 2
      numericInput("fledged_2", "Fledged (Survey 2):", value = 0, min = 0),  # Input for fledged count in Survey 2
      numericInput("well_feathered_3", "Well-Feathered (Survey 3):", value = 0, min = 0),  # Input for well-feathered count in Survey 3
      numericInput("fledged_3", "Fledged (Survey 3):", value = 0, min = 0),  # Input for fledged count in Survey 3
      numericInput("well_feathered_4", "Well-Feathered (Survey 4):", value = 0, min = 0),  # Input for well-feathered count in Survey 4
      numericInput("fledged_4", "Fledged (Survey 4):", value = 0, min = 0)  # Input for fledged count in Survey 4
    ),
    
    mainPanel(
      # Display results for Visit data
      h3("Estimated Breeding Pairs"),  # Section heading for displaying visit data summary
      h4(""),  # Label to describe the output
      textOutput("max_visit_div2"),  # Placeholder to display the calculated max visit value divided by 2
      
      hr(),  # Horizontal rule to visually separate sections
      
      # Display survey data
      h3("Lapwing Productivity"),  # Section heading for displaying survey data summary
      tableOutput("data_table"),  # Placeholder to display the input survey data in table format
      h4("Total Well-Feathered:"),  # Label for total well-feathered birds
      textOutput("total_well_feathered"),  # Placeholder to display the total well-feathered count
      h4("Total Fledged:"),  # Label for total fledged birds
      textOutput("total_fledged"),  # Placeholder to display the total fledged count
      h4("Lapwing Productivity:"),  # Label for grand total of all birds
      textOutput("grand_total")  # Placeholder to display the grand total
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Calculate max of Visit 1 and Visit 2 divided by 2
  output$max_visit_div2 <- renderText({
    max(input$L_visit_1, input$L_visit_2) / 2  # Compute the maximum of Visit 1 and Visit 2 and divide by 2
  })
  
  # Create a reactive data frame based on survey data input
  survey_data <- reactive({
    data.frame(
      Survey = c("Survey 1", "Survey 2", "Survey 3", "Survey 4"),  # Fixed names for the surveys
      Well_Feathered = c(input$well_feathered_1, input$well_feathered_2, input$well_feathered_3, input$well_feathered_4),  # Collect well-feathered input for all surveys
      Fledged = c(input$fledged_1, input$fledged_2, input$fledged_3, input$fledged_4)  # Collect fledged input for all surveys
    )
  })
  
  # Render the table of survey data
  output$data_table <- renderTable({
    survey_data()  # Display the reactive data frame in a table
  })
  
  # Calculate and display totals
  output$total_well_feathered <- renderText({
    sum(survey_data()$Well_Feathered)  # Calculate the sum of the Well_Feathered column
  })
  
  output$total_fledged <- renderText({
    sum(survey_data()$Fledged)  # Calculate the sum of the Fledged column
  })
  
  output$grand_total <- renderText({
    sum(survey_data()$Well_Feathered) + sum(survey_data()$Fledged)  # Calculate the grand total of Well_Feathered and Fledged counts
  })
}

# Run the application
shinyApp(ui = ui, server = server)  # Launch the Shiny app
