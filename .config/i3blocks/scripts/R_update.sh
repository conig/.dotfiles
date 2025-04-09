#!/bin/bash

latest_r() {

 curl -s https://cran.r-project.org/bin/windows/base/ | grep -oP '(?<=<title>)[^<]+' | grep -oP '[0-9]+\.[0-9]+\.[0-9]+'

}

current_r(){

local current
current=$(Rscript -e "with(R.version, cat(paste0(major, '.', minor)))")
echo $current
}

check_r_update() {
    local current
    current=$(Rscript -e "with(R.version, cat(paste0(major, '.', minor)))")

    local latest
    latest=$(latest_r)

    if [ "$current" != "$latest" ]; then
        echo "R version $current is outdated. Latest is $latest"
        return 1
    fi

}

r_ver() {
  local currentVer
  local latestVer

  # Replace these functions with actual methods to fetch current and latest R versions
  currentVer=$(current_r)  # Function to get installed R version
  latestVer=$(latest_r)    # Function to get latest available R version

  if [ "$currentVer" != "$latestVer" ]; then
    echo "R $latestVer available"
  else
    echo ""
  fi
}

r_ver

