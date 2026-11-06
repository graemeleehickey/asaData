#' Recurrent Soreness Episodes (Second Edition)
#'
#' Counting-process data from a hypothetical study of recurrent soreness episodes, used in the Chapter 9 exercises.
#'
#' @format A data frame with 1,296 rows and 7 variables:
#' \describe{
#'   \item{id}{Integer. Subject identifier, 1 to 400; repeated across intervals.}
#'   \item{age}{Integer. Age in years.}
#'   \item{treat}{Integer. Treatment assignment: 0 = new treatment; 1 = old treatment.}
#'   \item{time0}{Integer. Start of the risk interval, measured in days from the study time origin; the time of the previous episode, or zero for the first interval.}
#'   \item{time1}{Integer. End of the risk interval, measured in days from the same origin; the time of the next episode or censoring.}
#'   \item{censor}{Integer. Interval outcome: 1 = a soreness episode occurred at time1; 0 = censored at time1.}
#'   \item{event}{Integer. Episode or risk-interval number. The supplied values are 1 to 4; the codebook gives a possible range of 0 to 4.}
#' }
#' @details
#' There are 1,296 risk intervals from 400 subjects, with up to four intervals per subject. The interval is (time0, time1], and censor == 1 indicates an event at its end. Subject identifiers are not unique across rows.
#'
#' Rows retain the source ordering, which is not chronological within subject. Order by id and time0 when a method requires chronological records.
#'
#' The first- and second-edition files contain identical data values. Both versions are retained under explicit edition names. See \code{recur_e1}.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/recur.dat}{edition2/recur.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/recur.txt}{edition2/recur.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site} as the original download location.
#'
#' For the second edition, the \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page} provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{recur_e1}}
#' @examples
#' data(recur_e2, package = "hoslemSurv")
#' length(unique(recur_e2$id))
#' head(recur_e2[order(recur_e2$id, recur_e2$time0), ])
#' @keywords datasets
"recur_e2"
