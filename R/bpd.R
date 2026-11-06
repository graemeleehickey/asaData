#' Bronchopulmonary Dysplasia Data (Second Edition)
#'
#' Oxygen-use follow-up for 78 subjects in the BPD dataset used in Chapter 2.
#'
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
#' @examples
#' data(bpd, package = "asaData")
#' str(bpd)
#' head(bpd)
#' @keywords datasets
"bpd"
