#' ACTG 320 Trial (Second Edition)
#'
#' The 1,151-record ACTG 320 HIV treatment-trial dataset described in Table 1.5.
#'
#' @name actg320
#' @section Download:
#' Use \code{download_asa("actg320")} to retrieve this dataset. Data are not included in the package.
#' @format A data frame with 1,151 rows and 16 variables:
#' \describe{
#'   \item{id}{Integer. Participant identifier.}
#'   \item{time}{Integer. Follow-up to an AIDS-defining diagnosis or death, or censoring, in days.}
#'   \item{censor}{Integer. Composite endpoint indicator: 1 = AIDS-defining diagnosis or death; 0 = censored.}
#'   \item{time_d}{Integer. Follow-up to death or censoring, in days.}
#'   \item{censor_d}{Integer. Death endpoint indicator: 1 = death; 0 = censored.}
#'   \item{tx}{Integer. Treatment indicator: 1 = regimen includes indinavir (IDV); 0 = regimen without IDV.}
#'   \item{txgrp}{Integer. Treatment regimen: 1 = ZDV + 3TC; 2 = ZDV + 3TC + IDV; 3 = d4T + 3TC; 4 = d4T + 3TC + IDV. ZDV denotes zidovudine, 3TC lamivudine, and d4T stavudine.}
#'   \item{strat2}{Integer. CD4 screening stratum: 0 = CD4 count at most 50; 1 = count above 50.}
#'   \item{sex}{Integer. Recorded sex: 1 = male; 2 = female.}
#'   \item{raceth}{Integer. Recorded race/ethnicity: 1 = White non-Hispanic; 2 = Black non-Hispanic; 3 = Hispanic, regardless of race; 4 = Asian or Pacific Islander; 5 = American Indian or Alaskan Native; 6 = other/unknown.}
#'   \item{ivdrug}{Integer. History of intravenous drug use: 1 = never; 2 = current; 3 = previous.}
#'   \item{hemophil}{Integer. Haemophilia indicator: 1 = yes; 0 = no.}
#'   \item{karnof}{Integer. Karnofsky Performance Scale: 100 = normal, no complaints or evidence of disease; 90 = normal activity possible with minor signs or symptoms; 80 = normal activity with effort and some signs or symptoms; 70 = self-care possible, but normal activity or active work not possible.}
#'   \item{cd4}{Numeric. Baseline CD4 count derived from multiple measurements, in cells/millilitre as stated in the codebook.}
#'   \item{priorzdv}{Numeric. Duration of prior zidovudine use, in months.}
#'   \item{age}{Integer. Age at enrolment, in years.}
#' }
#' @details
#' Each row represents a trial participant. The composite AIDS/death endpoint is recorded in \code{time} and \code{censor}; the mortality endpoint is recorded in \code{time_d} and \code{censor_d}.
#'
#' \code{strat2} records the screening CD4 stratum, and \code{cd4} records the baseline CD4 measurement.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads and analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{actg320ncc}}
#' @references
#' UCLA Office of Advanced Research Computing. \href{https://stats.oarc.ucla.edu/stata/examples/asa2/applied-survival-analysis-by-hosmer-lemeshow-and-maychapter-3-regression-models-for-survival-data/}{Applied Survival Analysis, second edition: Chapter 3, Stata examples}. Table 3.2.
#' @seealso \code{vignette("survival-examples", package = "asaData")} for longer analyses.
#' @examples
#' \dontrun{
#' actg320 <- download_asa("actg320")
#' library(survival)
#' # Second edition, Table 3.2: AIDS-defining diagnosis or death.
#' actg_cox <- coxph(
#'   Surv(time, censor == 1) ~ tx + age + sex + cd4 + priorzdv,
#'   data = actg320, ties = "breslow"
#' )
#' summary(actg_cox)
#' }
#' @keywords datasets
NULL
