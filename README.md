
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Tidy time series & forecasting in R

This two full-day workshop provides the basics of time series analysis
and forecasting in R. This workshop will run online and in-person
on-site at the Department of Education in the second half of 2024.

## Learning objectives

Attendees will learn:

1.  How to wrangle tidy time series data in R.
2.  Visualisation techniques to identify common time series patterns.
3.  Explore, manipulate and forecast multiple related time series.
4.  Univariate and multivariate time series models for forecasting and
    econometric analysis.
5.  Evaluate different forecasting models and assess which model
    provides the best fit.

# Preparation

The workshop will provide a quick-start overview of exploring time
series data and producing forecasts. There is no need for prior
experience in time series to get the most out of this workshop.

It is expected that you are comfortable with writing R cod and using
tidyverse packages including dplyr and ggplot2. If you are unfamiliar
with writing R code or using the tidyverse, consider working through the
learnr materials here: <https://learnr.numbat.space/>.

Some familiarity with statistical concepts such as the mean, variance,
quantiles, normal distribution, and regression would be helpful to
better understand the forecasts, although this is not strictly
necessary.

## Required equipment

Please bring your own laptop capable of running R.

## Required software

To be able to complete the exercises of this workshop, please install a
suitable IDE (such as RStudio), a recent version of R (4.1+) and the
following packages.

- **Time series packages and extensions**
  - fpp3, sugrrants
- **tidyverse packages and friends**
  - tidyverse, fpp3

The following code will install the main packages needed for the
workshop.

``` r
install.packages(c("tidyverse","fpp3", "readabs", "GGally", "sugrrants"))
```

Please have the required software installed and pre-work completed
before attending the workshop.
