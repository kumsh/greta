# Create objects of class 'unknowns' to nicely print ? valued arrays

as.unknowns <- function(x) {  # nolint
  UseMethod("as.unknowns")
}

as.unknowns.unknowns <- function(x) {  # nolint
  x
}
as.unknowns.array <- function(x) {  # nolint
  class(x) <- c("unknowns", class(x))
  x
}

as.unknowns.matrix <- function(x) {  # nolint
  as.unknowns.array(x)
}

strip_unknown_class <- function(x) {
  classes <- class(x)
  classes <- classes[classes != "unknowns"]
  class(x) <- classes
  x
}

#' @export
print.unknowns <- function(x, ...) {
  # remove 'unknown' class attribute
  x <- strip_unknown_class(x)

  # set NA values to ? for printing
  x[is.na(x)] <- " ?"

  # print with question marks
  print.default(x, quote = FALSE, ...)

}

# create an unknowns array from some dimensions
unknowns <- function(dims = c(1, 1), data = as.numeric(NA)) {
  x <- array(data = data, dim = dims)
  as.unknowns(x)
}

# set dims like on a matrix/array
`dim<-.unknowns` <- function(x, value) {  # nolint
  x <- strip_unknown_class(x)
  dim(x) <- value
  as.unknowns(x)
}

unknowns_module <- module(unknowns,
                          as.unknowns,
                          strip_unknown_class)
