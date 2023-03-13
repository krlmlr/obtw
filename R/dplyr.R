#' @export
obtw_check_df <- function(x, cond) {
  cond <- enquo(cond)
  pre_cnd <- force_with_check_restart(x)

  check <- dplyr::collect(dplyr::filter(x, ! (!!cond)))
  validate_if(
    nrow(check) > 0,
    paste0(nrow(check), " rows failed check: ", as_label(cond)),
    pre_cnd
  )

  x
}
