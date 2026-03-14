# Social Media Addiction Dashboard (Shiny for R)

This project is an **individual assignment** that re-implements our group project dashboard using **Shiny for R**.

The application explores patterns of **social media usage among students**, including relationships between:

- Social media addiction
- Mental health
- Sleep habits
- Academic performance

The dashboard allows users to filter the data and interactively explore trends through visualizations.

---

# Live Application

The deployed application is available on **Posit Connect Cloud**.

**App Link:**  
*Add your deployed Posit Connect Cloud link here*

---

# GitHub Repository

Repository Link:  
*https://github.com/ssemakulapeterwasswa/social-media-addiction-shiny-r*

---

# Project Features

The dashboard includes:

- Interactive **filters**
- **Reactive data filtering**
- Multiple **visualizations**
- **Summary statistics**
- Interactive **data table**

## Input Components

- Gender filter (radio buttons)
- Age range filter (slider)
- Academic level filter (dropdown)

## Reactive Component

- A reactive dataframe that updates when filters change.

## Output Components

- Summary statistics tiles
- Bar chart showing impact on academic performance
- Scatter plot showing addiction vs mental health
- Interactive data table

---


# Installation

## Dependencies

This project requires the following R packages:

- shiny
- bslib
- ggplot2
- dplyr
- readr
- DT

To run this project locally, install the required R packages.

## Using Conda

Create the environment:

```bash
conda env create -f environment.yml
```

Activate the environment:

```bash
conda activate shiny-r-dashboard
```

Navigate to the project directory and run:

```bash
R -e "shiny::runApp()"
```

Or inside R:

```bash
shiny::runApp()
```

## Author

- Ssemakula Peter Wasswa
- Master of Data Science
- University of British Columbia