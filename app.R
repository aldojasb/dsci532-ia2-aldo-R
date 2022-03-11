library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

#penguins <- readr::read_csv('C:/Users/aldos/Documents/LESSONS/532/532-ai2-aldo-R/data/penguins.csv')
penguins <- readr::read_csv(here::here('data', 'penguins.csv'))

app$layout(
  dbcContainer(
    list(htmlH1('Penguin Dashr heroky deployment, DONT select Island and Species. We are still implementing that. Sorry for the inconvenience'),
      dccGraph(id='plot-area'),
      dccDropdown(
        id='col-select',
        options = penguins %>%
          colnames() %>%
          purrr::map(function(col) list(label = col, value = col)), 
        value='bodywt')
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('col-select', 'value')),
  function(xcol) {
    p <- ggplot(penguins, aes(x = !!sym(xcol),
                            y = species,
                            color = island)) +
      geom_point() +
      scale_x_log10() +
      ggthemes::scale_color_tableau()
    ggplotly(p)
  }
)

app$run_server(host = '0.0.0.0')
