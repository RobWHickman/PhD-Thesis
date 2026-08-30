# Changes made post corrections by category

## Category J - EUT overstatement (p.30)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | "remains a cornerstone... driving theory" → "was seminal... shaped many of the experimental paradigms" | p.30 | Chapter1:104 | Fixed |
| 2 | Restructured violations sentence: citations taken out of parenthetical, Appendix A moved next to Machina citation, "even though" structure replaced for better flow | p.30 | Chapter1:104 | Fixed |
| 3 | Added new closing sentence acknowledging CPT as the dominant modern framework in behavioural economics and JDM research, citing Tversky & Kahneman (1992) | p.30 | Chapter1:104 | Fixed |

## Category K - Rescorla-Wagner mischaracterisation

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Intro sentence framed R-W as cause-effect/predictive → rewritten to describe it as an associative model updating CS-US strength trial-by-trial, explicitly not causal or predictive of future states | p.32 | Chapter1:119 | Fixed |
| 2 | Bridge sentence into equation still used "a cause (the CS) and effect (the US)" → "associative strength between a CS and US" | p.32 | Chapter1:119 | Fixed |
| 3 | Variable description "strength of association between a cause and effect $x$" → "strength of association between a CS-US pairing $x$" | p.32 | Chapter1:130 | Fixed |

## Category N - Fig 4.5 neuron inclusion clarification

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Unclear why fewer neurons appear in raster (B) vs. population average (A) of Fig 4.5 — examiner asked whether missing neurons were non-dopaminergic, non-responding, or excluded by a testing threshold | Ludvig report | Chapter4:121 | Added sentences to body text clarifying that the raster is restricted to cells with n > 5 free reward trials AND Wilcoxon p < 0.2 (lenient inclusion criterion); explains that remaining cells are absent because testing was limited to avoid satiation, leaving the test underpowered; notes ~80% of sufficiently-tested cells respond significantly |

## Category O - Fig 3.4 end-of-session criterion (p.75)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Fig 3.4 caption did not state what determined the end of a session → three sentences added (sessions ended when monkeys stopped; ≥200-trial days continued until 5 consecutive errors; shorter days continued 15 min after last response to prevent learned stopping). Text was initially added to the Fig 3.4 caption but moved to the main body text to avoid an oversized legend. **Verified 2026-08-05** (both by direct file check and by Robert independently, via PDF pages 75/76): caption is clean, no leftover text; the three sentences live only in the body. No duplication. Also tightened the opening sentence's flow ("stopped performing the task, defined as follows:..." replacing three choppy sentences). Closed. | p.75 | Chapter3:147 | Fixed |

## Category P - Starting bid / total liquid opposite effects (single-fractal sessions)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | No discussion of opposite starting bid signs (U: −0.649, V: +0.162) or divergence in dominant variable (total liquid vs. starting bid) across monkeys in single-fractal session regression | Ludvig report | Chapter3:471 (after session-level para) | Added two paragraphs: first interprets the dissociation with reference to Chapter 1 marginal utility; second reiterates reward level dominance in full regression and notes that individual animals in primate neurophysiology cannot be treated as interchangeable n=2 |

## Category Q - Table 3.10 Figure 1.1 reference (p.112)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | "Bundle WTP is the indifference point inferred in Figure 1.1 on the choice task" → clarified as a conceptual callback, not a data source; split into two sentences referencing Figures 1.1 and 2.2 as illustrations using separate data | p.112 | Chapter3:621 | Fixed |

## Category R - Tie-fighter plot clarity (p.111)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Unclear what tie-fighter markers represent | Ludvig report p.111 | Chapter3:630 | Added two sentences to caption explicitly naming the marker as point ± error bars and explaining what the central dot and error bars represent, contrasting with the adjacent BDM boxplots |
| 2 | Caption hard to parse which series is BDM and which is choice | Ludvig report p.111 | Chapter3:630 | Rewrote opening of panel A caption to make explicit: boxplots = BDM, point+error bars = bundle choice indifference point, shown side by side per reward level |
| 3 | Missing blue tie fighter / axis range too narrow for Monkey V high value | Ludvig report p.111 | Chapter3:632 | Added new figure (fig:wtp_comparison_extended, correction_bdm_bcb_compare_fig.svg) with extended y-axis; updated existing caption to explain that Monkey V's high-value indifference point falls outside the tested range (monkey did not choose bundle on majority of trials at any water level); added in-text reference at line 545 |
| 4 | Caption too long after expansions | — | Chapter3:606, 630 | Moved interpretive sentences (50% logistic crossing explanation; indifference point as independent WTP measure) from caption into body text at line 606; caption trimmed to describe only what is shown. **⚠ Requires careful review before submission — substantial restructuring of both caption and surrounding body text.** |

## Category S - Fig 3.10 axis label legibility

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Y-axis tick labels (0.0, 0.2, 0.4, 0.6, 0.8, 1.0) repeated on all 10 rows × 2 monkey panels → unreadable wall of numbers | Ludvig report | Chapter3/redone_figs/joystick_facets.png (replaced with joystick_facets2.png) | Reduced y-axis breaks to 0, 0.5, 1; blanked all y-axis label grobs except top-left panel (start_bin 10) via gtable manipulation; equalised panel widths using `element_text(color = "transparent")` on Monkey U strip |
| 2 | No label indicating what the right-hand strip numbers represent | Ludvig report | Chapter3:298 (caption) | Added `sec_axis` to Monkey V with title "starting bid decile"; caption updated to note y-axis shown on top-left panel only for clarity |
| 3 | "bars movement" → "bar's movement" (possessive) | — | Chapter3:298 | Fixed |

## Category T - Fig 3.12 y-axis labels

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Top row y-axis labels missing or on wrong side in `fig:monkey_regression_dists` | Ludvig report | Chapter3/redone_figs/variable_distribution_plot_redone.png | Rebuilt figure using `GGally::ggmatrix_gtable()` + gtable manipulation: row labels flipped from right to left via `flip_y_strips_to_left()`; column labels moved from top to bottom via `flip_x_strips_to_bottom()`; axis tick numbers removed (correlation structure only); Monkey V right-side strip labels blanked (Monkey U left labels suffice); text sizes increased throughout |
| 2 | Caption referenced `B)` for bid distribution (now `C)` after A/B split by monkey) | — | Chapter3:320 | Fixed `B)` → `C)` in caption; added axis-omission explanation; added units (ml) for juice and total liquid; sentences tightened |

## Category U - Fig 4.4 caption and missing y-axis scales

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Caption had left/right described backwards for Monkey U/V | Mak/Ludvig report | Chapter4:117 | "on the right...on the left" → "on the left...on the right" |
| 2 | "Y-axis scales differ between figures" stated but no scales shown | Mak/Ludvig report | Chapter4:117 | Replaced with normalisation description: spike counts normalised to per-monkey panel maximum, common 0--1 scale; figure regenerated with `geom_col` + `norm_hist()` pre-computation |
| 3 | B) description confused responders with non-responders | — | Chapter4:117 | Rewrote: A) = significant responders (113/268); B) = non-responding DA cells; C) = non-DA cells |

