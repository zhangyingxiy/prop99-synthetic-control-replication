# Proposition 99 replication: anticipated questions and responses

I prepared these possible questions and responses for us to review before recording. We can keep them handy for rehearsal without adding them to the 10-minute narration. I’ve distinguished the checks we’ve completed from possible extensions we haven’t carried out.

## Results to keep handy

| Quantity | Corrected replication |
|---|---:|
| Pretreatment years | 19, covering 1970–1988 |
| Post-treatment years | 12, covering 1989–2000 |
| Donor states | 38 |
| Pretreatment MSPE | 3.1662 |
| Pretreatment RMSPE | 1.7794 packs per capita |
| Average annual sales gap, 1989–2000 | −18.8456 packs per capita |
| Percentage reduction relative to mean synthetic sales | 23.7963% |
| Gap in 2000 | −25.5849 packs per capita |
| California post/pre-MSPE ratio | 123.8701 |
| Full-sample rank | 1 of 39 |
| Full-sample rank p-value | 0.02564 |

## Questions most likely to come up

### 1. What exactly is the treatment effect you estimate?

**Short answer:** We estimate the difference between actual California cigarette sales and the sales predicted by synthetic California after the policy. The average gap is about −18.85 packs per capita per year over 1989–2000.

**If pressed:** This is an effect on annual per-capita sales under the synthetic-control assumptions. It is not an individual-level treatment effect or a measured change in smoking prevalence. The effect concerns the policy package, including the tax and tobacco-control activities, rather than separately identified components.

### 2. Why use synthetic control instead of comparing California before and after?

**Short answer:** Sales could have fallen even without the policy. Synthetic California estimates a counterfactual that accommodates broader changes represented in the donor states.

**If pressed:** A before-and-after decline is not the policy effect. We estimate the difference between actual and synthetic outcomes after fitting their pretreatment relationship.

### 3. Why not use the national average or difference-in-differences?

**Short answer:** California and the rest of the country already had different pretreatment trajectories. Synthetic control seeks a weighted comparison that more closely reproduces California's earlier outcomes.

**If pressed:** A conventional difference-in-differences design requires a credible parallel-trends argument for its chosen comparison group. Synthetic control does not eliminate assumptions. It replaces the simple comparison with a fitted combination whose pretreatment performance we can inspect. We have not estimated a separate difference-in-differences model in this replication.

### 4. What assumptions make the synthetic comparison causal?

**Short answer:** The donor combination must remain a credible approximation to untreated California after 1988. Large California-specific shocks, anticipation, or policy spillovers could undermine that interpretation.

**If pressed:** Fit alone cannot rule out these threats. The design also requires suitable donors and sufficient pretreatment information. It is an observational comparative case study, so we should describe the identification argument rather than claim that the estimator automatically proves causality.

### 5. How were the 38 donors chosen? Is this cherry-picking?

**Short answer:** We use the paper's established donor sample, available in the package data. The paper excludes states with major tobacco-control programs or cigarette-tax increases of at least 50 cents during 1989–2000, and excludes DC.

**If pressed:** Those exclusions aim to avoid comparisons that receive similar interventions. They are substantive design choices that affect the estimand's counterfactual. We have not reconstructed an all-states alternative or independently audited the underlying historical policy records, so we should not claim that check.

### 6. Why do predictors use different years?

**Short answer:** We reproduce the reported specification: most covariates average 1980–1988, beer averages 1984–1988, and cigarette sales enter separately for 1975, 1980, and 1988. The outcome optimization window is 1970–1988.

**If pressed:** These predictor windows differ from the outcome-fitting window. We did not select them by searching for a preferred post-treatment result. We have not systematically tested alternative predictor windows.

### 7. What is the difference between donor weights and predictor weights?

**Short answer:** Donor weights determine how much each state contributes. Predictor weights determine how strongly the fitting objective prioritizes each predictor.

