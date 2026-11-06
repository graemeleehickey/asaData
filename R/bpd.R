#' Bronchopulmonary Dysplasia Data (Second Edition)
#'
#' Oxygen-use follow-up for 78 subjects in the BPD dataset used in Chapter 2.
#'
#' @name bpd
#' @section Download:
#' Use \code{download_asa("bpd")} to retrieve this dataset. Data are not included in the package.
#' @format A data frame with 78 rows and 4 variables:
#' \describe{
#'   \item{id}{Integer. Subject identifier, 1 to 78.}
#'   \item{surfact}{Integer. Surfactant use: 0 = no; 1 = yes.}
#'   \item{ondays}{Integer. Time on oxygen, in days, to discontinuation or the end of follow-up.}
#'   \item{censor}{Integer. Outcome indicator: 1 = off oxygen; 0 = still on oxygen at study end.}
#' }
#' @details
#' Each row represents a subject. \code{ondays} records time on oxygen, and \code{censor == 1} indicates discontinuation of oxygen.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads and analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @references
#' UCLA Office of Advanced Research Computing. \href{https://stats.oarc.ucla.edu/stata/examples/asa2/applied-survival-analysis-by-hosmer-lemeshow-and-maychapter-2-descriptive-methods-for-survival-data/}{Applied Survival Analysis, second edition: Chapter 2, Stata examples}. Figure 2.11 and Table 2.17.
#' @seealso \code{vignette("survival-examples", package = "asaData")} for longer analyses.
#' @examples
#' \dontrun{
#' bpd <- download_asa("bpd")
#' if (requireNamespace("survival", quietly = TRUE)) {
#'   # Second edition, Figure 2.11 and Table 2.17: time to oxygen discontinuation.
#'   bpd_km <- survival::survfit(
#'     survival::Surv(ondays, censor == 1) ~ surfact, data = bpd
#'   )
#'   plot(bpd_km, col = c("#0072B2", "#D55E00"), lty = 1:2,
#'        conf.int = FALSE, xlab = "Days on oxygen",
#'        ylab = "Probability of remaining on oxygen")
#'   legend("topright", c("No surfactant", "Surfactant"),
#'          col = c("#0072B2", "#D55E00"), lty = 1:2, bty = "n")
#'   bpd_logrank <- survival::survdiff(
#'     survival::Surv(ondays, censor == 1) ~ surfact, data = bpd
#'   )
#'   bpd_logrank
#' }
#' }
#' @keywords datasets
NULL
