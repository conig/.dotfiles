get_gh <- function(repo) {
  "https://github.com/{repo}.git" |>
    glue::glue() |>
    remotes::install_git()
}

update_packages <- function(...) {
  d.outdated <- old.packages() |> tibble::as_tibble()
  if (nrow(d.outdated) > 0) {
    pak::pak(d.outdated$Package)
  } else {
    cat("No outdated packages found.\n")
  }
}

local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cloud.r-project.org"
  options(repos = r)
})

# colorise output
if (interactive()) {
  suppressMessages(require("colorout", quietly = FALSE))
}

#' winpath
#'
#' Convert windows path to wsl
#' @param path character

winpath <- function(path) {
  drive_letter <- tolower(substr(path, 1, 1))
  remaining_path <- gsub("^[A-z]\\:\\/", "", path)
  wsl_path <- glue::glue("/mnt/{drive_letter}/{remaining_path}")
  wsl_path
}
options(languageserver.diagnostics = FALSE)
options(help_type = "html")

.First <- function() {
  if (interactive()) {
    message(paste0(crayon::yellow(R.version.string), "\n", crayon::silver(R.Version()$nickname, "󰌪")))
  }
}
options(prompt = "\033[34m󰅂 \033[0m")

update_width <- function() {
  width <- as.integer(system("tput cols", intern = TRUE))
  options(width = width)
}
if (interactive()) {
  update_width()
  options(setWidthOnResize = TRUE)
  # Set R graphics device positon and size
  options(device = function() X11(width = 6, height = 6, xpos = 1920, ypos = 0))
}
