#' @export
cnd_footer.obtw_error <- function(cnd, ...) {
  if (is.null(cnd$other_cnd)) {
    character()
  } else {
    c(
      paste0(length(cnd$other_cnd), " other failing check(s):"),
      unlist(lapply(cnd$other_cnd, format, backtrace = FALSE))
    )
  }
}
