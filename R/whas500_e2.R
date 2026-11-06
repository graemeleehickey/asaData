#' WHAS 500-Patient Dataset (Second Edition)
#'
#' The 500-patient Worcester Heart Attack Study dataset described in Table 1.2.
#'
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
#'   \item{chf}{Integer. Congestive heart failure complication: 0 = no; 1 = yes. The source codebook abbreviates the description as congestive heart complications.}
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
#' One row represents one patient. For total mortality follow-up use lenfol with event indicator fstat == 1. The pair los and dstat describes the hospital-discharge endpoint.
#'
#' Dates are parsed from month/day/four-digit-year strings. Values and category codes are retained as supplied. In particular, mitype and year have different coding from whas_e1.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/whas500.dat}{edition2/whas500.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/whas500.txt}{edition2/whas500.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the Wiley companion FTP site as the original source.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{whas_e1}}, \code{\link{whas100_e2}}, \code{\link{whasncc_e2}}
#' @examples
#' data(whas500_e2, package = "hoslemSurv")
#' str(whas500_e2)
#' head(whas500_e2)
#' @keywords datasets
"whas500_e2"
