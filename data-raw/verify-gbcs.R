# Independently verify the GBCS category labels; TH.data is only needed for this check.
local({
  if (!requireNamespace("TH.data", quietly = TRUE)) stop("Install TH.data to run this optional comparison.")
  e <- new.env()
  cache_dir <- Sys.getenv("ASADATA_TEST_ARCHIVES",
                          unset = file.path(tempdir(), "asaData"))
  x <- asaData::download_asa("gbcs", cache_dir = cache_dir)
  utils::data("GBSG2", package = "TH.data", envir = e)
  y <- e$GBSG2
  y$grade <- as.integer(y$tgrade)
  matches <- merge(x, y,
    by.x = c("age", "size", "grade", "nodes", "prog_recp", "estrg_recp"),
    by.y = c("age", "tsize", "grade", "pnodes", "progrec", "estrec"))
  stopifnot(nrow(matches) == 686L, !anyDuplicated(matches$id),
            all(matches$rectime == matches$time),
            all(matches$menopause == ifelse(tolower(as.character(matches$menostat)) == "pre", 1L, 2L)),
            all(matches$hormone == ifelse(as.character(matches$horTh) == "no", 1L, 2L)))
  print(table(matches$menopause, matches$menostat))
  print(table(matches$hormone, matches$horTh))
  message("All 686 records matched uniquely using six baseline covariates; all recurrence times agree. TH.data version: ",
          utils::packageVersion("TH.data"))
})
