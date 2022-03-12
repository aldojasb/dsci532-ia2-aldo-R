library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

#penguins <- readr::read_csv('C:/Users/aldos/Documents/LESSONS/532/dsci532-ia2-aldo-R/data/us_counties_processed.csv')
#head(penguins)
penguins <- readr::read_csv(here::here('data', 'us_counties_processed.csv'))

app$layout(
  dbcContainer(
    list(htmlH1('MEAN TEMP Dashr heroky deployment'),
      dccGraph(id='plot-area'),
      dccDropdown(
        id='col-select',
        options = penguins %>%
          colnames() %>%
          purrr::map(function(col) list(label = col, value = col)), 
        value='state')
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('col-select', 'value')),
  function(xcol) {
    p <- ggplot(penguins, aes(x = !!sym(xcol),
                            y = mean_temp,
                            color = state)) +
      geom_point() +
      ggthemes::scale_color_tableau()
    ggplotly(p)
  }
)
#app$run_server(debug = T)
app$run_server(host = '0.0.0.0')
