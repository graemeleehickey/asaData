#' ACTG 320 Trial (Second Edition)
#'
#' The 1,151-record ACTG 320 HIV treatment-trial dataset described in Table 1.5.
#'
#' @format A data frame with 1,151 rows and 16 variables:
#' \describe{
#'   \item{id}{Integer. Participant identifier. Values range from 1 to 1156, with five identifiers absent; there are 1151 supplied records.}
#'   \item{time}{Integer. Follow-up to an AIDS-defining diagnosis or death, or censoring, in days.}
#'   \item{censor}{Integer. Composite endpoint indicator: 1 = AIDS-defining diagnosis or death; 0 = censored.}
#'   \item{time_d}{Integer. Follow-up to death or censoring, in days.}
#'   \item{censor_d}{Integer. Death endpoint indicator: 1 = death; 0 = censored.}
#'   \item{tx}{Integer. Treatment indicator: 1 = regimen includes indinavir (IDV); 0 = regimen without IDV.}
#'   \item{txgrp}{Integer. Treatment regimen: 1 = ZDV + 3TC; 2 = ZDV + 3TC + IDV; 3 = d4T + 3TC; 4 = d4T + 3TC + IDV. ZDV denotes zidovudine, 3TC lamivudine, and d4T stavudine.}
#'   \item{strat2}{Integer. CD4 screening stratum: 0 = CD4 count at most 50; 1 = count above 50. Screening and baseline counts need not coincide.}
#'   \item{sex}{Integer. Recorded sex: 1 = male; 2 = female.}
#'   \item{raceth}{Integer. Recorded race/ethnicity: 1 = White non-Hispanic; 2 = Black non-Hispanic; 3 = Hispanic, regardless of race; 4 = Asian or Pacific Islander; 5 = American Indian or Alaskan Native; 6 = other/unknown. Code 6 is documented but absent in this file.}
#'   \item{ivdrug}{Integer. History of intravenous drug use: 1 = never; 2 = current; 3 = previous.}
#'   \item{hemophil}{Integer. Haemophilia indicator: 1 = yes; 0 = no.}
#'   \item{karnof}{Integer. Karnofsky Performance Scale: 100 = normal, no complaints or evidence of disease; 90 = normal activity possible with minor signs or symptoms; 80 = normal activity with effort and some signs or symptoms; 70 = self-care possible, but normal activity or active work not possible.}
#'   \item{cd4}{Numeric. Baseline CD4 count derived from multiple measurements. The accompanying codebook states cells/millilitre; this unit is reproduced as a source statement and has not been independently reconciled. Values are unscaled.}
#'   \item{priorzdv}{Numeric. Duration of prior zidovudine use, in months.}
#'   \item{age}{Integer. Age at enrolment, in years.}
#' }
#' @details
#' One row represents one trial participant. Two distinct endpoints are supplied: the composite AIDS/death endpoint (time, censor) and death alone (time_d, censor_d). Select the matching pair.
#'
#' The identifiers are retained without renumbering. No reason for the five missing identifiers is supplied. Screening stratum strat2 should not be reconstructed from cd4, which is a different baseline measure.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/actg320.dat}{edition2/actg320.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/actg320.txt}{edition2/actg320.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site} as the original download location.
#'
#' For the second edition, the \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page} provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{actg320ncc_e2}}
#' @examples
#' data(actg320_e2, package = "hoslemSurv")
#' str(actg320_e2)
#' head(actg320_e2)
#' @keywords datasets
"actg320_e2"