## Category V - Fig 1.2 real vs simulated data demarcation

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Fig `fig:da_raster` mixes real data (A) with simulated data (B, C) without visual distinction | Ludvig report | Chapter1/Redone_Figs/RPE_CS.svg | Rebuilt figure from `/Volumes/Thesis_Work/corrections/chapter1_schultz1997_plots_remade.Rmd`: added "Real data" / "Simulated data" italic labels (top-right of each PSTH panel); added A/B/C patchwork tags; fixed CS/R/R- label colours (blue = CS, red = R/R-); fixed raster to `geom_point`; fixed x-axis label to "time (ms)"; SVG saved directly to thesis |
| 2 | Caption already stated B/C were simulated — no caption change needed; A/B/C tag references already correct | — | Chapter1:158 | No change |

## Category W - Spelling Errors and Typos

| # | Typo / Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Eq ref: "Eq 1.3" → "Eq 1.2" | p.28 | Chapter1 | Fixed (pre-session) |
| 2 | Robinson & Berridge missing brackets | p.33 | Chapter1 | Fixed (pre-session) |
| 3 | Singh ref missing brackets | p.68 | Chapter1 | Fixed (pre-session) |
| 4 | `$G_1-\hat{G}n` → `$G_1-\hat{G}_n` (missing subscript) | p.46 | Chapter2:121 | Fixed |
| 5 | `$\hat{G}_<I_1` → `$\hat{G}_n<I_1` (n in wrong position) | p.46 | Chapter2:127 | Fixed |
| 6 | Singh citation missing closing `)` | p.68 | Chapter3:91 | Fixed |
| 7 | `exuded` → `excluded` | p.73 | Chapter3:138 | Fixed |
| 8 | `monkeys bids` → `monkeys' bids`; stray `)` after "colour by reward level" | p.62 | Chapter3:317 | Fixed |
| 9 | Missing "Table " before `\ref{tab:monkey_significance}` | p.76 | Chapter3:163 | Fixed |
| 10 | `finial` → `final` (×2: caption and body) | p.80 | Chapter3:259, 265 | Fixed |
| 11 | `spit` → `split` | p.87 | Chapter3:300 | Fixed |
| 12 | Footnote 5 overprecise: `-0.95992±0.03262` → `-0.960±0.033`; `-0.49961±0.03053` → `-0.500±0.031` | p.92 | Chapter3:371 | Fixed |
| 13 | `monkeys show and effect of` → `monkeys show an effect of` | p.93 | Chapter3:402 | Fixed |
| 14 | `the estimates other parameters` → `the estimates of other parameters` | p.99 | Chapter3:471 | Fixed |
| 15 | `\cite{mirenowicz...}` → `\citet{mirenowicz...}` (missing brackets around year) | p.100 | Chapter4:106 | Fixed |
| 16 | `'wilcox.text'` → `'wilcox.test'` | p.123 | Chapter4:86 | Fixed |
| 17 | `one-sidedunless` → `one-sided unless` (missing space) | p.123 | Chapter4:86 | Fixed |
| 18 | Stray `.` after `\end{figure}` | p.145 | Chapter4:315 | Fixed |
| 19 | Missing "Table " before `\ref{tab:fd_regression_split_fractal}`; also added "Equation " before equation ref | p.145 | Chapter4:317, 323 | Fixed |
| 20 | `The total biding space` → `The total bidding space` | p.157 | Chapter4:423 | Fixed |
| 21 | `the starting big they wish` → `the starting bid they wish` | p.157 | Chapter5:100 | Fixed |
| 22 | `they did not big higher` → `they did not bid higher` | p.163 | Chapter4:491 | Fixed |
| 23 | `no tercile split shows` → `none of the tercile splits showed` | p.164 | Chapter4:499 | Fixed |
| 24 | `negligible; ;` → `negligible;` (double semicolon) | p.181 | Chapter5:100 | Fixed |
| 25 | `In such a 'binary choice'...tasks` → remove "a" | p.208/210 | AppendixA:110 | Fixed |
| 26 | `incorporates and error term` → `incorporates an error term` (×2 in caption) | p.208/210 | AppendixA:137 | Fixed |
| 27 | Dashed lines used twice in Fig 3.4 caption with different meanings → `Dashed vertical lines` / `Dashed horizontal lines` | p.75 | Chapter3:145 | Fixed |
| 28 | (same as item 12 — footnote overprecision) | p.92 | Chapter3:371 | Fixed |
| 29 | `trail` → `trial` (×4) in Table 3.9 | p.108 | Chapter3:583, 584, 590, 591 | Fixed |

## Category X - Cohen's Effect Sizes

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | `'small' difference (0.4666)` → `'medium' difference (0.467)` for Monkey V; footnote expanded to note Cohen's medium threshold is 0.5 and 0.467 is treated as rounding to medium | p.95 | Chapter3:423 | Fixed |

## Category Y - Bullet points to prose (p.59, p.70)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Three long bullet points → prose paragraphs; added "First,", "Second,", "Finally," as linking phrases | p.59 | Chapter2:258–262 | Fixed |
| 2 | Five long bullet points → prose paragraphs; temporal connectors already present ("Prior to", "Once", "After this") used as links, list tags removed | p.70 | Chapter3:97–106 | Fixed |

## Category AA - Budget/Bmax notation consistency (Appendix E)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | `Budget` defined at start then switched to `B_{max}` without clear signposting → added definition sentence after line 21 declaring `B_{max}` as the total budget for the appendix | Appendix E | AppendixE:21 | Fixed |
| 2 | `Budget` in E.1 and E.2 replaced with `B_{max}` throughout | Appendix E | AppendixE:16, 27 | Fixed |
| 3 | Removed redundant bridging text and E.3 (which only existed to introduce `B_{max}` as a substitution) | Appendix E | AppendixE:32–39 | Fixed |

## Category AB - Equation repetition (Appendix E)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | E.7 repeated LHS (`υi(P̄)max`) on all three lines → kept LHS on first line only, removed repeated LHS from subsequent lines, and removed redundant middle line | Appendix E | AppendixE:70-72 | Fixed |
| 2 | E.4/E.5/E.6 were three separate equation blocks with repeated LHS and an intermediate "multiply out brackets" step → merged into one aligned block, LHS shown once, intermediate line and surrounding text removed | Appendix E | AppendixE:43-64 | Fixed |

