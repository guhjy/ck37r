library(testthat)
try(detach(package:ckTools), silent = T)
library(ckTools)

context("Test tmle_parallel()")

# Use Causal Inference's lab 5 data as test data.
file = system.file("extdata", "RLab5.TMLE.csv", package = "ckTools")

data = read.csv(file)
str(data)

W = subset(data, select = -c(Y, A))

# Use multiple cores as available.
parallel = setup_parallel_tmle()

# Basic SL library.
sl_lib = c("SL.mean", "SL.glm")

# Set a parallel-compatible seed so cross-validation folds are deterministic.
set.seed(1, "L'Ecuyer-CMRG")
result = run_tmle(Y = data$Y, A = data$A, W = W, family = "binomial",
                  g.SL.library = sl_lib, Q.SL.library = sl_lib,
                  verbose = T)
result
result$time

# Compare to normal tmle
set.seed(1, "L'Ecuyer-CMRG")
tmle = tmle(Y = data$Y, A = data$A, W = W, family = "binomial",
                  g.SL.library = sl_lib, Q.SL.library = sl_lib)
tmle

test_that("Confirm replicability compared to tmle::tmle()", {
  # ATE estimates need to be within 2x of machine precision error.
  expect_lte(abs(tmle$estimates$ATE$psi - result$estimates$ATE$psi),
             .Machine$double.eps * 2)
  # Same with variance estimate.
  expect_lte(abs(tmle$estimates$ATE$var.psi - result$estimates$ATE$var.psi),
             .Machine$double.eps * 2)
})