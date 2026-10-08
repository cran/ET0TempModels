# Test parameters representing a typical semi-arid summer day
Tmin <- 25
Tmax <- 40
Tmean <- (Tmin + Tmax) / 2
RH_morning <- 70
RH_evening <- 30
RH_mean <- (RH_morning + RH_evening) / 2
u2 <- 1.5
n <- 9
J <- 172  # June 21
lat <- 25.43
z <- 216

# --- FAO Penman-Monteith (reference/base model) ---
test_that("et0_fao_pm returns positive values", {
  result <- et0_fao_pm(Tmin, Tmax, RH_morning, RH_evening, u2, n, J, lat, z)
  expect_true(result > 0)
  expect_true(result < 20)  # Reasonable upper bound
})

test_that("et0_fao_pm is vectorized", {
  result <- et0_fao_pm(
    Tmin = c(10, 20, 25),
    Tmax = c(25, 35, 40),
    RH_morning = c(90, 80, 70),
    RH_evening = c(50, 40, 30),
    u2 = c(1, 1.5, 2),
    n = c(7, 8, 9),
    J = c(15, 91, 172),
    lat = 25.43, z = 216
  )
  expect_length(result, 3)
  expect_true(all(result > 0))
})

# --- Temperature-based models ---
test_that("temperature-based models return positive values", {
  expect_true(et0_blaney_criddle(Tmean) > 0)
  expect_true(et0_schendel(Tmean, RH_mean) > 0)
  expect_true(et0_hargreaves_samani(Tmin, Tmax, J, lat) > 0)
  expect_true(et0_linacre(Tmean, Tmin, Tmax, RH_morning, RH_evening,
                           z, lat) > 0)
  expect_true(et0_tabari_talee1(Tmin, Tmax, J, lat) > 0)
  expect_true(et0_tabari_talee2(Tmin, Tmax, J, lat) > 0)
  expect_true(et0_droogers_allen(Tmin, Tmax, J, lat) > 0)
  expect_true(et0_berti(Tmin, Tmax, J, lat) > 0)
  expect_true(et0_dorji(Tmin, Tmax, J, lat) > 0)
  expect_true(et0_baier_robertson(Tmin, Tmax, J, lat) > 0)
})

test_that("Blaney-Criddle formula is correct", {
  expected <- 0.274 * (0.46 * Tmean + 8.13)
  expect_equal(et0_blaney_criddle(Tmean), expected)
})

test_that("Schendel formula is correct", {
  expected <- 16 * Tmean / RH_mean
  expect_equal(et0_schendel(Tmean, RH_mean), expected)
})

# --- Wrapper function ---
test_that("et0_temp_all returns correct structure", {
  result <- et0_temp_all(Tmin, Tmax, RH_morning, RH_evening, u2, n, J, lat, z)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_equal(ncol(result), 11)  # FAO_PM + 10 temperature-based models
  expect_true("FAO_PM" %in% names(result))
  expect_true("Blaney_Criddle" %in% names(result))
  expect_true("Hargreaves_Samani" %in% names(result))
  expect_true("Baier_Robertson" %in% names(result))
  expect_true(all(result > -5))  # All values should be reasonable
})

test_that("et0_temp_all handles vectorized input", {
  result <- et0_temp_all(
    Tmin = c(10, 25),
    Tmax = c(25, 40),
    RH_morning = c(90, 70),
    RH_evening = c(50, 30),
    u2 = c(1, 1.5),
    n = c(7, 9),
    J = c(15, 172),
    lat = 25.43, z = 216
  )
  expect_equal(nrow(result), 2)
  expect_equal(ncol(result), 11)
})
