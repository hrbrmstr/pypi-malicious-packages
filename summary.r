#' ---
#' title: ""
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     keep_md: true
#'     theme: simplex
#'     highlight: monochrome
#' ---
#+ init, include=FALSE
knitr::opts_chunk$set(message = TRUE, warning = TRUE, dev="png",
                      fig.retina = 2, fig.width = 10, fig.height = 6)

#+ libs
library(hrbrthemes)
library(rprojroot)
library(tidyverse)

#+ data
root <- path.expand(find_rstudio_root_file())

.pypi_cols <- cols(
  timestamp = col_character(),
  package = col_character(),
  country_code = col_character(),
  version = col_character()
)

#' Read in the data
pypi <- read_csv(file.path(root, "data", "pypi-malpkg-query-results.gz"),
                 col_types = .pypi_cols)

#' We just want day resolution
pypi <- mutate(pypi, day = as.Date(substr(timestamp, 1, 10)))

#' Get daily counts:
count(pypi, package, day) -> pypi_daily_summary

#+ download_counts_per_day, fig.width=11, fig.height=7.5, fig.retina=2
ggplot(pypi_daily_summary) +
  geom_segment(aes(day, n, xend=day, yend=0), size=0.33, color="#4575b4") +
  scale_x_date(limits=range(pypi_daily_summary$day), expand=c(0,0),
               date_breaks="6 weeks", date_labels = "%Y\n%b\nWk: %U") +
  facet_wrap(~package, scales="free") +
  labs(x=NULL, y="# Downloads/Day",
       title="PyPI Mal-package exposure outlined in <www.nbu.gov.sk/skcsirt-sa-20170909-pypi>",
       subtitle="Daily total downloads — sourced via <bigquery.cloud.google.com/table/the-psf:pypi.downloads>\nNote free Y scales.") +
  theme_ipsum_rc(grid="Y", strip_text_face = "bold", axis_text_size = 9)

#+ dopple_data

.dopple_cols <- cols(
  dl_day = col_date(format = ""),
  package = col_character(),
  dl_count = col_integer()
)

dopple <- read_csv(file.path(root, "data", "doppleganger-counts.csv.gz"),
                   col_types = .dopple_cols)

#+ dopple_counts_per_day, fig.width=11, fig.height=7.5, fig.retina=2
ggplot(dopple) +
  geom_segment(aes(dl_day, dl_count, xend=dl_day, yend=0), size=0.33, color="#4575b4") +
  scale_x_date(expand=c(0,0), date_breaks="6 weeks", date_labels = "%Y\n%b\nWk: %U") +
  scale_y_comma() +
  facet_wrap(~package, scales="free") +
  labs(x=NULL, y="# Downloads/Day",
       title="PyPI Mal-package Doppleganger Downloads-per-day",
       subtitle="Daily total downloads — sourced via <bigquery.cloud.google.com/table/the-psf:pypi.downloads>\nNote free Y scales.") +
  theme_ipsum_rc(grid="Y", strip_text_face = "bold", axis_text_size = 9)