**If pressed:** Neither is an individual-level causal coefficient. A small weight on income does not establish that income has no causal relationship with cigarette sales.

### 8. Does the income mismatch mean the design fails?

**Short answer:** It is a limitation to report. The model closely matches most predictors and its pretreatment outcomes, but log income receives a small predictor weight and matches less closely.

**If pressed:** We cannot conclude that the imbalance is harmless just because the optimizer gives it little weight. Its substantive relevance depends on whether the unmatched information predicts untreated outcomes beyond the matched trajectory. Our current checks do not separately identify that contribution.

### 9. Is fitting historical outcomes just overfitting?

**Short answer:** Fitting pretreatment outcomes is intentional, but good fit does not guarantee good prediction after treatment. Nonnegative weights that sum to one restrict extrapolation, while placebo checks provide an additional diagnostic.

**If pressed:** Those restrictions do not eliminate overfitting. A held-out pretreatment validation period would be a useful extension. We have not performed that extension, and the included lagged sales years would need careful handling to avoid validation leakage.

### 10. Why do your estimates differ from the paper?

**Short answer:** We reproduce the main direction, approximate size, and five dominant donor states, but not the exact published numerical solution. Correcting the package arguments and independently fitting placebos addresses identifiable implementation differences.

**If pressed:** We have not completely traced the remaining differences to the solver, data, or other details. We shouldn’t attribute them solely to rounding or claim that one change explains every discrepancy. We report both the agreements and differences.

## Placebo inference and statistical pushback

### 11. What does a post/pre-MSPE ratio of about 124 mean?

**Short answer:** California's mean squared post-treatment gap is about 124 times its pretreatment mean squared gap. It shows substantial divergence relative to the earlier fitting error.

**If pressed:** It does not mean sales fell by 124%, or that the effect is 124 packs. Squared gaps remove direction. The negative signed gaps establish the estimated reduction.

### 12. Why is the p-value 1/39 rather than zero?

**Short answer:** California has the largest statistic, and the comparison counts California among the 39 possible state assignments. One of the 39 statistics is at least as large as California's: its own.

**If pressed:** We calculate the fraction of statistics at least as large, including ties. No donor exceeding California does not yield a zero p-value.

### 13. Is this an exact randomized experiment? What about the package's Fisher label?

**Short answer:** No. California did not receive the policy through a randomized assignment. We call the statistic a placebo rank p-value and interpret it as a measure of comparative unusualness.

**If pressed:** Exact randomization-test interpretation requires a defensible assignment mechanism or exchangeability argument. The package's column name, `fishers_exact_pvalue`, does not establish those conditions. This is also not the conventional contingency-table Fisher exact test. The reported z-score does not justify treating the result as an ordinary normal-theory test.

### 14. Your strictest result is 0.0526. Does the result disappear?

**Short answer:** California remains first, but the strictest independent comparison includes only 19 total states. Its smallest possible rank p-value is 1/19, or 0.0526. We report it rather than claiming significance at 5% under every specification.

**If pressed:** The smaller comparison set limits resolution, and the fitting restriction changes which states provide the benchmark. The substantive estimated effect is unchanged. The sensitivity still matters and should not be dismissed as merely a technicality.

### 15. Why drop poorly fitted placebo states?

**Short answer:** A large post-treatment gap is less informative if a state's synthetic comparison already fits badly before treatment. We show the full set and several pretreatment-MSPE cutoffs to make that sensitivity visible.

**If pressed:** The cutoffs are multiples of MSPE, not RMSPE, and follow the paper's reported comparisons. We did not choose a single cutoff because it crossed a significance threshold. Filtering should not be presented as an automatic cure for identification problems.

### 16. Why change the package's placebo procedure?

**Short answer:** We wanted to assess an implementation choice. Version 0.2.1 reuses California's predictor weights for other states. Independent fitting allows each placebo to choose its own matching priorities, using the same windows and solver settings.

