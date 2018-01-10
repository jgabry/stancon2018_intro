## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.align="center")

## ----load-packages, message=FALSE, warning=FALSE-------------------------
library("rstan")
library("ggplot2")
library("bayesplot")

theme_set(bayesplot::theme_default())

## ----count-data, fig.width = 4, fig.height = 4, message=FALSE------------
# Loads vector of counts 'y'
source("count-data.R")

N <- length(y)
print(N)
print(y)
qplot(y)

## ----plot-x, fig.width = 4, fig.height = 4, message=FALSE----------------
x <- rpois(N, lambda = mean(y))
qplot(x)

## ----plot-y-x, message=FALSE---------------------------------------------
plotdata <- data.frame(
  value = c(y, x), 
  variable = rep(c("Our data", "Poisson data"), each = N)
)

# Frequency polygons
ggplot(plotdata, aes(x = value, color = variable)) + 
  geom_freqpoly(binwidth = 0.5) +
  scale_x_continuous(name = "", breaks = 0:max(x,y)) +
  scale_color_manual(name = "", values = c("gray30", "purple"))

# Side by side bar plots
ggplot(plotdata, aes(x = value, fill = variable)) + 
  geom_bar(position = "dodge") +
  scale_x_continuous(name = "", breaks = 0:max(x,y)) +
  scale_fill_manual(name = "", values = c("gray30", "purple"))

## ---- comment=NA---------------------------------------------------------
# first stan program

# knitr::purl() from Rmd
## ---- fit, results="hide", warning=FALSE, message=FALSE------------------
fit <- stan("poisson-simple.stan", data = list(N = N, y = y))
print(fit)

## ---- plot-lambda--------------------------------------------------------
color_scheme_set("brightblue") # check out ?bayesplot::color_scheme_set
lambda_draws <- as.matrix(fit, pars = "lambda")
mcmc_areas(lambda_draws, prob = 0.8) # color 80% interval

## ---- print-fit----------------------------------------------------------
means <- c("Posterior mean" = mean(lambda_draws), "Data mean" = mean(y))
print(means, digits = 3)

## ----y_rep---------------------------------------------------------------
y_rep <- as.matrix(fit, pars = "y_rep")

# number of rows = number of post-warmup posterior draws
# number of columns = length(y)
dim(y_rep) 

## ----ppc-hist, message=FALSE---------------------------------------------
ppc_hist(y, y_rep[1:8, ], binwidth = 1)

## ----ppc-dens-overlay----------------------------------------------------
ppc_dens_overlay(y, y_rep[1:50, ])

## ----prop-zero, message=FALSE--------------------------------------------
prop_zero <- function(x) mean(x == 0)
print(prop_zero(y))

ppc_stat(y, y_rep, stat = "prop_zero")

## ----stat-2d-------------------------------------------------------------
ppc_stat_2d(y, y_rep, stat = c("mean", "sd"))

## ---- predictive-errors--------------------------------------------------
ppc_error_hist(y, y_rep[1:4, ], binwidth = 1) + 
  xlim(-15, 15) + 
  vline_0()

## ---- comment=NA---------------------------------------------------------
# second stan program

## ----fit-2, results="hide", message=FALSE, warning=FALSE-----------------
fit2 <- stan("poisson-hurdle.stan", data = list(y = y, N = N))

## ---- print-fit2---------------------------------------------------------
print(fit2, pars = c("lambda", "theta"))

## ---- compare-lambdas----------------------------------------------------
lambda_draws2 <- as.matrix(fit2, pars = "lambda")
lambdas <- cbind(lambda_fit1 = lambda_draws[, 1],
                 lambda_fit2 = lambda_draws2[, 1])

color_scheme_set("red")
mcmc_areas(lambdas, prob = 0.8) # color 80% interval

## ----ppc-hist-2, message=FALSE-------------------------------------------
y_rep2 <- as.matrix(fit2, pars = "y_rep")
ppc_hist(y, y_rep2[1:8, ], binwidth = 1)

## ----ppc-dens-overlay-2--------------------------------------------------
ppc_dens_overlay(y, y_rep2[1:50, ])

## ---- prop-zero-2, message=FALSE-----------------------------------------
ppc_stat(y, y_rep2, stat = "prop_zero")

## ---- more-checks, message=FALSE-----------------------------------------
ppc_stat_2d(y, y_rep2, stat = c("mean", "sd"))
ppc_error_hist(y, y_rep2[sample(nrow(y_rep2), 4), ], binwidth = 1) + 
  xlim(-15, 15) +
  vline_0()

## ------------------------------------------------------------------------
library(loo)
log_lik1 <- extract_log_lik(fit)
(loo1<-loo(log_lik1))
log_lik2 <- extract_log_lik(fit2)
(loo2<-loo(log_lik2))
compare(loo1,loo2)

