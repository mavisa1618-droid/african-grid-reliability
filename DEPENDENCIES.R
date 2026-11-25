# Install the R packages this project uses.
# Run once with:  Rscript DEPENDENCIES.R
install.packages(c(
  "dplyr", "tidyr", "readr", "ggplot2", "rlang",   # data wrangling and plots
  "kableExtra", "knitr", "patchwork", "cowplot", "scales",  # slides
  "testthat", "lintr"                               # tests and code style
))
