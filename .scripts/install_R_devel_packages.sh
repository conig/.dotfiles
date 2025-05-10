#!/bin/bash

# CRAN packages to check and install if missing
CRAN_PACKAGES=(
  "pak"
  "devtools"
  "roxygen2"
  "testthat"
  "pkgdown"
  "rmarkdown"
  "knitr"
  "ggplot2"
  "dplyr"
  "tidyr"
  "data.table"
)

# GitHub packages in acct/repo format to check and install if missing
GITHUB_PACKAGES=(
  "conig/jamesconigrave"
  "conig/stop"
  "conig/snipe"
  "conig/metaKIN"
  "jalvesaq/colorout"
  "conig/nvimscope.r"
  "conig/mtab"
)

# Loop over CRAN packages and install if missing
for pkg in "${CRAN_PACKAGES[@]}"; do
    Rscript -e "if (!requireNamespace('$pkg', quietly = TRUE)) install.packages('$pkg')"
done

# Loop over GitHub packages and install with pak if missing
for gh in "${GITHUB_PACKAGES[@]}"; do
    # Extract the package name from the GitHub format 'account/repo'
    pkg_name=$(echo "$gh" | awk -F'/' '{print $2}')
    Rscript -e "if (!requireNamespace('$pkg_name', quietly = TRUE)) { pak::pkg_install('$gh', upgrade = FALSE) }"
done
