# ET0TempModels

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/ET0TempModels)](https://CRAN.R-project.org/package=ET0TempModels)
[![R-CMD-check](https://github.com/samirigfri/ET0TempModels/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/samirigfri/ET0TempModels/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**ET0TempModels** provides 10 temperature-based empirical models for estimating
daily reference evapotranspiration (ET0), along with the FAO Penman-Monteith
standard method as the reference, statistical evaluation metrics, and
visualization tools.

## Installation

Install from CRAN:

```r
install.packages("ET0TempModels")
```

Or install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("ajaysatpute/ET0TempModels")
```

## Quick Start

```r
library(ET0TempModels)

# Compute ET0 using all 10 temperature-based models for a single day
result <- et0_temp_all(
  Tmin = 15, Tmax = 30,
  RH_morning = 90, RH_evening = 40,
  u2 = 1.5, n = 8, J = 172,
  lat = 25.43, z = 216
)

# Evaluate model performance against FAO-PM
data(jhansi_weather)
full <- et0_temp_all(
  Tmin       = jhansi_weather$Tmin,
  Tmax       = jhansi_weather$Tmax,
  RH_morning = jhansi_weather$RH_morning,
  RH_evening = jhansi_weather$RH_evening,
  u2         = jhansi_weather$WS,
  n          = jhansi_weather$SSH,
  J          = jhansi_weather$J,
  lat = 25.43, z = 216
)

metrics <- evaluate_models(full$FAO_PM, full[, -1])
print(metrics)
```

## Models Included

| # | Model | Function |
|---|-------|----------|
| Reference | FAO Penman-Monteith | `et0_fao_pm()` |
| 1 | Blaney-Criddle (1950) | `et0_blaney_criddle()` |
| 2 | Schendel (Bormann, 2011) | `et0_schendel()` |
| 3 | Hargreaves-Samani (1985) | `et0_hargreaves_samani()` |
| 4 | Linacre (1977) | `et0_linacre()` |
| 5 | Tabari-Talaee 1 (2011) | `et0_tabari_talee1()` |
| 6 | Tabari-Talaee 2 (2011) | `et0_tabari_talee2()` |
| 7 | Droogers-Allen (2002) | `et0_droogers_allen()` |
| 8 | Berti et al. (2014) | `et0_berti()` |
| 9 | Dorji et al. (2016) | `et0_dorji()` |
| 10 | Baier-Robertson (1965) | `et0_baier_robertson()` |

## Citation

```r
citation("ET0TempModels")
```

Singh, A.K., Satpute, A.N., Gupta, G., Ghosh, A., & Barman, S. (2026). A Comprehensive Multi-Scale Evaluation and Ranking of 30 Empirical Models for Reference Evapotranspiration Estimation in a Data-Scarce Semi-Arid Region. *Journal of Hydrology: Regional Studies*.

## License

GPL (>= 3)
