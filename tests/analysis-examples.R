# Compare the executed help examples with the cited UCLA textbook results.
if (requireNamespace("survival", quietly = TRUE)) local({
  results <- new.env(parent = globalenv())
  figure_file <- tempfile(fileext = ".pdf")
  grDevices::pdf(figure_file)
  on.exit({
    grDevices::dev.off()
    unlink(figure_file)
  })

  for (topic in c("whas100", "bpd", "actg320", "gbcs", "uis",
                  "whas500", "grace1000")) {
    utils::example(topic, package = "asaData", character.only = TRUE,
                   local = results, echo = FALSE, ask = FALSE)
  }
  close_to <- function(actual, reference, tolerance = 5e-7) {
    stopifnot(length(actual) == length(reference), all(is.finite(actual)),
              max(abs(unname(actual) - reference)) <= tolerance)
  }

  # Chapter 2, Tables 2.3 and 2.17.
  close_to(summary(results$whas100_km, times = c(6, 14, 44))$surv,
           c(0.98, 0.97, 0.96), 1e-12)
  close_to(results$bpd_logrank$chisq, 5.62, 0.005)

  # Chapter 3, Table 3.2: the adjusted ACTG model.
  close_to(coef(results$actg_cox),
           c(-0.6589906, 0.0283562, 0.0972738, -0.0165767, -0.0002931))
  stopifnot(results$actg_cox$n == 1151L, results$actg_cox$nevent == 96L)

  # Chapter 4, Tables 4.11 and 4.12.
  close_to(coef(results$gbcs_cox), c(-0.3941755, 0.0149727, 0.0006522))
  close_to(coef(results$uis_cox), 0.3210045)
  stopifnot(results$gbcs_cox$n == 686L, results$gbcs_cox$nevent == 299L,
            results$uis_cox$n == 605L, results$uis_cox$nevent == 489L)

  # Chapter 5, Table 5.3.
  close_to(coef(results$whas500_cox),
           c(0.0486034, 0.0104108, 0.0003598, -0.0105894, -0.0437268,
             -0.2705711, 0.0073416, 0.1280092, 0.7735398, 0.0438507,
             -0.1641189))
  stopifnot(results$whas500_cox$n == 500L,
            results$whas500_cox$nevent == 215L)

  # Chapter 7, Table 7.6: treatment changes at the procedure time.
  close_to(coef(results$grace_cox),
           c(-0.2609491, -0.2020569, -0.2146887, 0.500509))
  stopifnot(nrow(results$grace_intervals) == 1359L,
            length(unique(results$grace_intervals$id)) == 1000L,
            results$grace_cox$nevent == 324L,
            sum(results$grace_intervals$tstop -
                  results$grace_intervals$tstart) == 109847.5)
  cat("All seven help examples matched the cited published results.\n")
})
