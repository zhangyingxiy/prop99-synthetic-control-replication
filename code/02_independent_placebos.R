# Run from the repository root, for example with Source in Replication.Rproj.
# Each unit receives its own optimized predictor weights (V) and donor weights.
# California remains eligible as a donor when another state is the placebo.
# This changes predictor-weight reuse only; it does not guarantee exact recovery
# of the original paper's numerical solution.
library(dplyr)
library(tidysynth)
data("smoking", package = "tidysynth")

baseline <- readRDS("results/validation_checkpoint.rds")
stopifnot(baseline$tidysynth_version == as.character(packageVersion("tidysynth")))

fit_one_unit <- function(unit_name) {
  message("Fitting ", unit_name)
  fit <- smoking %>%
    synthetic_control(outcome = cigsale, unit = state, time = year,
                      i_unit = unit_name, i_time = 1988,
                      generate_placebos = FALSE) %>%
    generate_predictor(time_window = 1980:1988,
                       lnincome = mean(lnincome, na.rm = TRUE),
                       age15to24 = mean(age15to24, na.rm = TRUE),
                       retprice = mean(retprice, na.rm = TRUE)) %>%
    generate_predictor(time_window = 1984:1988,
                       beer = mean(beer, na.rm = TRUE)) %>%
    generate_predictor(time_window = 1975, cigsale_1975 = cigsale) %>%
    generate_predictor(time_window = 1980, cigsale_1980 = cigsale) %>%
    generate_predictor(time_window = 1988, cigsale_1988 = cigsale) %>%
    generate_weights(optimization_window = 1970:1988,
                     margin_ipop = 0.02, sigf_ipop = 7, bound_ipop = 6) %>%
    generate_control()

  annual <- fit %>% grab_synthetic_control() %>%
    mutate(unit_name = .env$unit_name, gap = real_y - synth_y)
  stats <- annual %>% summarise(
    unit_name = .env$unit_name,
    pre_mspe = mean(gap[time_unit <= 1988]^2),
    post_mspe = mean(gap[time_unit >= 1989]^2),
    mspe_ratio = post_mspe / pre_mspe)
  list(annual = annual, stats = stats,
       predictor_weights = grab_predictor_weights(fit) %>%
         mutate(unit_name = .env$unit_name))
}

units <- c("California", sort(setdiff(unique(smoking$state), "California")))
fits <- lapply(units, fit_one_unit)
annual_independent <- bind_rows(lapply(fits, `[[`, "annual"))
stats_independent <- bind_rows(lapply(fits, `[[`, "stats")) %>%
  mutate(type = if_else(unit_name == "California", "Treated", "Donor"),
         rank = min_rank(desc(mspe_ratio))) %>% arrange(rank)
predictor_weights_independent <- bind_rows(lapply(fits, `[[`, "predictor_weights"))
stopifnot(nrow(stats_independent) == 39, all(is.finite(stats_independent$mspe_ratio)))

# California's fit should agree with the baseline because its specification
# has not changed. A disagreement stops the comparison instead of mixing fits.
ca <- filter(stats_independent, unit_name == "California")
baseline_ca <- filter(baseline$placebo_stats, unit_name == "California")
stopifnot(isTRUE(all.equal(ca$pre_mspe, baseline_ca$pre_mspe, tolerance = 1e-6)),
          isTRUE(all.equal(ca$post_mspe, baseline_ca$post_mspe, tolerance = 1e-6)))

cutoffs_independent <- bind_rows(lapply(c(Inf, 20, 5, 2), function(k) {
  eligible <- filter(stats_independent, pre_mspe <= k * ca$pre_mspe)
  tibble(pre_mspe_multiplier = k,
         donor_states_retained = sum(eligible$type == "Donor"),
         total_states = nrow(eligible),
         rank_p_value = mean(eligible$mspe_ratio >= ca$mspe_ratio))
}))

comparison <- baseline$placebo_stats %>%
  select(unit_name, shared_pre_mspe = pre_mspe, shared_ratio = mspe_ratio) %>%
  left_join(stats_independent %>%
              select(unit_name, independent_pre_mspe = pre_mspe,
                     independent_ratio = mspe_ratio), by = "unit_name")

dir.create("results/independent_placebos", recursive = TRUE, showWarnings = FALSE)
outputs <- list(annual_results = annual_independent,
                placebo_stats = stats_independent,
                predictor_weights = predictor_weights_independent,
                cutoff_summary = cutoffs_independent,
                comparison = comparison)
for (nm in names(outputs)) {
  write.csv(outputs[[nm]], paste0("results/independent_placebos/", nm, ".csv"),
            row.names = FALSE)
}
saveRDS(outputs, "results/independent_placebos/checkpoint.rds")
writeLines(capture.output(sessionInfo()), "results/independent_placebos/session_info.txt")
print(ca)
print(cutoffs_independent)
