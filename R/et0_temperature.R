#' @title Temperature-Based ET0 Models
#' @name temperature_models
#' @description Functions implementing 10 temperature-based empirical models
#'   for reference evapotranspiration (ET0) estimation.
NULL

#' Blaney-Criddle ET0 Model
#'
#' Estimates daily ET0 using the Blaney-Criddle (1950) method, which relies
#' only on mean air temperature.
#'
#' @param Tmean Mean air temperature (degrees Celsius).
#' @return Daily ET0 (mm/day).
#' @references Blaney, H.F. & Criddle, W.D. (1950). Determining water
#'   requirements in irrigated areas from climatological and irrigation data.
#'   USDA Soil Conservation Service, SCS-TP 96.
#' @family temperature models
#' @export
#' @examples
#' et0_blaney_criddle(25)
et0_blaney_criddle <- function(Tmean) {
  0.274 * (0.46 * Tmean + 8.13)
}

#' Schendel ET0 Model
#'
#' Estimates daily ET0 using the Schendel method (Bormann, 2011), which uses
#' mean temperature and relative humidity.
#'
#' @param Tmean Mean air temperature (degrees Celsius).
#' @param RH Mean relative humidity (percent).
#' @return Daily ET0 (mm/day).
#' @references Bormann, H. (2011). Sensitivity analysis of 18 different
#'   potential evapotranspiration models to observed climatic change at German
#'   climate stations. Climatic Change, 104(3), 729-753.
#' @family temperature models
#' @export
#' @examples
#' et0_schendel(25, 60)
et0_schendel <- function(Tmean, RH) {
  16 * Tmean / RH
}

#' Hargreaves-Samani ET0 Model
#'
#' Estimates daily ET0 using the Hargreaves-Samani (1985) method based on
#' temperature range and extraterrestrial radiation.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Hargreaves, G.H. & Samani, Z.A. (1985). Reference crop
#'   evapotranspiration from temperature. Applied Engineering in Agriculture,
#'   1(2), 96-99.
#' @family temperature models
#' @export
#' @examples
#' et0_hargreaves_samani(15, 30, 172, 25.43)
et0_hargreaves_samani <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  0.023 * 0.408 * Ra * (Tmean + 17.8) * sqrt(pmax(Tmax - Tmin, 0))
}

#' Linacre ET0 Model
#'
#' Estimates daily ET0 using the Linacre (1977) method, which accounts for
#' altitude, latitude and dew point depression.
#'
#' @param Tmean Mean air temperature (degrees Celsius).
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param RH_morning Morning relative humidity (percent).
#' @param RH_evening Evening relative humidity (percent).
#' @param z Elevation above sea level (m).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Linacre, E.T. (1977). A simple formula for estimating
#'   evaporation rates in various climates, using temperature data alone.
#'   Agricultural Meteorology, 18(6), 409-424.
#' @family temperature models
#' @export
#' @examples
#' et0_linacre(25, 15, 35, 90, 40, 216, 25.43)
et0_linacre <- function(Tmean, Tmin, Tmax, RH_morning, RH_evening, z, lat) {
  ea <- actual_vapor_pressure(Tmin, Tmax, RH_morning, RH_evening)
  Td <- dew_point_temperature(ea)
  numerator <- (700 * (Tmean + 0.006 * z) / (100 - lat)) +
    15 * (Tmean - Td)
  denominator <- 80 - Tmean
  numerator / denominator
}

#' Tabari-Talaee Model 1 ET0
#'
#' Estimates daily ET0 using the first Tabari and Talaee (2011) modified
#' Hargreaves equation with coefficient 0.031.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Tabari, H. & Talaee, P.H. (2011). Local calibration of the
#'   Hargreaves and Priestley-Taylor equations for estimating reference
#'   evapotranspiration in arid and cold climates of Iran based on the
#'   Penman-Monteith model. Journal of Hydrologic Engineering, 16(10), 837-845.
#' @family temperature models
#' @export
#' @examples
#' et0_tabari_talee1(15, 30, 172, 25.43)
et0_tabari_talee1 <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  lambda <- latent_heat(Tmean)
  0.031 * Ra * (Tmean + 17.8) * sqrt(pmax(Tmax - Tmin, 0)) / lambda
}

