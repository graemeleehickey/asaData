#' Recurrent Soreness Episodes
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
#' Each row represents a risk interval for one subject. There are 1,296 intervals from 400 subjects, with up to four intervals per subject. The interval is (\code{time0}, \code{time1}], and \code{censor == 1} indicates an episode at its end.
#'
#' The first- and second-edition files contain identical values and variable names. \code{recur} represents both editions using the second-edition file. The second-edition codebook specifies that \code{censor = 1} denotes an episode at \code{time1}.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#' @references
#' Hosmer, D. W., Jr. and Lemeshow, S. (1999). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. First edition. Wiley. ISBN 978-0-471-15410-5.
#'
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @examples
#' data(recur, package = "hoslemSurv")
#' length(unique(recur$id))
#' head(recur[order(recur$id, recur$time0), ])
#' @keywords datasets
"recur"
