#' UMass Impact Study of Drug Treatment
#'
#' Drug-treatment follow-up data for 628 participants in the UMass Impact Study (UIS), described in Table 1.3.
#'
#' @format A data frame with 628 rows and 12 variables:
#' \describe{
#'   \item{id}{Integer. Participant identifier, 1 to 628.}
#'   \item{age}{Integer. Age at enrolment, in years. Missing values: 5.}
#'   \item{beck}{Numeric. Beck Depression Score at admission, from 0 to 54. Missing values: 33.}
#'   \item{hercoc}{Integer. Heroin/cocaine use during the three months before admission: 1 = both heroin and cocaine; 2 = heroin only; 3 = cocaine only; 4 = neither. Missing values: 18.}
#'   \item{ivhx}{Integer. History of intravenous drug use at admission: 1 = never; 2 = previous; 3 = recent. Missing values: 18.}
#'   \item{ndrugtx}{Integer. Number of previous drug treatments, from 0 to 40. Missing values: 17.}
#'   \item{race}{Integer. Recorded race: 0 = White; 1 = other, using the terminology of the second-edition codebook. Missing values: 6.}
#'   \item{treat}{Integer. Randomised treatment assignment: 0 = short programme; 1 = long programme.}
#'   \item{site}{Integer. Treatment site: 0 = A; 1 = B.}
#'   \item{los}{Integer. Length of stay in treatment, in days from admission to treatment exit.}
#'   \item{time}{Integer. Time from admission to the recorded drug-use endpoint or end of follow-up, in days.}
#'   \item{censor}{Integer. Event indicator: 1 = returned to drug use; 0 = otherwise, following the second-edition codebook. See the edition comparison below.}
#' }
#' @details
#' Each row represents a participant. There are 628 records, of which 575 have complete data.
#'
#' The two editions contain identical values in the same row and column order. \code{uis} represents both editions using second-edition variable names. The depression-score column is \code{becktota} in the first edition and \code{beck} in the second; this dataset uses \code{beck}.
#'
#' The first-edition codebook defines \code{censor = 1} as return to drug use or loss to follow-up. The second-edition codebook describes the same indicator as return to drug use. For \code{race = 1}, the first edition uses the label non-White, and the second uses other.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads and analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr. and Lemeshow, S. (1999). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. First edition. Wiley. ISBN 978-0-471-15410-5.
#'
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @examples
#' data(uis, package = "hoslemSurv")
#' sum(complete.cases(uis))
#' colSums(is.na(uis))
#' @keywords datasets
"uis"
