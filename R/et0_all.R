#' Compute ET0 Using All 10 Temperature-Based Models and FAO Penman-Monteith
#'
#' A convenience wrapper that computes daily reference evapotranspiration using
#' all 10 temperature-based empirical models plus the FAO Penman-Monteith
#' standard method as the reference/base for comparison.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param RH_morning Morning relative humidity (percent). Used by Schendel,
#'   Linacre, and FAO Penman-Monteith.
#' @param RH_evening Evening relative humidity (percent). Used by Schendel,
#'   Linacre, and FAO Penman-Monteith.
#' @param u2 Wind speed at 2 m height (m/s). Used by FAO Penman-Monteith only.
#' @param n Actual sunshine hours. Used by FAO Penman-Monteith only.
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees, negative for Southern Hemisphere).
#' @param z Elevation above sea level (m). Used by Linacre and FAO
#'   Penman-Monteith. Default is 0.
#' @return A \code{data.frame} with 11 columns: \code{FAO_PM} (reference) plus
#'   one column per temperature-based model. The number of rows equals the
#'   length of the input vectors.
#' @details
#' The 10 temperature-based models included are:
#' \itemize{
#'   \item Blaney-Criddle (1950)
#'   \item Schendel (Bormann, 2011)
#'   \item Hargreaves-Samani (1985)
#'   \item Linacre (1977)
#'   \item Tabari-Talaee 1 (2011)
#'   \item Tabari-Talaee 2 (2011)
#'   \item Droogers-Allen (2002)
#'   \item Berti et al. (2014)
#'   \item Dorji et al. (2016)
#'   \item Baier-Robertson (1965)
#' }
#' The \strong{FAO Penman-Monteith} column serves as the standard reference
#' against which the temperature-based models can be evaluated using
#' \code{\link{evaluate_models}}.
#' @export
#' @examples
#' # Single day example
#' result <- et0_temp_all(Tmin = 15, Tmax = 30, RH_morning = 90,
#'                        RH_evening = 40, u2 = 1.5, n = 8,
#'                        J = 172, lat = 25.43, z = 216)
#' print(result)
et0_temp_all <- function(Tmin, Tmax, RH_morning, RH_evening, u2, n, J,
                         lat, z = 0) {
  Tmean  <- (Tmin + Tmax) / 2
  RH_mean <- (RH_morning + RH_evening) / 2

  result <- data.frame(
    # FAO Penman-Monteith (reference/base model)
    FAO_PM            = et0_fao_pm(Tmin, Tmax, RH_morning, RH_evening,
                                   u2, n, J, lat, z),

    # Temperature-based models
    Blaney_Criddle    = et0_blaney_criddle(Tmean),
    Schendel          = et0_schendel(Tmean, RH_mean),
    Hargreaves_Samani = et0_hargreaves_samani(Tmin, Tmax, J, lat),
    Linacre           = et0_linacre(Tmean, Tmin, Tmax, RH_morning,
                                    RH_evening, z, lat),
    Tabari_Talee1     = et0_tabari_talee1(Tmin, Tmax, J, lat),
    Tabari_Talee2     = et0_tabari_talee2(Tmin, Tmax, J, lat),
    Droogers_Allen    = et0_droogers_allen(Tmin, Tmax, J, lat),
    Berti             = et0_berti(Tmin, Tmax, J, lat),
    Dorji             = et0_dorji(Tmin, Tmax, J, lat),
    Baier_Robertson   = et0_baier_robertson(Tmin, Tmax, J, lat),

    stringsAsFactors = FALSE
  )

  result
}
