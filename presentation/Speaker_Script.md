# Proposition 99 replication: recording script

I drafted a script for us to work from. I’ve suggested that you cover slides 1–4 and I cover slides 5–10, but we can adjust the split however you prefer. I’m aiming for about 9–10 minutes including transitions. The timings below are estimates, so we’ll need to check them in rehearsal. We can keep the two appendix slides available for reference without narrating them.

## Slide 1. California's tobacco control program
**Ying, 0:00–0:35**

Hi everyone. We are Ying Zhang and Feng Yi Chew. We replicated Abadie, Diamond, and Hainmueller's 2010 study of California's tobacco control program. The question is how Proposition 99 affected cigarette sales. Because we cannot observe California both with and without the program, the authors construct a synthetic California from other states. We reproduce the main analysis and examine how software implementation choices affect the placebo evidence.

## Slide 2. Policy, data, and comparison group
**Ying, 0:35–1:30**

California voters passed Proposition 99 in November 1988, and it took effect in January 1989. The policy raised the cigarette tax by 25 cents per pack and directed revenue toward tobacco control and other health programs. The analysis uses annual cigarette sales per capita from 1970 through 2000. California is the treated state. The donor pool contains 38 states, after excluding states with major tobacco control programs or substantial cigarette tax increases during the post-treatment period. There are 19 pretreatment years and 12 post-treatment years. The outcome measures sales, which are a proxy for consumption. A simple national comparison is problematic because California's sales trajectory already differed before the policy.

## Slide 3. Constructing synthetic California
**Ying, 1:30–2:45**

Synthetic control addresses this comparison problem by taking a weighted average of donor states. The weights must be nonnegative and sum to one, so synthetic California lies within the donor combinations available in the data. The method chooses donor weights to match California on pretreatment predictors, while predictor weights determine the relative importance of those matches. The estimated policy effect is the difference between actual California and synthetic California after 1988. A negative gap means lower observed sales. For a causal interpretation, the pretreatment relationship must remain a reasonable counterfactual after the intervention. Major California-specific shocks could undermine that interpretation, and spillovers could contaminate the donor pool. Close pretreatment fit supports the design, but cannot by itself establish those assumptions.

## Slide 4. Predictors and replication specification
**Ying, 2:45–3:40**

We follow the paper's predictor specification. We average log income, the population share aged 15 to 24, and retail cigarette prices over 1980 to 1988. Beer consumption uses 1984 to 1988. We also include cigarette sales in 1975, 1980, and 1988 as separate predictors. The optimization uses outcomes from the full 1970 to 1988 pretreatment period. Our implementation uses the smoking data in tidysynth version 0.2.1. During validation, we corrected the package's treatment cutoff and the names of the optimizer arguments. These details matter because software conventions can differ from what a reader might assume. Feng Yi will now present the replication results and checks.

## Slide 5. The same five states dominate the synthetic control
**Feng Yi, 3:40–4:30**

Our replication assigns almost all the donor weight to the same five states as the paper: Colorado, Connecticut, Montana, Nevada, and Utah. Utah contributes the most, at about 34 percent, followed by Nevada and Montana. The weights are similar to the published values, although they are not identical. We verified that all weights are nonnegative and sum to one. The pretreatment root mean squared prediction error is about 1.78 packs per capita. Most predictors match closely. Log income matches less well, but receives very little weight in the matching objective. That weight describes the optimization, rather than the causal importance of income.

## Slide 6. Actual sales diverge from synthetic California
**Feng Yi, 4:30–5:20**

This figure shows the main comparison. Before the intervention, synthetic California generally tracks actual California closely. The vertical line marks 1988, the last pretreatment year. Beginning in 1989, actual cigarette sales decline more sharply than the synthetic series. Both series decline over time, but their difference becomes much larger after the program starts. The treatment estimate is that difference, rather than California's total decline. Interpreting it as a policy effect depends on the credibility of the synthetic counterfactual and the assumptions we described earlier.

## Slide 7. The estimated effects are close to the paper
**Feng Yi, 5:20–6:10**

Our average estimated reduction from 1989 through 2000 is 18.85 packs per capita, compared with almost 20 packs in the paper. Relative to average synthetic sales, our reduction is about 23.8 percent. In 2000, the gap is 25.58 packs, close to the paper's estimate of about 26 packs. Pretreatment mean squared prediction error is 3.17, compared with about 3 in the paper. We therefore describe this as a close substantive replication with numerical differences. We do not claim to have recovered the exact published solution.

## Slide 8. California has the largest placebo ratio
**Feng Yi, 6:10–7:10**

We next ask how unusual California's result is. For each state, we construct a synthetic control and calculate the ratio of post-treatment to pretreatment mean squared prediction error. This scales the post-treatment divergence by the quality of the earlier fit. California has the largest ratio among all 39 states, at about 124. Its full-sample placebo rank p-value is one divided by 39, or about 0.026. This statistic measures rarity within the comparison set. It does not mean a 97 percent probability that the policy worked, and the observational setting does not establish random treatment assignment. The ratio also uses squared gaps. The signed outcome comparison establishes that California's divergence is negative.

## Slide 9. Placebo fitting choices change the sensitivity analysis
**Feng Yi, 7:10–8:30**

