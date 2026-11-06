#' WHAS 500-Patient Dataset (Second Edition)
#'
#' The 500-patient Worcester Heart Attack Study dataset described in Table 1.2.
#'
#' @name whas500
#' @section Download:
#' Use \code{download_asa("whas500")} to retrieve this dataset. Data are not included in the package.
#' @format A data frame with 500 rows and 22 variables:
#' \describe{
#'   \item{id}{Integer. Patient identifier, 1 to 500.}
#'   \item{age}{Integer. Age at hospital admission, in years.}
#'   \item{gender}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{hr}{Integer. Initial heart rate, in beats per minute.}
#'   \item{sysbp}{Integer. Initial systolic blood pressure, in mmHg.}
#'   \item{diasbp}{Integer. Initial diastolic blood pressure, in mmHg.}
#'   \item{bmi}{Numeric. Body mass index, in kg/m^2.}
#'   \item{cvd}{Integer. History of cardiovascular disease: 0 = no; 1 = yes.}
#'   \item{afb}{Integer. Atrial fibrillation: 0 = no; 1 = yes.}
#'   \item{sho}{Integer. Cardiogenic shock: 0 = no; 1 = yes.}
#'   \item{chf}{Integer. Congestive heart failure complication: 0 = no; 1 = yes.}
#'   \item{av3}{Integer. Complete heart block: 0 = no; 1 = yes.}
#'   \item{miord}{Integer. Myocardial infarction order: 0 = first; 1 = recurrent.}
#'   \item{mitype}{Integer. Myocardial infarction type: 0 = non-Q-wave; 1 = Q-wave.}
#'   \item{year}{Integer. Cohort-year code: 1 = 1997; 2 = 1999; 3 = 2001.}
#'   \item{admitdate}{Date. Hospital admission date, stored as an R Date.}
#'   \item{disdate}{Date. Hospital discharge date, stored as an R Date.}
#'   \item{fdate}{Date. Date of death or last follow-up, stored as an R Date.}
#'   \item{los}{Integer. Length of hospital stay, in days, from admission to discharge.}
#'   \item{dstat}{Integer. Hospital discharge status: 0 = alive; 1 = dead.}
#'   \item{lenfol}{Integer. Total follow-up from admission to death or last follow-up, in days.}
#'   \item{fstat}{Integer. Vital status at last follow-up: 0 = alive; 1 = dead.}
#' }
#' @details
#' Each row represents a patient. \code{lenfol} and \code{fstat} record mortality follow-up; \code{los} and \code{dstat} record the hospital-discharge endpoint.
#'
#' The coding of \code{mitype} and \code{year} differs from that in \code{whas}.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads and analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{whas}}, \code{\link{whas100}}, \code{\link{whasncc_e2}}
#' @references
#' UCLA Office of Advanced Research Computing. \href{https://stats.oarc.ucla.edu/stata/examples/asa2/applied-survival-analysis-by-hosmer-lemeshow-and-maychapter-5-model-development/}{Applied Survival Analysis, second edition: Chapter 5, Stata examples}. Table 5.3.
#' @seealso \code{vignette("survival-examples", package = "asaData")} for longer analyses.
#' @examples
#' \dontrun{
#' whas500 <- download_asa("whas500")
#' if (requireNamespace("survival", quietly = TRUE)) {
#'   # Second edition, Table 5.3: all-cause mortality after admission.
#'   whas500_cox <- survival::coxph(
#'     survival::Surv(lenfol, fstat == 1) ~ age + hr + sysbp + diasbp + bmi +
#'       gender + cvd + afb + chf + miord + mitype,
#'     data = whas500, ties = "breslow"
#'   )
#'   summary(whas500_cox)
#' }
#' }
#' @keywords datasets
NULL
