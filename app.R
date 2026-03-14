library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(readr)
library(DT)

# -----------------------------
# Data
# -----------------------------
data_path <- file.path("data", "raw", "Students-Social-Media-Addiction.csv")

if (!file.exists(data_path)) {
  stop(paste(
    "Dataset not found at", data_path,
    "- make sure it exists in data/raw/"
  ))
}

df <- read_csv(data_path, show_col_types = FALSE)

AGE_MIN <- min(df$Age, na.rm = TRUE)
AGE_MAX <- max(df$Age, na.rm = TRUE)

# -----------------------------
# UI
# -----------------------------
ui <- page_fluid(
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly"
  ),

  tags$head(
    tags$style(HTML("
      body {
        background-color: #F4F6F9;
      }
      .card-value {
        background: white;
        border-left: 5px solid #1e3a6e;
        padding: 16px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.08);
        margin-bottom: 15px;
      }
      .card-value h4 {
        margin: 0;
        color: #0F1F3D;
        font-size: 16px;
      }
      .card-value h2 {
        margin-top: 8px;
        color: #1e3a6e;
        font-weight: bold;
      }
    "))
  ),

  titlePanel("Social Media Addiction Dashboard"),
  p(
    "Explore social media usage patterns among students",
    style = "color:#5a5a7a; margin-top:-10px;"
  ),

  sidebarLayout(
    sidebarPanel(
      h4("Filters"),

      radioButtons(
        inputId = "f_gender",
        label = "Gender",
        choices = c("All", "Male", "Female"),
        selected = "All"
      ),

      sliderInput(
        inputId = "f_age",
        label = "Age Range",
        min = AGE_MIN,
        max = AGE_MAX,
        value = c(AGE_MIN, AGE_MAX)
      ),

      selectInput(
        inputId = "f_level",
        label = "Academic Level",
        choices = c("All", "Undergraduate", "Graduate"),
        selected = "All"
      )
    ),

    mainPanel(
      fluidRow(
        column(
          3,
          div(class = "card-value",
              h4("Total Students"),
              h2(textOutput("tile_students")))
        ),
        column(
          3,
          div(class = "card-value",
              h4("Avg Daily Usage"),
              h2(textOutput("tile_usage")))
        ),
        column(
          3,
          div(class = "card-value",
              h4("Avg Sleep Hours"),
              h2(textOutput("tile_sleep")))
        ),
        column(
          3,
          div(class = "card-value",
              h4("Avg Addiction Score"),
              h2(textOutput("tile_addiction")))
        )
      ),

      fluidRow(
        column(
          6,
          h4("Impact on Academic Performance"),
          plotOutput("plot_aap")
        ),
        column(
          6,
          h4("Addiction vs Mental Health"),
          plotOutput("scatter_plot")
        )
      ),

      fluidRow(
        column(
          12,
          h4("Filtered Data"),
          DTOutput("data_table")
        )
      )
    )
  )
)

# -----------------------------
# Server
# -----------------------------
server <- function(input, output, session) {

  filtered_df <- reactive({
    data <- df %>%
      filter(Academic_Level %in% c("Undergraduate", "Graduate"))

    if (input$f_gender != "All") {
      data <- data %>% filter(Gender == input$f_gender)
    }

    data <- data %>%
      filter(Age >= input$f_age[1], Age <= input$f_age[2])

    if (input$f_level != "All") {
      data <- data %>% filter(Academic_Level == input$f_level)
    }

    data
  })

  output$tile_students <- renderText({
    nrow(filtered_df())
  })

  output$tile_usage <- renderText({
    d <- filtered_df()
    if (nrow(d) == 0) return("—")
    paste0(round(mean(d$Avg_Daily_Usage_Hours, na.rm = TRUE), 1), " h")
  })

  output$tile_sleep <- renderText({
    d <- filtered_df()
    if (nrow(d) == 0) return("—")
    paste0(round(mean(d$Sleep_Hours_Per_Night, na.rm = TRUE), 1), " h")
  })

  output$tile_addiction <- renderText({
    d <- filtered_df()
    if (nrow(d) == 0) return("—")
    round(mean(d$Addicted_Score, na.rm = TRUE), 1)
  })

  output$plot_aap <- renderPlot({
    d <- filtered_df()

    req(nrow(d) > 0)

    percent_df <- d %>%
      count(Affects_Academic_Performance) %>%
      mutate(
        Percentage = round(n / sum(n) * 100, 1)
      )

    ggplot(percent_df, aes(
      x = Affects_Academic_Performance,
      y = Percentage,
      fill = Affects_Academic_Performance
    )) +
      geom_col(width = 0.6) +
      geom_text(aes(label = paste0(Percentage, "%")), vjust = -0.5) +
      scale_fill_manual(values = c("Yes" = "#c0392b", "No" = "#1e3a6e")) +
      labs(
        x = "Affects Academic Performance",
        y = "Percentage of Students"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
  })

  output$scatter_plot <- renderPlot({
    d <- filtered_df()

    req(nrow(d) > 0)

    ggplot(d, aes(
      x = Addicted_Score,
      y = Mental_Health_Score,
      color = Sleep_Hours_Per_Night
    )) +
      geom_point(alpha = 0.7, size = 3) +
      labs(
        x = "Addiction Score",
        y = "Mental Health Score",
        color = "Sleep Hours"
      ) +
      theme_minimal()
  })

  output$data_table <- renderDT({
    datatable(
      filtered_df(),
      options = list(pageLength = 8, scrollX = TRUE)
    )
  })
}

shinyApp(ui = ui, server = server)