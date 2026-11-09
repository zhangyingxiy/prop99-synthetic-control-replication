
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
    i_time = 1988,
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
    margin_ipop = 0.02,
    sigf_ipop = 7,
    bound_ipop = 6
  ) %>%
  
  generate_control()


# FIGURE 2
# California vs. Synthetic California

fig2 <- sc %>%
  plot_trends() +
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

# 2. Validate the synthetic control

# 2. Validate the synthetic control
# Always extract results from the current fitted model.

unit_weights <- sc %>%
  grab_unit_weights()

predictor_weights <- sc %>%
  grab_predictor_weights()

balance_table <- sc %>%
  grab_balance_table()

sc_results <- sc %>%
  grab_synthetic_control() %>%
  mutate(gap = real_y - synth_y)

# Check donor weights and sample periods.
stopifnot(
  abs(sum(unit_weights$weight) - 1) < 1e-6,
  all(unit_weights$weight >= -1e-8),
  nrow(sc_results) == 31,
  setequal(sc_results$time_unit, 1970:2000),
  !anyDuplicated(sc_results$time_unit),
  all(is.finite(sc_results$gap))
)

# Pretreatment fit: 1970–1988.
pre_fit <- sc_results %>%
  filter(time_unit <= 1988) %>%
  summarise(
    years = n(),
    MSPE = mean(gap^2),
    RMSPE = sqrt(mean(gap^2))
  )

# Average estimated effect: 1989–2000.
# Percentage reduction uses average synthetic sales as the denominator.
post_effect <- sc_results %>%
  filter(time_unit >= 1989) %>%
  summarise(
    years = n(),
    average_gap_packs = mean(gap),
    reduction_percent = 100 * (1 - mean(real_y) / mean(synth_y))
  )

effect_2000 <- sc_results %>%
  filter(time_unit == 2000)

# 3. Placebo inference
# tidysynth 0.2.1 reuses California's predictor weights for placebos.
# These results describe that implementation.

placebo_stats <- sc %>%
  grab_significance()

ca_pre <- placebo_stats %>%
  filter(unit_name == "California") %>%
  pull(pre_mspe)

ca_ratio <- placebo_stats %>%
  filter(unit_name == "California") %>%
  pull(mspe_ratio)

# Verify agreement between our calculation and package diagnostics.
stopifnot(
  isTRUE(all.equal(pre_fit$MSPE, ca_pre, tolerance = 1e-6))
)

# Cutoffs refer to MSPE, not RMSPE.
# Rank p-values include California in the comparison set.
cutoff_summary <- bind_rows(
  lapply(c(20, 5, 2), function(multiplier) {
    
    eligible <- placebo_stats %>%
      filter(pre_mspe <= multiplier * ca_pre)
    
    tibble(
      pre_mspe_multiplier = multiplier,
      donor_states_retained = sum(eligible$type == "Donor"),
      total_states = nrow(eligible),
      rank_p_value = mean(eligible$mspe_ratio >= ca_ratio)
    )
  })
)

# 4. Display the main checks

print(unit_weights %>% filter(weight > 0.01))
print(as.data.frame(balance_table), digits = 6, row.names = FALSE)
print(pre_fit)
print(post_effect)
print(effect_2000)

print(
  placebo_stats %>% filter(unit_name == "California"),
  width = Inf
)

print(cutoff_summary)

# 5. Save results from this same model run

dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)

tables_to_save <- list(
  unit_weights = unit_weights,
  predictor_weights = predictor_weights,
  balance_table = balance_table,
  annual_results = sc_results,
  pre_fit = pre_fit,
  post_effect = post_effect,
  effect_2000 = effect_2000,
  placebo_stats = placebo_stats,
  cutoff_summary = cutoff_summary
)

for (table_name in names(tables_to_save)) {
  write.csv(
    tables_to_save[[table_name]],
    file = paste0("results/tables/", table_name, ".csv"),
    row.names = FALSE
  )
}

saveRDS(
  c(
    list(model = sc),
    tables_to_save,
    list(
      tidysynth_version = as.character(packageVersion("tidysynth")),
      session_info = sessionInfo()
    )
  ),
  file = "results/validation_checkpoint.rds"
)

writeLines(
  capture.output(sessionInfo()),
  con = "results/session_info.txt"
)