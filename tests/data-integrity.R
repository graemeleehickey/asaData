# Checks on the installed data, including edition differences and outcome interpretation.
library(hoslemSurv)
expected <- list(
  hmohiv = c(100, 7), recur = c(1296, 7), uis = c(628, 12),
  whas = c(481, 14), whasncc_e1 = c(1494, 12),
  actg320 = c(1151, 16), actg320ncc = c(576, 7), bpd = c(78, 4),
  comprisk = c(453, 6), cvdrisk = c(65, 6), frtcs = c(697, 17),
  gbcs = c(686, 16), grace1000 = c(1000, 9),
  whas100 = c(100, 9), whas500 = c(500, 22),
  whasncc_e2 = c(1638, 11)
)
e <- new.env()
for (nm in names(expected)) {
  data(list = nm, package = "hoslemSurv", envir = e)
  x <- e[[nm]]
  stopifnot(is.data.frame(x), all(dim(x) == expected[[nm]]),
            identical(names(x), tolower(names(x))),
            !any(vapply(x, is.factor, logical(1))),
            all(vapply(x, function(z) is.numeric(z) || inherits(z, "Date"), logical(1))))
  for (v in intersect(c("censor", "censor_d", "death", "censrec", "censdead", "fstat", "dstat", "case"), names(x))) {
    stopifnot(all(x[[v]] %in% 0:1))
  }
}
stopifnot(setequal(data(package = "hoslemSurv")$results[, "Item"], names(expected)))

with(e$hmohiv, {
  stopifnot(inherits(entdate, "Date"), inherits(enddate, "Date"),
            all(round(as.numeric(enddate - entdate) / (365.25 / 12)) == time),
            sum(censor) == 80L)
})
stopifnot(identical(names(e$uis)[3L], "beck"),
          sum(complete.cases(e$uis)) == 575L)

local({
  x <- e$recur[order(e$recur$id, e$recur$time0), ]
  stopifnot(length(unique(x$id)) == 400L, all(x$time1 > x$time0), all(x$event %in% 1:4))
  groups <- split(x, x$id)
  stopifnot(all(vapply(groups, function(z) {
    n <- nrow(z)
    z$time0[1L] == 0 && all(z$event == seq_len(n)) &&
      (n == 1L || all(z$time0[-1L] == z$time1[-n]))
  }, logical(1))))
})
for (nm in c("whasncc_e1", "whasncc_e2", "actg320ncc")) {
  x <- e[[nm]]
  stopifnot(all(table(x$set) == 6L), all(tapply(x$case, x$set, sum) == 1L))
}
for (nm in c("whasncc_e1", "whasncc_e2")) {
  with(e[[nm]], {
    stopifnot(all(t[fstat == 0L] == lenfol[fstat == 0L]),
              all(t[fstat == 1L] <= lenfol[fstat == 1L]),
              all(t[fstat == 1L] > lenfol[fstat == 1L] - 1))
  })
}
with(e$whasncc_e1, stopifnot(sum(fstat == 1L & t == lenfol) == 18L,
                            max(lenfol - t) <= 0.01000001))
with(e$whasncc_e2, stopifnot(all(t[fstat == 1L] < lenfol[fstat == 1L])))
stopifnot(sum(is.na(e$whasncc_e1$nr)) == 858L,
          sum(is.na(e$whasncc_e2$nr)) == 1365L,
          all(is.na(e$whasncc_e2$nr) == (e$whasncc_e2$case == 0L)),
          length(unique(e$actg320ncc$id)) == 468L)

with(e$actg320, {
  stopifnot(length(unique(id)) == 1151L, max(id) == 1156L,
            all(tx == as.integer(txgrp %in% c(2L, 4L))), all(time <= time_d))
})
cases <- e$actg320ncc[e$actg320ncc$case == 1L, ]
cohort_cases <- e$actg320[e$actg320$censor == 1L, ]
stopifnot(setequal(cases$id, cohort_cases$id), nrow(cases) == 96L,
          sum(cohort_cases$censor_d) == 26L)
matched_cases <- merge(cases, cohort_cases, by = "id")
stopifnot(all(matched_cases$time.x < matched_cases$time.y),
          all(matched_cases$time.x > matched_cases$time.y - 1))
with(e$gbcs, {
  stopifnot(all(menopause %in% 1:2), all(hormone %in% 1:2),
            sum(menopause == 1L) == 290L, sum(hormone == 1L) == 440L,
            all(as.numeric(recdate - diagdate) == rectime),
            all(as.numeric(deathdate - diagdate) == survtime),
            min(prog_recp) == 0L, min(estrg_recp) == 0L)
})
with(e$whas100, stopifnot(all(as.numeric(foldate - admitdate) == lenfol)))
with(e$whas500, {
  stopifnot(all(as.numeric(disdate - admitdate) == los),
            all(as.numeric(fdate - admitdate) == lenfol),
            all(mitype %in% 0:1), all(year %in% 1:3))
})
stopifnot(all(e$whas$mitype %in% 1:3), all(e$whas$year %in% 1:6),
          all(e$cvdrisk$ev_typ %in% 0:2), all(e$comprisk$ev_typ %in% 0:2),
          identical(e$grace1000$id[e$grace1000$sysbp == 0], c(736L, 976L)),
          sum(is.na(e$frtcs$sbp2)) == 3L, sum(is.na(e$frtcs$dbp2)) == 3L)
with(e$grace1000, {
  different <- revasc == 0L & revascdays != days
  stopifnot(identical(id[different], c(206L, 363L, 401L, 485L, 670L, 976L)),
            all(days[different] == 0.5), all(revascdays[different] == 0))
})
# Verify that all original data files and codebooks are installed intact.
source_dir <- system.file("extdata", package = "hoslemSurv", mustWork = TRUE)
manifest <- read.csv(file.path(source_dir, "manifest.csv"), stringsAsFactors = FALSE)
stopifnot(nrow(manifest) == 18L, file.exists(file.path(source_dir, "schema.csv")))
for (i in seq_len(nrow(manifest))) {
  m <- manifest[i, ]
  paths <- file.path(source_dir, c(m$data_file, m$codebook))
  stopifnot(all(file.exists(paths)),
            identical(unname(tools::md5sum(paths)), c(m$data_md5, m$codebook_md5)))
}
cat("All 16 installed datasets and 36 original files passed integrity checks.\n")
