#' ET0TempModels: Evapotranspiration Estimation Using Temperature-Based Models
#'
#' The \pkg{ET0TempModels} package provides functions for estimating daily reference
#' evapotranspiration (ET0) using 10 temperature-based empirical models, with
#' the FAO Penman-Monteith method included as the standard reference for model
#' comparison. The package also includes statistical evaluation metrics and
#' visualization tools.
#'
#' @section Temperature-Based Models (10):
#' \describe{
#'   \item{Blaney-Criddle (1950)}{Requires only mean temperature.}
#'   \item{Schendel (Bormann, 2011)}{Requires mean temperature and relative humidity.}
#'   \item{Hargreaves-Samani (1985)}{Requires Tmin, Tmax, day of year, and latitude.}
#'   \item{Linacre (1977)}{Requires temperature, humidity, elevation, and latitude.}
#'   \item{Tabari-Talaee 1 (2011)}{Modified Hargreaves (coefficient 0.031).}
#'   \item{Tabari-Talaee 2 (2011)}{Modified Hargreaves (coefficient 0.0028).}
#'   \item{Droogers-Allen (2002)}{Modified Hargreaves with temperature range^0.4.}
#'   \item{Berti et al. (2014)}{Modified Hargreaves with temperature range^0.517.}
#'   \item{Dorji et al. (2016)}{Modified Hargreaves with temperature range^0.296.}
#'   \item{Baier-Robertson (1965)}{Regression-based using Ra, Tmax, and temperature range.}
#' }
#'
#' @section Key Functions:
#' \describe{
#'   \item{\code{\link{et0_temp_all}}}{Compute ET0 using all 10 temperature-based models + FAO PM.}
#'   \item{\code{\link{et0_fao_pm}}}{FAO Penman-Monteith reference method.}
#'   \item{\code{\link{evaluate_models}}}{Compute all 9 statistical metrics.}
#'   \item{\code{\link{plot_taylor}}}{Generate Taylor diagrams.}
#'   \item{\code{\link{plot_scatter}}}{Generate scatter plots.}
#' }
#'
#' @section Data:
#' The package includes a sample meteorological dataset
#' (\code{\link{jhansi_weather}}) from a semi-arid region in central India
#' for demonstrating package functionality.
#'
#' @references
#' Satpute, A.N., Barman, S., Singh, A.K., Ghosh, A., & Gupta, G. (2026).
#' A multi-scale evaluation of 30 empirical models for reference
#' evapotranspiration estimation in a data-scarce semi-arid region:
#' A case study of Jhansi, India.
#' Journal of Hydrology: Regional Studies.
#' \doi{10.1016/j.ejrh.2026.103925}
#'
#' Allen, R.G., Pereira, L.S., Raes, D., & Smith, M. (1998). Crop
#' evapotranspiration: Guidelines for computing crop water requirements.
#' FAO Irrigation and Drainage Paper No. 56.
#'
#' @docType package
#' @name ET0TempModels-package
#' @aliases ET0TempModels
#'
#' @importFrom graphics abline axis barplot box grid layout legend lines mtext par plot points polygon segments text title
#' @importFrom grDevices adjustcolor rainbow
#' @importFrom stats cor lm sd coef complete.cases
"_PACKAGE"
