## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----load---------------------------------------------------------------------
library(ET0TempModels)
data(jhansi_weather)
head(jhansi_weather)

## ----single-day---------------------------------------------------------------
# FAO Penman-Monteith (reference)
et0_fao_pm(Tmin = 15, Tmax = 30, RH_morning = 90, RH_evening = 40,
           u2 = 1.5, n = 8, J = 172, lat = 25.43, z = 216)

# Blaney-Criddle (needs only Tmean)
et0_blaney_criddle(Tmean = 22.5)

# Hargreaves-Samani (needs Tmin, Tmax, day of year, latitude)
et0_hargreaves_samani(Tmin = 15, Tmax = 30, J = 172, lat = 25.43)

## ----all-models---------------------------------------------------------------
result <- et0_temp_all(
  Tmin       = jhansi_weather$Tmin[1:5],
  Tmax       = jhansi_weather$Tmax[1:5],
  RH_morning = jhansi_weather$RH_morning[1:5],
  RH_evening = jhansi_weather$RH_evening[1:5],
  u2         = jhansi_weather$WS[1:5],
  n          = jhansi_weather$SSH[1:5],
  J          = jhansi_weather$J[1:5],
  lat        = 25.43,
  z          = 216
)
round(result, 2)

## ----evaluation---------------------------------------------------------------
# Compute ET0 for the full year
full_result <- et0_temp_all(
  Tmin       = jhansi_weather$Tmin,
  Tmax       = jhansi_weather$Tmax,
  RH_morning = jhansi_weather$RH_morning,
  RH_evening = jhansi_weather$RH_evening,
  u2         = jhansi_weather$WS,
  n          = jhansi_weather$SSH,
  J          = jhansi_weather$J,
  lat        = 25.43,
  z          = 216
)

# FAO-PM is the reference (observed)
obs   <- full_result$FAO_PM
preds <- full_result[, c("Blaney_Criddle", "Hargreaves_Samani",
                          "Linacre", "Droogers_Allen")]
metrics <- evaluate_models(obs, preds)
print(metrics)

## ----scatter, fig.width=6, fig.height=6---------------------------------------
plot_scatter(obs, preds,
             main = "Temperature-Based Models vs FAO-PM")

## ----taylor, fig.width=7, fig.height=7----------------------------------------
plot_taylor(obs, preds,
            main = "Taylor Diagram - Temperature-Based Models")

## ----helpers------------------------------------------------------------------
# Extraterrestrial radiation for June 21 at 25.43 N
extraterrestrial_radiation(J = 172, lat = 25.43)

# Saturation vapor pressure at 25 degrees C
saturation_vapor_pressure(25)

# Daylight hours for June 21 at 25.43 N
daylight_hours(J = 172, lat = 25.43)

