library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Compound Poisson Process: Exp Inter-arrivals + Exp Jumps"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Parameters"),
      sliderInput("lambda", "Inter-arrival Rate (lambda):",
                  min = 0.1, max = 10, value = 1, step = 0.1),
      sliderInput("beta", "Jump Size Rate (beta):",
                  min = 0.1, max = 5, value = 1, step = 0.1),
      sliderInput("time", "Time Horizon (t):",
                  min = 10, max = 1000, value = 100),
      sliderInput("sims", "Number of Simulations:",
                  min = 100, max = 10000, value = 2000),
      hr(),
      helpText("Mathematical Note:"),
      helpText("Mean = lambda * t / beta"),
      helpText("Variance = 2 * lambda * t / beta^2")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Process Trajectory", 
                 plotOutput("trajPlot"),
                 p("These paths show the random evolution of the process over time.")
        ),
        tabPanel("Distribution at Time T", 
                 plotOutput("histPlot"),
                 verbatimTextOutput("stats")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  # --- 1. Trajectory Simulation ---
  sim_path_data <- reactive({
    # We simulate 5 distinct paths for visualization
    lapply(1:5, function(i) {
      # Estimate expected number of jumps to set buffer
      n_expected <- input$lambda * input$time * 2
      
      # Generate Inter-arrival times
      inter_arrivals <- rexp(n_expected, rate = input$lambda)
      arrival_times <- cumsum(inter_arrivals)
      
      # Keep only times <= T
      valid_times <- arrival_times[arrival_times <= input$time]
      n_jumps <- length(valid_times)
      
      # Generate Jumps
      if (n_jumps > 0) {
        jumps <- rexp(n_jumps, rate = input$beta)
        S_values <- cumsum(jumps)
        
        # Construct data frame for geom_step
        # We start at (0,0) and append the jump times
        data.frame(
          time = c(0, valid_times, input$time),
          S = c(0, S_values, S_values[length(S_values)]), # Repeat last value for T
          sim_id = as.factor(i)
        )
      } else {
        # No jumps case
        data.frame(time = c(0, input$time), S = c(0, 0), sim_id = as.factor(i))
      }
    }) %>% do.call(rbind, .)
  })
  
  output$trajPlot <- renderPlot({
    df <- sim_path_data()
    
    ggplot(df, aes(x = time, y = S, color = sim_id)) +
      # geom_step creates the standard "staircase" Poisson path
      geom_step(direction = "hv", size = 1) + 
      labs(title = paste("Sample Paths up to t =", input$time),
           y = "Cumulative Value S(t)", x = "Time") +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  # --- 2. Histogram Simulation (Optimized) ---
  output$histPlot <- renderPlot({
    
    # Step 1: Simulate number of jumps N ~ Poisson(lambda * t)
    n_counts <- rpois(input$sims, input$lambda * input$time)
    
    # Step 2: Simulate S(t). 
    # TRICK: Sum of n Exponentials ~ Gamma(n, beta)
    # If n=0, sum is 0. rgamma handles n=0 gracefully (returns 0).
    # This vectorizes the calculation, avoiding loops.
    s_values <- rgamma(length(n_counts), shape = n_counts, rate = input$beta)
    
    # Theoretical Normal Parameters
    mu_theor <- (input$lambda * input$time) / input$beta
    var_theor <- (input$lambda * input$time) * (2 / input$beta^2)
    sd_theor <- sqrt(var_theor)
    
    ggplot(data.frame(val = s_values), aes(x = val)) +
      geom_histogram(aes(y = ..density..), bins = 40, fill = "#69b3a2", color = "white") +
      stat_function(fun = dnorm, args = list(mean = mu_theor, sd = sd_theor),
                    color = "red", linetype = "dashed", size = 1.2) +
      labs(title = paste("Distribution of S(t) at t =", input$time),
           subtitle = "Green: Simulation | Red Dashed: Normal Approximation",
           x = "Total Value S(t)", y = "Density") +
      theme_minimal()
  })
  
  output$stats <- renderText({
    mu <- (input$lambda * input$time) / input$beta
    var <- (input$lambda * input$time) * (2 / input$beta^2)
    paste0("Theoretical Mean:    ", round(mu, 4), 
           "\nTheoretical Variance: ", round(var, 4))
  })
}

shinyApp(ui = ui, server = server)

