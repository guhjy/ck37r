library(testthat)
try(detach(package:ck37r), silent = T)
library(ck37r)

context("Test tmle_parallel()")

# Use Causal Inference's lab 5 data as test data.
file = system.file("extdata", "RLab5.TMLE.csv", package = "ck37r")

data = read.csv(file)
str(data)

W = subset(data, select = -c(Y, A))

# Use multiple cores as available.
# CRAN check requires at most 2 cores.
parallel = setup_parallel_tmle(max_cores = 2)

# Basic SL library.
sl_lib = c("SL.mean", "SL.glm")

library(SuperLearner)

# Set a parallel-compatible seed so cross-validation folds are deterministic.
set.seed(1, "L'Ecuyer-CMRG")
result = run_tmle(Y = data$Y, A = data$A, W = W, family = "binomial",
                  g.SL.library = sl_lib, Q.SL.library = sl_lib,
                  verbose = T)
result
result$time

# Compare to normal tmle
set.seed(1, "L'Ecuyer-CMRG")
tmle = tmle::tmle(Y = data$Y, A = data$A, W = W, family = "binomial",
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

set.seed(1, "L'Ecuyer-CMRG")
# Test TMLE with conserve_memory disabled.
result2 = run_tmle(Y = data$Y, A = data$A, W = W, family = "binomial",
                  g.SL.library = sl_lib, Q.SL.library = sl_lib,
                  conserve_memory = F, verbose = T)
result2
result2$time

# Compare object sizes.
print(object.size(result), units = "MB")  # 1.3 MB
print(object.size(tmle), units = "MB")    # 0.5 MB
print(object.size(result2), units = "MB") # 8.2 MB