**If pressed:** We retain and report both procedures. Independent fitting improves the placebo fits and approaches the published retained counts, but does not exactly reproduce them. We should not call the package default universally wrong or select the alternative solely for favorable p-values.

### 17. Does California enter the donor pool for placebo states?

**Short answer:** Yes. When another state is the placebo, our independent analysis uses the remaining states, including California, as possible donors. That follows the reassignment logic described in the paper.

**If pressed:** California's post-policy outcomes could affect synthetic placebo paths if California gets positive donor weight. This is part of the chosen placebo construction and should be acknowledged. An alternative excluding California from placebo donor pools is a sensitivity check we have not performed.

## Substantive limitations and extensions

### 18. Could cross-border purchases explain the result?

**Short answer:** They could account for part of a fall in tax-paid sales without an equivalent fall in smoking. Our outcome measures sales, so we cannot interpret every missing pack as reduced consumption.

**If pressed:** The paper discusses cross-border purchases and smuggling, but our replication does not separately estimate their contribution. We haven’t ruled out these mechanisms, so I suggest acknowledging that limitation if asked.

### 19. Could anti-smoking attitudes or other California policies explain the gap?

**Short answer:** Yes, an unaccounted California-specific post-treatment change could threaten the causal interpretation. Pretreatment matching addresses earlier differences, but cannot rule out all later confounding.

**If pressed:** The estimand concerns the program package. Separating the tax, media campaign, and other contemporaneous changes would require additional variation or a different design. Spillovers to donors could also alter the estimated effect, with direction depending on the mechanism.

### 20. Does a 23.8% sales reduction imply 23.8% fewer smokers?

**Short answer:** No. The estimate concerns packs sold per capita. It could reflect changes in initiation, cessation, consumption intensity, or where people buy cigarettes.

**If pressed:** Our percentage divides the average gap by average synthetic sales over 1989–2000. It is not the mean of annual percentage reductions and not a direct prevalence estimate.

### 21. Are the donor weights stable? Did you try leave-one-out analysis?

**Short answer:** We checked that the corrected model uses the same dominant five donors as the paper. We have not yet performed a formal leave-one-out sensitivity analysis.

**If pressed:** Omitting heavily weighted donors and re-estimating is a useful next step. We should not describe that robustness check as completed or imply that similar donor names establish stability.

### 22. What other checks would strengthen the study?

**Short answer:** Leave-one-out fits, held-out pretreatment validation, and an audit against the authors' original data and code would help assess the remaining numerical discrepancies and robustness.

**If pressed:** We could also test alternative predictor sets, earlier placebo treatment dates, and donor-pool definitions. Each should have a clear purpose, with all relevant results reported rather than searching for a preferred answer. These are proposed extensions, not completed checks.

### 23. What does this contribute to your proposed final project?

**Short answer:** The transferable lesson is to define the counterfactual explicitly, justify the comparison group, and assess sensitivity to implementation and design choices.

**If pressed:** Let’s agree on the specific connection to our final project before we record. We should describe only the methods and data we actually plan to use. The assignment asks for that connection, so our general methodological lesson may need a more concrete example.

## Suggested response when you do not know

“We have not tested that in this replication, so we cannot claim it is robust to that choice. Our completed checks cover donor weights, predictor balance, pretreatment fit, estimated effects, and the comparison between shared and independently optimized placebo predictor weights. That would be a useful extension.”

## Sources and scope

Published design and benchmarks: Abadie, Diamond, and Hainmueller (2010), *JASA* 105(490), 493–505, especially Sections 2–3, Tables 1–2, and the placebo figures. DOI: https://doi.org/10.1198/jasa.2009.ap08746.

Replication estimates: `results/tables/` and `results/independent_placebos/`. Package behavior: inspected installed `tidysynth` 0.2.1 `generate_weights()` source. Interpretations and proposed checks are methodological assessments, not additional empirical findings.
