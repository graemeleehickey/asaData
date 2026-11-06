#' WHAS 100-Patient Dataset (Second Edition)
#'
#' The 100-patient Worcester Heart Attack Study dataset described in Table 1.1.
#'
#' @format A data frame with 100 rows and 9 variables:
#' \describe{
#'   \item{id}{Integer. Patient identifier, 1 to 100.}
#'   \item{admitdate}{Date. Hospital admission date, stored as an R Date.}
#'   \item{foldate}{Date. Date of death or last follow-up, stored as an R Date.}
#'   \item{los}{Integer. Length of hospital stay, in days.}
#'   \item{lenfol}{Integer. Follow-up from hospital admission to death or last follow-up, in days.}
#'   \item{fstat}{Integer. Vital status at last follow-up: 1 = dead; 0 = alive.}
#'   \item{age}{Integer. Age at admission, in years.}
#'   \item{gender}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{bmi}{Numeric. Body mass index, in kg/m^2.}
#' }
#' @details
#' Each row represents a patient. \code{lenfol} records mortality follow-up, with \code{fstat == 1} indicating death.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads and analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{whas}}, \code{\link{whas500}}
#' @references
#' UCLA Office of Advanced Research Computing. \href{https://stats.oarc.ucla.edu/stata/examples/asa2/applied-survival-analysis-by-hosmer-lemeshow-and-maychapter-2-descriptive-methods-for-survival-data/}{Applied Survival Analysis, second edition: Chapter 2, Stata examples}. Table 2.3 and Figure 2.2.
#' @seealso \code{vignette("survival-examples", package = "asaData")} for longer analyses.
#' @examples
#' data(whas100, package = "asaData")
#' if (requireNamespace("survival", quietly = TRUE)) {
#'   # Second edition, Table 2.3 and Figure 2.2: all-cause mortality.
#'   whas100_km <- survival::survfit(
#'     survival::Surv(lenfol, fstat == 1) ~ 1,
#'     data = whas100, conf.type = "log-log"
#'   )
#'   summary(whas100_km, times = c(6, 14, 44))
#'   plot(whas100_km, xscale = 365.25, conf.int = FALSE,
#'        xlab = "Years since admission", ylab = "Survival probability")
#' }
#' @keywords datasets
"whas100"