**Resolved 2026-08-06**: equation numbering in Appendix E has shifted multiple times since (this merge, plus Category AC's new derivations and notation cleanup). Rather than tracking an exact old→new equation-number mapping — which would just go stale with further edits — decided to handle this with a single blanket disclaimer in the final corrections letter instead: *"Note: as a result of corrections made to Appendix E (see Categories AA, AB, and AC), several equations have been merged, restructured, or renumbered relative to the originally examined version. All equation numbers in this letter refer to the numbering in the resubmitted thesis, not the original submission."* Folded into the `corrections_progress.md`/final-letter housekeeping task — no longer its own separate "check the PDF" item.

## Category AD - Softmax/logit equivalence mention (App A, p.209)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Logit/multinomial logit model not noted as equivalent to softmax → added footnote noting its wide use in the RL literature as the softmax function | p.209 | AppendixA:123 | Fixed |

## Category L - Table 4.3 data error

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Intercept and slope values identical across all three reward-level rows for each monkey — clearly copy-pasted from a pooled regression rather than per-level values | Mak/Ludvig report | Chapter4:331–337 | Re-ran per-level regressions (`lm(mean_n_s ~ bid_perc)` grouped by monkey × fractal_reward_value); replaced all six intercept ± SE and slope ± SE values with correct per-level estimates; Adj R² and p-values were already correct and unchanged |

## Category M - Fig 4.27/4.28 text-figure mismatch

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Fig 4.27A: text said `Monkey V p = 1.70` for low win condition | Ludvig report | Chapter4:486 | `1.70` → `0.170` (typo) |
| 2 | Fig 4.27A: examiner noted all three conditions appear to go up; text only stated medium and high were significant | Ludvig report | Chapter4:486 | Added sentence noting low condition has positive but non-significant mean difference (Monkey U +0.285, Monkey V +0.213 spikes/s), explaining the visual upward trend |
| 3 | Fig 4.27 caption: "Monkey U all comparisons p < 0.0005" — second "Monkey U" should be "Monkey V" | — | Chapter4:491 | `Monkey U all comparisons` → `Monkey V all comparisons` |
| 4 | Fig 4.27B: Monkey V low loss condition stated as p < 0.0001; actual p = 0.000602 | Ludvig report | Chapter4:495 | `p < 0.0001` → `p < 0.001` |
| 5 | Fig 4.28: Monkey U medium bid tercile visually exceeds high in analysis window; not explicitly acknowledged in text | Ludvig report | Chapter4:499 | Added sentence noting visual inversion for Monkey U is consistent with non-significant Dunn comparison (p = 0.279) |

## Category Z - Prospect theory / loss aversion in intro (p.50)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | p.50 intro mentioned CPT in one sentence but gave no account of what PT involves — no discussion of probability weighting or loss aversion | Ludvig report p.50 | Chapter1:104 | Added paragraph break after "paradigms employed in the literature"; replaced single CPT sentence with a paragraph introducing the two key aspects of CPT (subjective probability weighting; loss aversion and reference-point dependence of the value function); points to Appendix A (Section \ref{sec:prospect}) for full treatment including the Allais paradox |

## Category AC - Formal payoff/cost functions (Appendix E)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Payoff and cost of misbehaviour functions not formally presented for all three computer bid distributions; uniform case incomplete (cost function missing) | Mak report | AppendixE:68 | Added cost of misbehaviour derivations for uniform (quadratic closed form), normal (Mills ratio, no closed form), and matched-normal (bounded exponential closed form); added subsection headings for each distribution |
| 2 | **Maths verified 2026-08-06** (Robert, manual check) — 'trivially' removed (AppendixE:68, unjustified claim); notation cleaned up: $v$ replaced with $\upsilon_i(G)$ throughout (pure alias, no structural role), $b$ kept distinct from $B_{subject}$ with a clearer justification (free variable for the derivation vs. the subject's actual realised bid) rather than collapsed into it | — | AppendixE:68–133 | Fixed |
| 3 | Uniform section: no stated reason for the cost formula's structure | — | AppendixE:72 | Added sentence: cost = max payoff (truthful bid) − payoff at arbitrary bid $b$ |
| 4 | Normal section: three gaps — no reason win-probability is no longer a simple fraction; no reason the conditional expected bid is a truncated-normal mean; "general payoff expression" didn't reference an equation | — | AppendixE:87, 101 | Added lead sentence before `eq:pwin_normal`; added reasoning after `eq:ecb_normal` (winning truncates the distribution at $b$); "general payoff expression" → `Equation \ref{eq:bdm_payoff1}` |
| 5 | Matched-normal section: no explanation of why this case has a closed form when the general normal case doesn't; mode-maximisation claim unexplained | — | AppendixE:117, 126 | Added opening sentence (centring on the subject's value cancels the CDF terms); added brief clause on why the Gaussian PDF peaks at its mode (exponential term maximised when its argument is zero) |

## Category A - Mixed-effects model for the central bid–dopamine claim

Examiner scope: Mak explicitly requires "a mixed-effects model for the most central claim in the thesis — that dopamine response correlates with bid." Ludvig says a ME approach "might have been worth considering in many instances." Minimum viable response is the overall regression only; fractal-level and other regressions are additions beyond the strict requirement.

Model chosen: `lmer(norm_n ~ bid_perc + (1|cell_id), REML=FALSE)` — random intercept per cell, fixed slope for bid; `bid_perc = monkey_bid/100` (continuous, not binned). Random slopes model (`(1 + bid_perc|cell_id)`) tested for all conditions; random intercept preferred (better AIC in majority of conditions; modest cell counts of 32/41 per monkey).

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Central claim (overall bid ~ activity): add prose explaining ME model rationale and what random intercept controls for; present slope, t, p per monkey | Mak report point 2 | Chapter4.tex, near Fig 4.11 / Table `tab:fd_regression_results` | **Done 2026-08-06.** Two paragraphs: (1) pseudoreplication rationale for why the naive regressions pool non-independent trials; (2) results paragraph with $\beta$, $t$, $p$ per monkey. |
| 2 | Central claim: add new regression formula (`lmer`) alongside or replacing OLS formula | Mak report point 2 | Chapter4.tex, `eq:lme_general` (near Table `tab:fd_regression_results`) | **Done 2026-08-06.** One canonical numbered equation ($\frac{\text{Firing Rate}}{\text{Baseline Activity}} = \beta_0 + \beta_1(\text{Monkey Bid}) + u_{\text{cell}} + \varepsilon$, $u_{\text{cell}} \sim \mathcal{N}(0,\sigma^2_{\text{cell}})$; word-labels matching existing thesis convention rather than abstract $Y_{ij}/X_{ij}$ notation). Category E's two inline LME formulas (context-comparison and single-fraction bid regression, both prose and their two table captions — 4 locations total) converted to reference it instead of restating the formula. lme4/lmerTest citation moved to its first real use here (previously only cited at the now-stripped Category E location). Compiles clean. |
| 3 | Central claim: add new rows to overall regression table (original OLS rows retained; ME model rows added below) | Mak report point 2 | Chapter4.tex, `tab:fd_regression_results` | **Done 2026-08-06.** Two Mixed-Effects rows added within each monkey's existing block (rows 3 and 6, keeping U/V grouping intact) — Adj $R^2$ left as "—" (not applicable to this model type, noted in caption). |
| 4 | Central claim: add spaghetti plot (per-cell predicted lines from fixed effect + random intercept; population fixed-effect line overlaid; no binning) | Not actually in Mak's text — checked verbatim (point 2), he only asks for "a mixed-effects model," no figure specified; this item was an earlier session's own elaboration, mislabelled as sourced from the examiner. Done anyway since the code was cheap to adapt from the per-fractal version. | Chapter4.tex, new figure `fig:fractal_display_lme_regression` (after Table `tab:fd_regression_results`) | **Done 2026-08-07.** Built in `fd_response_corrections.Rmd` from the same `fd_trial_level`/`me_results` object already used for the central-claim numbers. Grey lines = per-cell fixed-effect + random-intercept predictions; coloured line = population fixed-effect. Saved to `Chapter4/Figs/redone_figs/fractal_display_lme_regression_fig.svg`. This was the last open item for Category A as a whole. |
| 5 | Per-fractal claim (Table 4.3, 6 conditions): add 6 ME-model rows to existing table; add brief discussion including negative finding (Monkey V high: p=0.782 after accounting for cell-level clustering) | Mak/Ludvig | Chapter4.tex, `eq:lme_fractal` + new table `tab:lme_regression_split_fractal` | **Done 2026-08-06.** Built as a separate new table (Robert's call) rather than appended rows, matching Table 4.3's column style; caption explicitly flags the Monkey V high null as the one exception among six conditions. |
| 6 | Other regressions (Table 4.5 win/lose reveal and others): add ME model rows per table — requires running new ME models for different time windows/predictors first | Mak/Ludvig | Chapter4.tex | **Done 2026-08-06 — all 6 regressions across 3 tables.** Win/lose reveal (3: Lose~Monkey Bid, Lose~Computer Bid, Win~Profit) — see detail below. Juice delivery vs. bid (`tab:lme_juice_delivery_regression_results`, new table) and water delivery vs. budget remaining/profit (`tab:lme_water_delivery_regression_results`, new table) also done. |

### Win/lose reveal detail (part of item 6)

New equation `eq:lme_winlose` (generic Predictor\|Outcome form, reusing `eq:lme_general`'s structure), results prose, and one new combined table `tab:lme_wl_regression_results` (all 3 regressions together, matching `tab:wl_regression_results`'s column style). Built from `winlose_losses_corrections.Rmd`, rebuilt directly from spike-level data (`wl_spike_data`) with true continuous predictors throughout (not the ntile-binned proxy used for the OLS table) — confirmed via direct comparison that ntile vs. continuous barely changed the numbers.

- **Lose ~ Monkey Bid**: U $\beta=-0.658\pm0.118$, $p=2.45\times10^{-8}$; V $\beta=-0.433\pm0.103$, $p=2.60\times10^{-5}$ — both significant, consistent with the naive regression.
- **Win ~ Profit**: U $\beta=1.71\pm0.134$, $p=2.18\times10^{-36}$; V $\beta=1.02\pm0.0817$, $p=8.17\times10^{-35}$ — both significant, consistent with the naive regression (strongest of the three under both approaches).
- **Lose ~ Computer Bid**: U $\beta=-0.161\pm0.102$, $p=0.116$ (NS, consistent with naive OLS); **V $\beta=-0.590\pm0.119$, $p=7.60\times10^{-7}$ — significant, contradicting the naive OLS null (p=0.125) and the thesis's existing interpretive claim** that computer bid "doesn't matter" on loss trials. Interpreted as a missed-opportunity/near-miss signal (low computer bid on a lost trial = an affordably-missed win), distinct from Chapter 2's formal bid-choice regret (which requires suboptimal bidding); connected via random utility theory's prediction of choice stochasticity (Appendix A, `sec:rum`) rather than claiming monkeys routinely misbid. New citation added: `filiz-ozbayAuctionsAnticipatedRegret2007` (human loser-regret in auctions). Reused existing citations: `gretherMentalProcessesStrategic2007`, `casonMisconceptionsGameForm2014`, `hamukwalaDesignFactorsInfluencing2019`.

### Juice delivery detail (part of item 6)

New equation reference (Equation \ref{eq:firing_rate_mbid_regression} + \ref{eq:lme_general}), results prose, and new table `tab:lme_juice_delivery_regression_results`. Built from `juice_regression_corrections.Rmd`, same fix as win/lose (continuous `monkey_bid` was dropped in the original pipeline's `select()`, rebuilt keeping it). Grouped by monkey × win/lose (4 conditions).

- **Lose, both monkeys**: NS, consistent with naive OLS (U $p=0.875$, V $p=0.205$).
- **Win, Monkey U**: NS, consistent with naive OLS ($p=0.554$).
- **Win, Monkey V**: **$\beta=0.307\pm0.188$, $p=0.103$ — NOT significant.** This was the *only* significant result in the naive OLS table (p=0.0036, adj R²=0.333), which the existing thesis text relies on directly ("only Monkey V showed significant correlation..."). Does not hold up under proper clustering correction.

**Contrast noted in the write-up**: this null (an expected effect that disappears) sits opposite the win/lose reveal's computer-bid result (an unexpected effect that appears) — in both cases a purely payout-driven account predicts no relationship (juice magnitude is fixed by the fractal shown, not the bid), so the correction doing different things in each direction is evidence the method is behaving sensibly, not just uniformly shifting significance one way.

### Water delivery detail (part of item 6)

New equation reference (Equations \ref{eq:firing_rate_budget_regression1}/\ref{eq:firing_rate_budget_regression2} + \ref{eq:lme_general}), results prose, and new table `tab:lme_water_delivery_regression_results`. Built from `water_corrections.Rmd`, same continuous-variable fix. Both regressions fully confirm the naive OLS findings, no discrepancies:

- **Budget Remaining**: both significant (U $p=0.042$, V $p=5.15\times10^{-9}$), consistent with OLS (U $p=0.022$, V $p<0.0001$).
- **Budget Profit**: both non-significant (U $p=0.835$, V $p=0.943$), consistent with OLS (U $p=0.295$, V $p=0.586$).

Results in hand: Overall: U slope=0.781 p=9.70e-29; V slope=0.644 p=1.68e-34. Fractal-split: U all 3 significant; V high p=0.782 (NS), medium p=0.014, low p=0.007. Win/lose reveal, juice delivery, water delivery: see detail above.

## Category B - Bid-binning justification

Resolved as side-effect of Category A. ME models use `bid_perc = monkey_bid/100` as a continuous predictor throughout — no binning in the statistics. Existing binned figures (4.11 etc.) retained as visualisation aids only; a sentence in the methods noting "bids were modelled as a continuous predictor" closes the examiner's concern. No separate category-B session needed.

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | p.139 — bins used as primary analysis predictor; examiner asks for justification or switch to raw continuous bids | Ludvig report p.139 | Chapter4.tex, near `\label{fig:fractal_display_regression}` (Fig 4.11) | **Done 2026-08-05**, originally as a standalone 3-sentence paragraph acknowledging the binning and pointing to the ME model's continuous-bid result. **Superseded 2026-08-06**: that stopgap paragraph deleted once Category A's actual equation/results/table treatment was written up just above it in the same subsection (making it redundant — same numbers, less detail). B's concern is now closed by Category A's full write-up directly, not a separate note. Compiles clean. |

## Category C - Bayesian null test (utility vs. magnitude dissociation)

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Non-significant Wilcoxon test does not quantify positive evidence for the null; examiners requested a Bayesian test to properly assess evidence for no difference when bids are matched | Both examiners | Chapter4:350 | Added two paragraphs: (1) motivation for Bayesian approach; (2) BF results with contextual argument that large objective differences between fractals make the absence of a strong BF informative |
| 2 | BF analysis: one-sample Bayesian t-tests on **per-cell mean** `delta_norm_n` (not raw trial-pairs, which inflated BFs to ~10^272); Cauchy prior r = √2/2; BFs ranged 0.785–3.280, all below or at boundary of threshold of 3 | — | Chapter4:350 | Analysis run in `fd_extra_edit.Rmd`; results reported in new Table \ref{tab:bayes_factor_matched_bids} |
| 3 | New table of BF values added (6 monkey × comparison combinations) with Jeffreys evidence labels | — | Chapter4:361 | Added `tab:bayes_factor_matched_bids` |
| 4 | "BF" added to abbreviations list | — | Chapter4:350 | `\nomenclature{BF}{Bayes Factor}` added on first use |
| 5 | Two new references added to `references.bib` (chapter 3 block): Rouder et al. (2009) for method; Jeffreys (1961) for evidence thresholds | — | References/references.bib | `rouder2009bayesian`, `jeffreys1961theory` |
| 6 | PDF of Rouder (2009) added to `References/` folder — should also be copied to long-term storage drive | — | References/rouder_2009.pdf | **Done (2026-08-06)** — uploaded via `extra_lit/extra_paper_pdfs.zip` to drive, includes Rouder |

## Ethics and Data/Code Availability Statements

Mak's report asks for the ethics discussion from Hill et al. (2024, *Nat Commun*) to be incorporated into the thesis "in a form the student deems appropriate," and separately suggests a data/code availability statement matching that paper's. Source text located 2026-08-05 via the PMC open-access mirror (PMC11408490) — adapted, not copied verbatim, into thesis prose/register.

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | No ethics/licensing statement anywhere in the thesis (confirmed via search — only a passing "Home Office Project Licence" mention at Chapter3.tex:537, re: Monkey V's sacrifice) | Mak report | Chapter3.tex, `\subsection{Animals}`, new paragraph after the Rhesus macaque species-intro paragraph | Added paragraph naming the Home Office licence (Animals (Scientific Procedures) Act 1986, Regulations 2012) and the full UCam/external oversight chain (AWERB, Biomedical Service Certificate Holder, Welfare Officer, Governance and Strategy Committee, Named Veterinary Surgeon, Named Animal Care and Welfare Officer, Home Office Inspector, UK Animals in Science Committee, NC3Rs), adapted from Hill et al. (2024)'s Methods → "Animal ethics, welfare, and surgical implantation" |
| 2 | No data/code availability statement anywhere in the thesis | Mak report | Chapter3.tex, new `\subsection{Data and Code Availability}`, end of the Animals subsection | Added short statement pointing to the same Figshare deposit as Hill et al. (2024) (10.6084/m9.figshare.25734288) for processed data + published-analysis code, plus a sentence for the corrections-specific scripts |

✅ **Done 2026-08-09**: placeholder replaced with the real repo, `\url{https://github.com/RobWHickman/PhD-Thesis}` (Chapter3.tex:83). Compiles clean.

## Robert Corrections

| # | Issue | Location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | `{B_subject}` → `B_{subject}` (braces in wrong place, only subscripted `s`) | AppendixE post-corrections checklist | AppendixE:51 | Fixed |

## Category G - Newer/alternative theory engagement (causal learning etc.)

Examiner ask (joint report + Ludvig individual report, near-identical wording): "What about alternative theories in that space, such as the newer work from the Namboodiri lab on causal learning or other newer developments?" Done jointly with Category F in the same paragraphs/subsection — see that entry below for the RPE-tension half of the same content. Full literature search and drafting process logged in `extra_lit/CHANGELOG.md`, `extra_lit/rpe_plan.txt`, `extra_lit/rpe.txt`.

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Namboodiri lab causal learning not engaged with anywhere in main text | Joint report / Ludvig report | Chapter1.tex, new paragraph (between the Stauffer 2014 and "other brain regions" paragraphs) | Added clause naming causal learning as a named alternative to RPE, citing Jeong et al. 2022 (ANCCR foundational paper) and Namboodiri 2024 (concise review) |
| 2 | Namboodiri lab causal learning — main engagement | Joint report / Ludvig report | Chapter5.tex, new Section 5.4.3 "What does the dopamine signal actually compute?", Paragraph 3 | Added full paragraph explaining ANCCR's actual claim (retrospective causal contingency, not value magnitude), citing Garr et al. 2024 as the strongest empirical evidence — a direct within-paper TDRL-vs-ANCCR model comparison on real dopamine recordings |
| 3 | "Other newer developments" (unspecified by examiners) | Joint report / Ludvig report | Chapter1.tex (new paragraph); Chapter5.tex 5.4.3 Paragraph 4 | Brief citations to distributional coding (Dabney 2020, Lowet 2024, Sousa 2025 — Chapter 1) and value-free/information-gain accounts (Greenstreet 2025, Friedman 2025 — Chapter 5), as scope-limited nods rather than full treatments |
| 4 | Positioning our own findings relative to the causal-learning account | — | Chapter5.tex 5.4.3 Paragraph 4 | Added honest scope claim: our task varies subjective value trial-to-trial while holding causal structure fixed throughout, so our data speak to the value question and are largely silent on the causal-contingency question ANCCR targets; noted the two accounts aren't necessarily mutually exclusive |

✅ **Citations done, 2026-08-06** (Jeong, Namboodiri, Garr, Greenstreet, Beck & Friedman [text corrected from "Friedman et al., 2025" to the peer-reviewed 2026 citation], Sousa) — real bibtex entries added, swapped into text, compiles clean. Full page-number table in `extra_lit/CHANGELOG.md`. Section-reference placeholders also done, 2026-08-06 (labels added to Sections 5.3.1/5.4.2, all four swapped to real `Section~\ref{}` calls) — full detail in `extra_lit/CHANGELOG.md`'s "Outstanding" section.

## Category F - RPE/RL theoretical engagement

Examiner ask (joint report + Ludvig individual report, near-identical wording): "There is, of course, mention of reward prediction errors and reinforcement learning, but there is less engagement than I would expect with those theories... How do the current results interact with that theory—a number of results seem very challenging, including the very strong responses to clearly predicted outcomes?" Done jointly with Category G in the same paragraphs/subsection — see that entry above for the causal-learning half of the same content. Full literature search and drafting process logged in `extra_lit/CHANGELOG.md`, `extra_lit/rpe_plan.txt`, `extra_lit/rpe.txt`.

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | RPE theory presented as settled/uncontested throughout Chapter 1, with no acknowledgement of the predicted-outcome tension | Joint report / Ludvig report | Chapter1.tex, new paragraph (between the Stauffer 2014 and "other brain regions" paragraphs) | Added paragraph naming the tension directly — dopamine responds strongly to outcomes that are already clearly and reliably predicted, citing Howe et al. 2013 and Hamid et al. 2016 |
| 2 | Existing necessity/sufficiency paragraph (Chapter1:171) had no citation demonstrating both in one place, or extending to model-based associations | — | Chapter1:171 | Added closing sentence citing Sharpe et al. 2017 (dopamine transients necessary and sufficient for model-based associations, i.e. more than canonical RPE) |
| 3 | "The very strong responses to clearly predicted outcomes" — main engagement, tied to the thesis's own data | Joint report / Ludvig report | Chapter5.tex:83 (Section 5.3.1) and new Section 5.4.3 Paragraph 1 | Added bold forward-pointer at 5.3.1's existing "trial heterogeneity" explanation; new Paragraph 1 in 5.4.3 restates the classical-RPE extinction prediction, explicitly returns to the 5.3.1 result, and grounds the tension in the wider literature (Howe 2013, Hamid 2016, Sharpe 2017, Kahnt & Schoenbaum 2025) |
| 4 | How do the current results interact with RPE theory — resolution, not just restatement of the problem | Joint report / Ludvig report | Chapter5.tex, Section 5.4.3 Paragraph 2 | Added the thesis's position: dopamine tracks subjective utility, not objective predictability of physical magnitude — a natural extension of the existing Ch1 utility-PE account (Stauffer 2014, Lak 2014), independently reinforced by the own-lab's concurrent Ferrari-Toniolo Cell Reports paper, and consistent with recent RPE reframings (Gershman 2024's richer state/value representation; Cone et al. 2024's FLEX model, learned cue-timing as a concrete mechanism) |

✅ **Citations done, 2026-08-06** (Howe, Hamid, Sharpe, Gershman, Cone, Kahnt & Schoenbaum) — real bibtex entries added, swapped into text, compiles clean. Full page-number table in `extra_lit/CHANGELOG.md`.

## Category H - Promote appendix theory content into main chapters

Examiner ask (joint report + Ludvig individual report, same sentence as F/G): "Some of the more interesting bits that speak to theory are relegated to the appendices." No appendix or topic specified — candidate identified by reading all five appendices: Appendix B's "Do We Like Value or Do We Want It?" section (Berridge's wanting/liking dissociation, incentive salience) was the only major dopamine-theory account not touched anywhere in the main text. Approach: a short pointer paragraph (Category Z's pattern), not a full relocation, plus a small update to Appendix B itself with newer literature. Full literature search and drafting process logged in `extra_lit/CHANGELOG.md` and `extra_lit/h.txt`.

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | Wanting/liking (incentive salience) not mentioned anywhere in the main-text theory discussion | Joint report / Ludvig report | Chapter5.tex, Section 5.4.3, new paragraph (between the ANCCR paragraph and the closing positioning paragraph) | Added paragraph introducing wanting/liking as a further named alternative account, grounded in Berridge 2012/2023 and Robinson & Berridge 2025, anchored by Zachry et al. 2024's D1/D2 double-dissociation finding (salience-tracking vs. prediction-error-tracking populations in the same structure), pointing to Appendix B for the full treatment |
| 2 | Appendix B's existing wanting/liking discussion has no computational bridge to prediction-error accounts | — | AppendixB.tex, after the taste-reactivity/human-pharmacology paragraph | Added short addition citing McClure et al. 2003 and Zhang et al. 2009 (incentive salience as cached TD value) and Berridge 2012 (incentive salience as a distinct computation from value-PE) |
| 3 | Appendix B's discussion stops at 2011 (Berridge & Kringelbach), missing the last ~5 years of the debate | — | AppendixB.tex, end of "Do We Like Value or Do We Want It?" section | Added short update citing Berridge 2023, Robinson & Berridge 2025, Zachry et al. 2024, Rodrigues 2024, Guillaumin et al. 2023 |

✅ **Citations done, 2026-08-06** (Robinson & Berridge, Berridge 2012/2023, Zachry, McClure, Zhang, Rodrigues [resolved to 2025, not the original 2024 placeholder guess], Guillaumin) — real bibtex entries added, swapped into text, compiles clean. Full page-number table in `extra_lit/CHANGELOG.md`.

## Category D - Single-fractal effect: behavioural write-up

Examiner ask (both reports, independently, near-identical wording — see full verbatim quotes in `extra_lit/d.md`): the d=0.467 (Monkey V) single-fractal context effect is downplayed relative to its size; take it seriously as a *relative valuation* effect, drawing on the behavioural economics literature. Full search/draft process in `extra_lit/d.md`.

All edits in `Chapter3/chapter3.tex`, `\subsection{Single Fractal Sessions}` (starts line 417). **Cross-reference check**: `\label{subsec:dopamine_single_fractal}` is defined at `Chapter4.tex:289`, immediately under `\subsubsection{Dopaminergic Responses in Single-Fractal Sessions}` (heading itself at `Chapter4.tex:288`); it's referenced once, at `Chapter3.tex:433`, via `Section~\ref{subsec:dopamine_single_fractal}` (inside paragraph 3 below). Compiles clean and currently resolves to **"Section 4.3.2"** in the compiled PDF (verified via direct PDF text extraction, not just 0-undefined-refs). Worth a manual check that 4.3.2 still points at the right place if anything upstream shifts numbering before submission.

| # | Paragraph | First sentence | Length | File & line |
|---|---|---|---|---|
| 1 | Relative valuation reframe — replaces the original "task independence effects... temporal effect" sentence | "These differences are naturally interpreted as a relative valuation effect: in single-fractal sessions, the monkey never encounters the higher- or lower-value fractals within that session..." | ~195 words, 3 sentences | Chapter3.tex:421 (appended to end of existing paragraph) |
| 2 | Temporal-vs-context argument — new paragraph | "This differs from a purely temporal explanation, which the data argue against." | ~95 words, 3 sentences | Chapter3.tex:423-429 |
| 3 | Individual differences / dopamine cross-reference — new paragraph | "For Monkey U, this effect is absent, but range adaptation in primate value coding is typically partial rather than complete, even in its canonical demonstrations." | ~115 words, 4 sentences | Chapter3.tex:431-436 |
| 4 | Trim of the original closing sentence (removed, not added — the p=0.716/d=0.024 restatement was now redundant with paragraph 2) | "Though the population mean bids for each context are not negligibly different (dotted and dashed lines), the mean bids for each monkey continue roughly where they ended..." | Shortened from 2 sentences (~43 words) to 1 (~38 words) | Chapter3.tex:438 |

Citations used (bold placeholders, not yet in `references.bib`): Padoa-Schioppa (2009) and Stewart, Chater & Brown (2006) in paragraph 1; Tobler, Fiorillo & Schultz (2005) in paragraph 3. All three are the "3-star" set from this session's literature search (`extra_lit/d.md`) — 2-star/1-star candidates (Rustichini et al. 2017, Louie & Glimcher, Cox & Kable 2014, Vlaev et al. 2007, the 2019 partial-adaptation paper) were not needed and left unused.

✅ **Citations done, 2026-08-06** — Padoa-Schioppa (2009) and Stewart, Chater & Brown (2006) both added to `references.bib` and swapped into text (Chapter3.tex:427, PDF p.98); Tobler was already done. All three real, compiles clean, 0 undefined citations/references.

## Category E - Single-fractal effect: dopamine re-analysis

Examiner ask (joint report): "...the related dopamine response should be examined, as this could be extremely strong evidence for the core contention that dopamine corresponds to utility rather than reward." Scoped to Chapter 4 (dopamine) only, per prior discussion — the corresponding behavioural write-up is Category D, not yet done.

Two analyses run on the existing single-fraction cell population (Monkey U n=21, Monkey V n=24 — same population as Figures `fig:monkey_bid_fractal_display_quintiles_one`/`fig:fractal_display_regression_one`):
1. **Context comparison** — does the dopamine response to the medium fractal differ between single-fractal and multi-fractal sessions, mirroring the behavioural context effect? Trial-level LME (`lmer(norm_n ~ session_type + (1|cell), REML=FALSE)`) + Bayes factor (per-cell means, one-sample Bayesian t-test) — both null for both monkeys, BF gives moderate evidence *for* no context effect.
2. **Value-tracking regression** — does dopamine track offer value for the medium fractal at all, within single-fractal sessions? Trial-level ME regression (`lmer(norm_n ~ bid + (1|cell))`), not the binned OLS used elsewhere in the chapter — significant positive for Monkey V, positive trend (not significant) for Monkey U.

✅ **Independently re-checked by Robert, 2026-08-06 — confirmed correct, closed.** Mid-session, an earlier version of the regression (built on a broader, non-official cell population) gave the *opposite* sign for Monkey V (significant negative). This was traced to that version omitting the file's own existing inclusion criteria (`DABidResponsive` filter + low-bid-bin exclusion for Monkey V, already used elsewhere in this exact subsection) — using the correct, established population resolved it to positive, consistent with Monkey U. Table `tab:medium_fractal_regression`'s numbers are from the correctly-filtered run.

| # | Issue | Examiner location | File & line | Fix applied |
|---|---|---|---|---|
| 1 | No dopamine-side test of the single- vs multi-fractal context effect existed anywhere in the thesis | Joint report | Chapter4.tex, new `\subsubsection{Dopaminergic Responses in Single-Fractal Sessions}`, after Figure `fig:fractal_display_regression_one` | Added LME (session type + (1\|cell)) + Bayes factor (per-cell means) test; both null for both monkeys (U: β=−0.018±0.140, p=0.898, BF₀₁=4.72; V: β=−0.055±0.055, p=0.323, BF₀₁=3.25); new Table `tab:context_comparison` |
| 2 | This comparison is structurally different from the behavioural one (never previously flagged) | — | Chapter4.tex, same subsubsection | Added explicit caveat: single-/multi-fractal session cells are different, non-overlapping neurons (never re-recorded across session types) — comparison is between-cells, not within-cell like its behavioural counterpart, reducing sensitivity independent of sample size |
| 3 | Whether dopamine tracks value at all for the medium fractal — needed to interpret the context-null result correctly (a null on context alone can't distinguish "tracks value but context-invariant" from "doesn't track value") | Raised during working session, not a direct examiner ask | Chapter4.tex, same subsubsection | Added trial-level ME regression using the same cell/trial inclusion criteria as Figure `fig:fractal_display_regression_one`; significant positive for Monkey V (β=0.584±0.253, p=0.021), positive trend for Monkey U (β=0.189±0.109, p=0.084, underpowered — n=3589 trials/21 cells vs. n=841/24 cells for V); new Table `tab:medium_fractal_regression` — see ⚠ above |
| 4 | Interpretation tying the context-null and value-tracking results together | — | Chapter4.tex, closing paragraph of subsubsection | Added synthesis: dopamine tracks offer value but does not show the context-relative modulation seen behaviourally in Monkey V (d=0.467, Chapter 3) — an absolute rather than context-relative value signal, at least for the medium fractal |
| 5 | This whole span of Chapter 4 (~230 lines) had no internal subsection structure | — | Chapter4.tex | Added `\subsubsection{Dopaminergic Responses in Single-Fractal Sessions}` (new content) and `\subsubsection{Dopaminergic Responses Split by Offer Value}` (demarcating existing three-fractal split-regression content, unchanged) |
| 6 | R package/function references inconsistently formatted thesis-wide, surfaced while writing this section | — | Chapter4.tex (`lme4`/`lmerTest`, `wilcox.test`/`kruskal.test`/`stats`/`dunn.test`); Chapter3.tex (`ggplot2`/`tidyverse`/`stats`/`betareg`/`fitdistrplus`/`gamlss`) | Standardised all R package/function references thesis-wide to `\texttt{}` (previously plain text or single-quoted); added `kuznetsova2017lmertest` citation for lmerTest alongside `bates2015fitting` for lme4; all citations within the new section use bracketed `\citep{}` |
| 7 | Two forward-reference placeholders to the (not-yet-written) Category D behavioural section | — | Chapter4.tex, new subsubsection | Both point to *existing* content (Chapter 3's `fig:single_fractal_bids`, already contains the d=0.467 discussion), so resolved immediately rather than left as bold placeholders — unlike Categories F/G/H, this category has **no outstanding placeholder citations** |

No new placeholder citations from this pass — `bates2015fitting` and `kuznetsova2017lmertest` are both real, complete bibtex entries in `references.bib`. Compiles clean throughout (0 undefined citations/references, 244 pages, checked after every edit this session).

⚠ **To check before submission:**
- **Citation brackets** — this session discovered `\citep`/`\citet`/`\citealt` don't auto-generate brackets in this document's package configuration (natbib + `apalike` + custom class interaction); the thesis-wide convention (370 uses) is bare `\cite{}` with brackets typed manually where wanted. All citations touched this session were fixed to match, verified against the actual rendered PDF text (not just source) — but this convention has never been explicitly documented anywhere, so it's worth a spot-check that no other session/pass has assumed `\citep` "just works".
- **Equation formatting** — the new model descriptions in this section (e.g. "normalised firing rate $\sim$ session type + $(1|\text{cell})$") are written inline within prose parentheses, unlike other model formulas elsewhere in Chapter 4 (e.g. `eq:residual_regression`, `eq:normalized_firing_rate_regression_fractal`), which use proper numbered `\begin{align}...\end{align}` equation environments. Worth deciding whether these should be converted to formal numbered equations for consistency.

## Category I - Novel aspects of the data (Section 5.4) + p.86 WTP factors

Examiner ask (Mak only, not corroborated by Ludvig — full verbatim in `category_i_scope.md`): (1) "I wonder if more can be said about any other novel aspects of the data... the related discussion seems to be largely concentrated on one page in Section 5.4"; (2) p.86 — "could some meaningful potential factors be explored, if only speculatively" for the BDM-vs-binary-choice WTP discrepancy; (3) p.145/p.155 — surprising results given only a "quick explanation."

Scoping done first in `category_i_scope.md` (2026-08-07), which found that Section 5.4 had already grown substantially via Categories F/G/H (theory content), but Chapter 5 still said almost nothing about this session's own Category A/C/E findings — the actual "novel aspects of the data" Mak was asking about. Rather than writing one expanded section, the session did a full chapter-by-chapter audit of Chapters 1-4 against Chapter 5's Discussion (logged in `category_i_scope.md` under "Potential results to discuss") and worked through the HIGH/MED items directly, mostly as short additions to existing Chapter 5 paragraphs rather than a single new block of text. Scope grew beyond the original 3-item Mak ask as a result — documented here in full since most of it is downstream of the same audit.

**p.145/p.155 not resolved this session** — page numbers have drifted too far from the original examiner review to trust the original numbers; still needs a content-based search next time, not a page-number search.

One correction (not an addition) surfaced during this pass: Chapter5.tex's win/lose section had stated as settled fact a finding Category A's own mixed-effects re-analysis (done in an earlier session) had since overturned — see item 9 below.

| # | Issue | File & line | Fix applied |
|---|---|---|---|
| 1 | Chapter 5 never mentioned the BDM-vs-binary-choice WTP divergence (Table `tab:wtp_ttest`) or connected it to Chapter 2's endowment-effect theory | Chapter5.tex:46, 48 | Added Monkey V's high-reward-level reversal as a named exception; added paragraph noting the general pattern runs counter to the human auction-vs-choice literature and to what Chapter 2's endowment effect would predict, with an early-termination caveat on the one condition that does match convention (Monkey V's binary-choice sessions were curtailed by her cranial implant failure) |
| 2 | p.86 gave only one explanation (citing the general human auction-vs-choice literature) for the WTP divergence — Mak's ask was for "meaningful potential factors" (plural), something more specific to this thesis's own design | Chapter3.tex:629 | Added one sentence on differential familiarity: monkeys had completed orders of magnitude more BDM trials than bundle-choice trials by the time of recording, and familiarity is already cited elsewhere in this thesis (Chapter 2, Tuncel meta-analysis) as narrowing WTA-WTP-type gaps |
| 3 | Duplicate citation list (Banerji/Hamukwala/Lusk) appeared verbatim in both Chapter 3 and the new Chapter 5 paragraph for the same claim | Chapter5.tex:48 | Removed from Chapter 5; replaced with a prose pointer back to Chapter 3 |
| 4 | Single-fractal behavioural context effect (d=0.467 Monkey V / d=0.077 Monkey U, Category D's whole subject) was not mentioned anywhere in Chapter 5, despite being one of the two things the joint examiner report names as under-discussed | Chapter5.tex:56 | Added paragraph summarising the effect and its relative-valuation interpretation, framed as the first of several "monkeys diverge from one another" instances developed later in the chapter |
| 5 | The direct neural test of whether this behavioural effect is mirrored in the dopamine signal (Category E, Chapter4.tex:330-364) — the joint report's "extremely strong evidence" ask — was not mentioned in Chapter 5 at all | Chapter5.tex:58 | Added paragraph reporting the null result honestly (LME + per-cell Bayes factors both favour no context effect, for both monkeys), including the between-cells-not-within-cell sensitivity caveat, and the fact the response still tracks bid for Monkey V despite showing no context-dependence |
| 6 | Binary-choice regression paragraph reported juice/water dominance but omitted the side-bias finding (Monkey U negligible right bias, Monkey V significant left bias) | Chapter5.tex:60 | Added one sentence reporting both biases |
| 7 | Per-fractal split LME finding (Monkey V's high-fractal relationship — the naive regression's *strongest* single result — becomes non-significant once cell-level clustering is corrected for) was in Chapter 4 only, not referenced in Chapter 5 | Chapter5.tex:71 | Added sentence to the existing "held even when controlling for objective reward magnitude" paragraph |
| 8 | Bayes factors for matched-bid trials (the actual quantitative "dopamine tracks utility not magnitude" evidence, Chapter4.tex:437-465) were described in Chapter 5 only qualitatively, pre-dating the Bayesian analysis | Chapter5.tex:73 | Added BF summary (5/6 comparisons show no evidence for residual magnitude effect, 6th only marginally over threshold — reported as genuinely equivocal, not spun as a clean result) |
| 9 | **Correction**: central bid-dopamine mixed-effects confirmation ($\beta=0.781/0.644$, Chapter4.tex:230-264) — the single most examiner-requested analysis in the whole corrections process — was not mentioned in Chapter 5's core dopamine-bid paragraph, which still only cited the naive $R^2=0.85/0.88$ | Chapter5.tex:75 | Added mixed-effects confirmation with $\beta$/p-values for both monkeys |
| 10 | **Correction**: Chapter5.tex stated as settled fact that "for Monkey V, but not Monkey U, the change in normalised firing rate... was linearly correlated with the bid" at juice payout — Category A's LME re-analysis (Chapter4.tex:681-683) found this is *not* significant once cell-clustering is corrected for ($p=0.103$ vs. the naive $p<0.005$ this sentence relied on) | Chapter5.tex:91 | Rewrote to report the naive finding, then state plainly it did not survive mixed-effects correction and should be treated as a false positive |
| 11 | **Correction + addition**: Chapter5.tex stated "neuronal activity showed no significant relationship to the computer's bid" on loss trials — true under the naive regression, but Category A's LME found Monkey V *does* show a significant relationship ($\beta=-0.590$, $p=7.60\times10^{-7}$), interpreted as a missed-opportunity/regret-like signal, not previously mentioned in Chapter 5 | Chapter5.tex:85 | Rewrote to report both the naive null and the LME-revealed significant result, with the regret-signal interpretation (cross-referencing Chapter 4's fuller anticipated-regret discussion) |
| 12 | No mention anywhere in Chapter 5 of Chapter 3's own "hot hand"-adjacent finding (monkeys bid higher after winning the previous trial and after a higher previous computer bid, Chapter3.tex:379/404) — a natural behavioural parallel to item 11's neural finding | Chapter5.tex:87 | Added new paragraph drawing the parallel explicitly: the computer's bid carries more behavioural and neural weight, across both chapters, than a strictly incentive-compatible reading of the BDM would predict |
| 13 | No discussion anywhere in Chapter 5 of individual differences between the two monkeys as a recurring pattern (raised piecemeal in Chapters 3 and 4 but never gathered together); user explicitly asked for this to be light-touch — describe, don't over-explain, and not framed as a limitation | Chapter5.tex:95-101, new `\subsection{Individual differences between subjects}` | Added short subsection (end of Section 5.3, before Section 5.4) covering the single-fractal effect, the starting-bid/liquid-driver reversal, and the win/lose valence "reversal" (with the tercile-split complication noted, since it likely reflects bid-distribution differences rather than distinct computations) |
| 14 | Movement/effort residual analysis (Chapter4.tex:273-305 — joystick movement parameters don't correlate with the bid-firing residual) existed only in Chapter 4; Chapter 5's Limitations/future-directions paragraph on effort (citing Burrell 2023) asserted effort was "treated as negligible" without any supporting evidence | Chapter5.tex:118 | Added sentence citing the residual-regression null result as support for that assumption, while still flagging effort was not systematically manipulated |

Compiled clean throughout (0 undefined citations/references), checked after each batch of edits.

## Acknowledgements

Not tied to any examiner category — Robert's own additions/edits.

| # | Issue | File & line | Fix applied |
|---|---|---|---|
| 1 | Examiners not thanked anywhere in the Acknowledgements | Acknowledgement.tex | Added a sentence thanking Prof. Vincent Mak and Prof. Elliot Ludvig by name, in the same paragraph as the advisor/lab thanks |
| 2 | Acknowledgements ran slightly over a page, and used the same opening ("I would (also) like to thank...") four separate times | Acknowledgement.tex | Trimmed wording throughout without cutting any names; varied three of the four repeated openings (kept "Above all I would like to thank" for the climactic paragraph only); merged the Martin Crevier/Darwin Boat Club paragraph into the following "Outside of Cambridge" paragraph, since both were short enough not to need separate paragraphs |

Compiles clean.
