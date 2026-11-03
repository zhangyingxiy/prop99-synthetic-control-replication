# Replication of:
# Abadie, Diamond, and Hainmueller (2010)
#
# "Synthetic Control Methods for Comparative Case Studies:
#  Estimating the Effect of California's Tobacco Control Program"
#
# This script:
#   1. Loads the Proposition 99 data
#   2. Constructs synthetic California
#   3. Reports donor-state weights
#   4. Examines predictor balance
#   5. Estimates the treatment-effect trajectory
#   6. Conducts placebo tests

library(tidyverse)
library(tidysynth)

data("smoking")

# 1. Construct synthetic California

sc <- smoking %>%
  synthetic_control(
    outcome = cigsale,
    unit = state,
    time = year,
    i_unit = "California",
    i_time = 1989,
    generate_placebos = TRUE
  ) %>%

  generate_predictor(
    time_window = 1980:1988,
    lnincome = mean(lnincome, na.rm = TRUE),
    age15to24 = mean(age15to24, na.rm = TRUE),
    retprice = mean(retprice, na.rm = TRUE)
  ) %>%

  generate_predictor(
    time_window = 1984:1988,
    beer = mean(beer, na.rm = TRUE)
  ) %>%

  generate_predictor(
    time_window = 1975,
    cigsale_1975 = cigsale
  ) %>%

  generate_predictor(
    time_window = 1980,
    cigsale_1980 = cigsale
  ) %>%

  generate_predictor(
    time_window = 1988,
    cigsale_1988 = cigsale
  ) %>%

  generate_weights(
    optimization_window = 1970:1988,
    Margin.ipop = 0.02,
    Sigf.ipop = 7,
    Bound.ipop = 6
  ) %>%

  generate_control()


# 2. Synthetic-control weights
# Paper: CO .164, CT .069, MT .199, NV .234, UT .334

weights <- sc %>%
  grab_unit_weights() %>%
  arrange(desc(weight))

print(weights)


# 3. Predictor balance

balance <- sc %>%
  grab_balance_table()

print(balance)


# 4. Figure 2: California vs synthetic California

sc %>%
  plot_trends() +
  geom_vline(xintercept = 1988, linetype = "dashed") +
  labs(
    title = "California vs. Synthetic California",
    x = "Year",
    y = "Per-capita cigarette sales"
  ) +
  theme_minimal()


# 5. Figure 3: California - synthetic California

sc %>%
  plot_differences() +
  geom_vline(xintercept = 1988, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dotted") +
  labs(
    title = "Estimated Effect of Proposition 99",
    x = "Year",
    y = "California - Synthetic California"
  ) +
  theme_minimal()


# 6. Placebo tests

sc %>%
  plot_placebos() +
  geom_vline(xintercept = 1988, linetype = "dashed") +
  labs(
    title = "In-Space Placebo Tests",
    x = "Year",
    y = "Gap in cigarette sales"
  ) +
  theme_minimal()