#' Tabari-Talaee Model 2 ET0
#'
#' Estimates daily ET0 using the second Tabari and Talaee (2011) modified
#' Hargreaves equation with coefficient 0.0028.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Tabari, H. & Talaee, P.H. (2011). Local calibration of the
#'   Hargreaves and Priestley-Taylor equations for estimating reference
#'   evapotranspiration in arid and cold climates of Iran based on the
#'   Penman-Monteith model. Journal of Hydrologic Engineering, 16(10), 837-845.
#' @family temperature models
#' @export
#' @examples
#' et0_tabari_talee2(15, 30, 172, 25.43)
et0_tabari_talee2 <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  lambda <- latent_heat(Tmean)
  0.0028 * Ra * (Tmean + 17.8) * sqrt(pmax(Tmax - Tmin, 0)) / lambda
}

#' Droogers-Allen ET0 Model
#'
#' Estimates daily ET0 using the Droogers and Allen (2002) method, a modified
#' Hargreaves formula using the temperature range raised to the power 0.4.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Droogers, P. & Allen, R.G. (2002). Estimating reference
#'   evapotranspiration under inaccurate data conditions. Irrigation and
#'   Drainage Systems, 16(1), 33-45.
#' @family temperature models
#' @export
#' @examples
#' et0_droogers_allen(15, 30, 172, 25.43)
et0_droogers_allen <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  lambda <- latent_heat(Tmean)
  0.003 * Ra * (Tmean + 20) * (pmax(Tmax - Tmin, 0))^0.4 / lambda
}

#' Berti et al. ET0 Model
#'
#' Estimates daily ET0 using the Berti et al. (2014) method, a modified
#' Hargreaves formula using the temperature range raised to the power 0.517.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Berti, A., Tardivo, G., Chiaudani, A., Rech, F., & Borin, M.
#'   (2014). Assessing reference evapotranspiration by the Hargreaves
#'   method in north-eastern Italy. Agricultural Water Management, 140, 20-25.
#' @family temperature models
#' @export
#' @examples
#' et0_berti(15, 30, 172, 25.43)
et0_berti <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  lambda <- latent_heat(Tmean)
  0.00193 * Ra * (Tmean + 17.8) * (pmax(Tmax - Tmin, 0))^0.517 / lambda
}

#' Dorji et al. ET0 Model
#'
#' Estimates daily ET0 using the Dorji et al. (2016) method, a modified
#' Hargreaves formula using the temperature range raised to the power 0.296.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Dorji, U., Olesen, J.E., & Seidenkrantz, M.S. (2016). Water
#'   balance in the complex mountainous terrain of Bhutan and linkages to land
#'   use. Journal of Hydrology: Regional Studies, 7, 55-68.
#' @family temperature models
#' @export
#' @examples
#' et0_dorji(15, 30, 172, 25.43)
et0_dorji <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  lambda <- latent_heat(Tmean)
  0.002 * Ra * (Tmean + 33.9) * (pmax(Tmax - Tmin, 0))^0.296 / lambda
}

#' Baier-Robertson ET0 Model
#'
#' Estimates daily ET0 using the Baier and Robertson (1965) method, a
#' regression-based equation using extraterrestrial radiation, maximum
#' temperature and temperature range.
#'
#' @param Tmin Minimum air temperature (degrees Celsius).
#' @param Tmax Maximum air temperature (degrees Celsius).
#' @param J Day of the year (1-366).
#' @param lat Latitude (degrees).
#' @return Daily ET0 (mm/day).
#' @references Baier, W. & Robertson, G.W. (1965). Estimation of latent
#'   evaporation from simple weather observations. Canadian Journal of Plant
#'   Science, 45(3), 276-284.
#' @family temperature models
#' @export
#' @examples
#' et0_baier_robertson(15, 30, 172, 25.43)
et0_baier_robertson <- function(Tmin, Tmax, J, lat) {
  Tmean <- (Tmin + Tmax) / 2
  Ra <- extraterrestrial_radiation(J, lat)
  lambda <- latent_heat(Tmean)
  0.109 * (Ra / lambda) + 0.157 * Tmax + 0.158 * (Tmax - Tmin) - 5.39
}