We found an important implementation difference. By default, tidysynth reuses California's predictor weights when fitting placebo states. Each placebo receives its own donor weights, but the matching priorities remain those selected for California. We added a separate analysis that optimizes predictor weights independently for every state. This substantially improves placebo fit. At the strictest cutoff, the default retains only six donor states, whereas independent fitting retains 18. California remains first under both procedures. However, the strictest independent comparison has only 19 states including California, so its rank p-value is one divided by 19, or about 0.053. The other independent comparisons give values below 0.05. These results show why the fitting procedure and comparison set matter. The retained counts are closer to, but still different from, the paper's results.

## Slide 10. Lessons and implications for our project
**Feng Yi, 8:30–9:35**

The replication reproduced the main direction and approximate magnitude of the published estimates. It also showed us that replication requires checking the computation behind the figures. We corrected package arguments, verified donor weights, and saved the validation outputs from a single model run. That last step prevented us from combining old annual results with updated model diagnostics. We also learned to examine placebo fit rather than rely only on a single rank p-value. For our own empirical work, the general lesson is to specify the counterfactual clearly, justify the comparison group, and report sensitivity openly. The exact application depends on our final project design. Finally, sales do not measure consumption perfectly, and spillovers or California-specific shocks remain limitations of the causal interpretation. Thank you.


## Tuesday morning: our 40-minute plan

Perhaps we can do a quick run-through before recording to check the timing and handoff? We have 40 minutes, so I thought we could use them like this:

- **0–5 minutes:** Open the slides and scripts, confirm our parts, and settle any last wording.
- **5–8 minutes:** Record a quick test, end the test meeting, and check that both voices and the slides come through. Then start the meeting for our rehearsal and final take.
- **8–18 minutes:** Do one timed run-through, including the handoff. Let’s keep going and note anything to fix afterward.
- **18–22 minutes:** Fix only the essentials, especially anything unclear or too long.
- **22–32 minutes:** Record the presentation. Let’s aim for about 9–9½ minutes.
- **32–37 minutes:** Stop recording, end the meeting, let the file convert, and check the beginning, handoff, and ending.
- **37–40 minutes:** Save the finished video and make sure we both have access to it.

Perhaps we can keep the run-through focused on timing and anything unclear. We can also settle how our final project connects to the paper. There isn’t much time for a full second take, so if we make a small slip, we can correct it briefly and keep going. File conversion can take longer than expected, so the laptop needs to stay awake until it finishes, even if that runs past our meeting.

## Recording setup: keeping it simple

I’m thinking of the following setup: we use the Zoom desktop app on one laptop, with one of us sharing and advancing the slides throughout. Since we’ll be in the same room, we can just switch who’s speaking without changing the screen share.

### Possible setup

- Open `Prop99_Presentation.html` in its own browser window, with only the presentation in that window.
- Keep our scripts on paper, a phone, or another device so we don’t have to switch between slides and notes.
- Use one laptop’s microphone, positioned so it picks up both of us.
- If we use a second laptop for notes, it can stay outside the Zoom meeting. If it joins, disconnect its meeting audio to avoid echo.
- Start Zoom as host, join computer audio, and allow microphone and screen-sharing access if the Mac asks.
- Check that **Record → Record on this Computer** is available. It may be under **More**. If it’s missing, check the account’s recording settings.
- Save the recording to a local folder outside iCloud, for example `/Users/fengyichew/Movies/Prop99_Recordings`. We can copy the finished MP4 elsewhere afterward.
- During our test, perhaps we can each say a few words and change a slide, then check the playback before starting the full take.

### Starting the final recording

1. Open the slides at slide 1 and keep the script on paper or another device.
2. In Zoom, click **Share** and select the specific browser window containing the slides, rather than the whole desktop.
3. Leave **Optimize for video sharing** off for these slides. We don’t need **Share sound** because our presentation has no embedded audio. The laptop microphone supplies our narration.
4. Check that the shared preview shows the slides. Cameras can be on if we want or if the instructor requires them. We’ll use the test recording to check any participant thumbnails and text readability.
5. Click **Record → Record on this Computer**. While sharing, Record may be under **More** in the floating toolbar.
6. Wait a moment, then start the introduction. Whoever controls the laptop can advance the slides with the right arrow key. The browser slide window needs to be active for the key to work.
7. At the handoff, we just change speakers. The same screen share keeps running.
8. After “Thank you,” wait a moment, stop recording, and end the meeting. Zoom then converts the recording to files, including an MP4.
9. Keep the laptop awake until conversion finishes. Play back the MP4 to check the audio, slides, duration, and ending before sharing it.

### Do we need to toggle screens?

No. The audience can see the slides for the entire presentation. We don’t need to open RStudio, GitHub, or the paper during the recording. The figures and comparisons are already in the deck.

The floating toolbar gives us access to Zoom controls. **Command + Tab** switches between apps on the Mac if needed, but it is not a recording control. We can check the shared preview afterward. Selecting a window rather than the whole desktop limits what is shared, but another tab opened inside that shared browser window could still appear. Keeping the notes on another device is the simplest setup.

## Rehearsal notes for us

- Let’s aim to finish around 9:30 so we have a buffer within the 10-minute limit.
- We can explain MSPE once and highlight the main patterns without reading every weight or cutoff row.
- Let’s distinguish the paper’s estimates from our replication results.
- We can keep the Git details outside the recording.

## Recording references

Zoom: [Starting a computer recording](https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0076922), [Sharing your screen](https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0060596), and [Enabling computer recording](https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0063640). Recording availability and button labels can depend on account settings and app version.
