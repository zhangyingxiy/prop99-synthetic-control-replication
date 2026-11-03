
# 0. Packages and data

library(tidyverse)
library(tidysynth)

# Load California smoking data
data("smoking")

# Create folder for figures if it does not already exist
dir.create(
  "results/figures",
  recursive = TRUE,
  showWarnings = FALSE
)

# FIGURE 1
# California vs. the rest of the United States

# NOTE:
# The original paper compares California with the rest of the
# United States. Because the tidysynth smoking dataset does not
# contain population weights, the comparison below uses the
# simple mean of the available non-California states.

fig1_data <- smoking %>%
  group_by(year) %>%
  summarise(
    California = cigsale[state == "California"],
    `Other states` = mean(
      cigsale[state != "California"],
      na.rm = TRUE
    ),
    .groups = "drop"
  ) %>%
  pivot_longer(
    cols = c(California, `Other states`),
    names_to = "series",
    values_to = "cigsale"
  )


fig1 <- ggplot(
  fig1_data,
  aes(
    x = year,
    y = cigsale,
    linetype = series
  )
) +
  geom_line(linewidth = 0.8) +
  geom_vline(
    xintercept = 1988,
    linetype = "dotted"
  ) +
  annotate(
    "text",
    x = 1987,
    y = 45,
    label = "Passage of Proposition 99",
    hjust = 1,
    size = 3
  ) +
  labs(
    x = "Year",
    y = "Per-capita cigarette sales (packs)",
    linetype = NULL
  ) +
  theme_classic() +
  theme(
    legend.position = "top"
  )


# Display Figure 1
fig1


# Save Figure 1
ggsave(
  filename = "results/figures/figure1_california_vs_rest_us.png",
  plot = fig1,
  width = 7,
  height = 5,
  dpi = 300
)

# 1. Construct Synthetic California

# California is treated beginning in 1989.
#
# Predictors follow the specification in Abadie,
# Diamond, and Hainmueller (2010):
#
#   - log income: average, 1980-1988
#   - population aged 15-24: average, 1980-1988
#   - retail cigarette price: average, 1980-1988
#   - beer consumption: average, 1984-1988
#   - cigarette sales in 1975
#   - cigarette sales in 1980
#   - cigarette sales in 1988
#
# Synthetic-control weights are optimized over the
# 1970-1988 pretreatment period.

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


# FIGURE 2
# California vs. Synthetic California

fig2 <- sc %>%
  plot_trends() +
  geom_vline(
    xintercept = 1988,
    linetype = "dotted"
  ) +
  labs(
    title = NULL,
    x = "Year",
    y = "Per-capita cigarette sales (packs)"
  ) +
  theme_classic() +
  theme(
    legend.position = "top"
  )


# Display Figure 2
fig2


# Save Figure 2
ggsave(
  filename = "results/figures/figure2_california_vs_synthetic.png",
  plot = fig2,
  width = 7,
  height = 5,
  dpi = 300
)


# FIGURE 3
# Gap between California and Synthetic California

# The estimated treatment effect in each year is:
#
# Actual California - Synthetic California
#
# Negative values indicate cigarette sales were lower in
# California than predicted by its synthetic control.

fig3 <- sc %>%
  plot_differences() +
  geom_vline(
    xintercept = 1988,
    linetype = "dotted"
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    title = NULL,
    x = "Year",
    y = "Gap in per-capita cigarette sales (packs)"
  ) +
  theme_classic()


# Display Figure 3
fig3


# Save Figure 3
ggsave(
  filename = "results/figures/figure3_california_gap.png",
  plot = fig3,
  width = 7,
  height = 5,
  dpi = 300
)


# FIGURE 4
# California and placebo gaps for all control states

# The synthetic-control procedure is applied to each state
# in the donor pool as if that state had received the
# intervention in 1989.
#
# This allows the California treatment effect to be compared
# with placebo treatment effects for untreated states.

fig4 <- sc %>%
  plot_placebos(
    prune = FALSE
  ) +
  geom_vline(
    xintercept = 1988,
    linetype = "dotted"
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  labs(
    title = NULL,
    x = "Year",
    y = "Gap in per-capita cigarette sales (packs)"
  ) +
  theme_classic()


# Display Figure 4
fig4


# Save Figure 4
ggsave(
  filename = "results/figures/figure4_all_placebos.png",
  plot = fig4,
  width = 7,
  height = 5,
  dpi = 300
)
