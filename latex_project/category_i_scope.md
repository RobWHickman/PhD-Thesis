# Category I — Scoping rundown (2026-08-07)

Temporary working doc. Not part of the corrections tracking system (CHANGELOG.md /
extra_lit/) — delete or fold findings in once Category I is actually drafted.

## Examiner's verbatim text (Mak only — not corroborated by Ludvig)

Three separate pointers, all from the same paragraph block in Mak's individual report:

**1. The core "Section 5.4" ask:**
> "That said, these results are in line with well-established results about dopamine
> reward signals, and I wonder if more can be said about any other novel aspects of the
> data. Currently, the related discussion seems to be largely concentrated on one page
> in Section 5.4. The rest of Section 5 offers some good insights that might be worth
> further exploration in the sense discussed here."

**2. p.86 — BDM vs. binary-choice WTP discrepancy:**
> "While both Al-Mohammad and Schultz (2022) and the present research have similar
> behavioural components and had the same monkey participants, there also seem to be
> some differences between the results. For example, as summarised on p.86, the binary
> choice utility results from the present research seem to be lower than those obtained
> from the BDM method, while they were about the same in Al-Mohammad and Schultz
> (2022). Beyond the brief discussion on p.86, could some meaningful potential factors
> be explored, if only speculatively? These might also increase the potential
> contributions of the behavioural component beyond a replication."

**3. p.145 / p.155 — surprising results given only a quick explanation:**
> "More generally, it seems that some of the results are more intriguing than
> straightforwardly predictable from previous research. In those cases, the student
> tends to offer a quick explanation (e.g., p.145 and p.155, last paragraph). Maybe
> some of those observations could promise new avenues of research and are worth a
> more detailed discussion."

**Note on what this is *not* asking for**: this is not primarily a theory-engagement
request (that's Categories F/G/H, already done). It's specifically about (a) whether
Section 5.4's discussion is too thin relative to the rest of Section 5, and (b) two
named instances of results getting a one-line explanation rather than a real one. Don't
scope this as "expand the theory" — it already has a home (5.4.3) — scope it as
"is there real novelty in *our own data* being undersold."

## What's already scoped (from CLAUDE.md, prior session)

> Approach decided: a short paragraph of extra interpretation per flagged result, not a
> single expanded section.

This still seems right. Confirmed by re-reading the verbatim text above — Mak is
asking for *more*, not a restructure.

## Important update: Section 5.4 is no longer "concentrated on one page"

Checked current structure of `Chapter5/chapter5.tex`:

```
\section{Contribution to the dopaminergic neuroscience literature}   (line 86)
  \subsection{Limitations of our study and future directions of research}  (94)
  \subsection{A distributed code for dopaminergic signalling}              (106)
  \subsection{What does the dopamine signal actually compute?}             (112)
```

Section 5.4.3 ("What does the dopamine signal actually compute?") was added by
Categories F/G/H (~950 words, 4–5 paragraphs) *after* Mak's review. Section 5.4 is
therefore already substantially longer and more developed than what he originally saw.

**But** — F/G/H's addition is mostly theoretical positioning (RPE tension, causal
learning, wanting/liking). Mak's specific complaint was about "novel aspects of the
*data*," not theory. So the raw word-count problem is probably resolved, but the
underlying ask (is there real data-driven novelty being undersold) may not be.

## New development this session: Category A surfaced exactly the kind of thing Mak is asking about

Two genuinely novel, data-driven findings came out of this session's Category A work,
neither connected to well-established prior dopamine literature, neither yet
cross-referenced from Chapter 5:

1. **Monkey V's computer-bid "near-miss"/regret-like signal on loss trials**
   (Chapter4.tex, win/lose reveal section) — dopamine tracks the computer's bid
   specifically when it shouldn't (payout is fixed regardless), interpreted via
   anticipated-regret literature (Filiz-Ozbay & Ozbay 2007) and Chapter 2's own regret
   framework. This is about as "novel aspect of the data" as it gets — not predicted by
   standard reward-signal accounts at all.
2. **Monkey V's juice-payout bid-tracking disappearing under proper clustering
   correction** — the inverse case, a seemingly-solid naive finding that doesn't
   replicate. Also novel, in the sense that it's a genuine methodological/data story
   specific to this thesis.

Neither of these is mentioned anywhere in Chapter 5's discussion yet. This looks like
the strongest, lowest-effort way to satisfy the core Section 5.4 ask: point *from*
5.4 *to* this already-written material, rather than writing new theoretical content.

## p.86 — located and checked

Chapter3.tex:629 (page number will have shifted from the original "86" given how much
has been added since; re-locate by content, not number, when drafting). Existing text
already:
- States the discrepancy (BDM lower than binary choice, opposite direction to
  Al-Mohammad & Schultz 2022).
- Gives **one** explanation: cites human behavioural-economics literature on
  auction-vs-choice WTP divergence (Banerji, Hamukwala, Lusk).

**Gap**: Mak explicitly asks "could some meaningful potential factors be explored, *if
only speculatively*" — plural "factors," implied more than the one citation-backed
explanation already there. Needs a short, honestly-hedged speculative addition (e.g.
something specific to *this* thesis's design — head-fixation, the specific monkeys,
task order effects — not just pointing at the general human literature again).

## p.145 / p.155 — not yet re-located, flagged for next session

Not re-checked against current line numbers this pass. Two candidate leads from
earlier categories worth checking first before assuming these need fresh work:
- p.145 was also flagged in Category W (typo pass) as being near a missing Table 4.3
  reference — i.e. in the vicinity of the per-fractal split discussion, which this
  session substantially expanded (new ME equation, results paragraph explicitly
  discussing the Monkey V high null). **Possible this is already resolved** as a side
  effect of Category A's per-fractal work — needs checking, not assuming.
- p.155 not yet identified at all. Needs a fresh page-content search next session
  (search by nearby text/context, not by number, since numbering has drifted).

## Recommendation for scope (add/remove)

**Add to scope:**
- A short paragraph in Section 5.4 (or a new brief 5.4.4, if it doesn't fit naturally
  into an existing subsection) explicitly naming the two Category A findings above as
  the "novel aspects of the data" — with real cross-references to the Chapter 4
  sections/tables, not just a restatement.
- The p.86 speculative-factors addition (small, targeted).

**Remove/de-scope:**
- Don't treat this as "Section 5.4 needs more theory" — F/G/H already did that, and
  re-litigating it risks bloat Mak didn't ask for.
- Don't assume p.145/p.155 are still open without checking — real risk of
  duplicating work already done incidentally by Category A/M.

## Next steps (not done this pass)
1. Re-locate p.145 and p.155 by content search in the current PDF.
2. Confirm whether Category A's per-fractal write-up already covers p.145's ask.
3. Draft the Section 5.4 cross-reference paragraph (Category A findings) once above is confirmed.
4. Draft the p.86 speculative-factors addition.

---

## Potential results to discuss (2026-08-07)

Full read-through of Chapters 1–5 plus the appendices, done specifically to answer:
*what results currently sitting in Chapters 1–4 (or generated by this session's own
Category A/C/E work) are thin, missing, or now stale in Chapter 5's Discussion?* This is
deliberately broader than Category I's three verbatim examiner pointers above — Mak
asked a general question ("more can be said about novel aspects of the data") and this
is the fuller audit of what "more" could mean, so scope can be chosen from it rather than
guessed at.

Everything below is a candidate, not a commitment. Priority tags (**HIGH / MED / LOW**)
reflect examiner-relevance and how novel/surprising the finding is, not effort. Line
numbers are current as of 2026-08-07 and will drift as edits land — re-grep before
relying on them.

### Top picks, if only doing a handful

1. **(HIGH, correction not just addition)** Chapter5.tex:81 currently states as settled
   fact that Monkey V's dopamine response at juice payout "was linearly correlated with
   the bid made for the good." Category A's mixed-effects re-analysis
   (Chapter4.tex:681–683) found this relationship is **not significant** once cell-level
   clustering is corrected for ($\beta = 0.307 \pm 0.188$, $p = 0.103$, vs. the naive
   $p < 0.005$ this sentence is currently based on). This isn't an omission, it's a
   sentence that has become **wrong** as a side effect of this session's own work
   elsewhere in the thesis, and is the single highest-priority item on this list.
2. **(HIGH)** The single-fractal dopamine session-context null result (Category E,
   Chapter4.tex:330–364, Table `tab:context_comparison`) is completely absent from
   Chapter 5. This is the direct neural test of the exact comparison the joint examiner
   report called out as potentially "extremely strong evidence" for the utility (not
   reward) account — and it came back null (LME + Bayes factors both favouring no
   context effect, for both monkeys), in contrast to the real behavioural effect in
   Monkey V (Chapter 3, $d=0.467$). That contrast — real behaviourally, absent
   neurally, for the one monkey who shows the effect — is a genuinely interesting,
   examiner-relevant result currently discussed nowhere outside Chapter 4 itself.
3. **(HIGH)** The central bid–dopamine claim's mixed-effects confirmation
   (Chapter4.tex:230–264, $\beta=0.781/0.644$) — the single most-requested examiner
   correction of the whole corrections process — is not mentioned anywhere in Chapter
   5's core dopamine section (Chapter5.tex:64–69), which still only cites the naive
   $R^2 = 0.85/0.88$. The chapter that exists specifically to sell this thesis's central
   claim to the examiners doesn't mention the analysis they asked for.
4. **(HIGH)** The Bayes factor analysis for matched-bid trials (Chapter4.tex:437–465,
   Table `tab:bayes_factor_matched_bids`) — the actual quantitative evidence for the
   "dopamine tracks utility, not magnitude" dissociation — isn't referenced in Chapter 5
   at all. Chapter5.tex:67 currently describes this only qualitatively ("dopamine
   neurons showed remarkably similar activity patterns"), pre-dating the Bayesian
   analysis that now backs that sentence up with numbers.
5. **(HIGH)** Monkey V's computer-bid "missed-opportunity"/regret-like signal on loss
   trials (Category A, Chapter4.tex:574–586) — a striking, non-obvious, LME-revealed
   finding with a real interpretive story (anticipated regret, Random Utility Theory,
   Chapter 2's own regret framework) already written up in Chapter 4 — is not mentioned
   in Chapter 5 at all. This is about as close to "novel aspect of the data" as this
   thesis has to offer and is currently invisible to a reader who only reads the
   Discussion.

### Chapter 1 — Organisms as utility maximisers

Chapter 1 is background/theory (utility theory, RPE, TD learning, alternative dopamine
accounts) rather than a results chapter, and its content is already the most
heavily-engaged-with material in Chapter 5 (Section 5.4.3 draws directly on it). No new
"result" to surface here — flagged only for completeness. One small thing:

- Chapter 1's own framing of alternative dopamine accounts (causal learning,
  wanting/liking, distributional/heterogeneous coding — Chapter1.tex:179) is written as
  a forward-pointer to Section 5.4.3, and that promise is kept. No gap.

### Chapter 2 — Auction Theory as a Neuroscientific Tool

- **(MED) The endowment effect / WTA–WTP disparity discussion (Chapter2.tex:166–172) is
  never connected to this thesis's own WTP data.** Chapter 2 discusses at length why BDM
  willingness-to-pay might systematically diverge from binary-choice willingness-to-pay
  (endowment effect, disappointment-aversion, familiarity reducing the gap with more
  trials) — and Chapter 3 then finds exactly this kind of divergence (Table
  `tab:wtp_ttest`, Chapter3.tex:629–664: BDM WTP significantly *lower* than bundle-choice
  WTP for most conditions, but *higher* for Monkey V's highest reward level). This is
  precisely the p.86 item Mak asks about, and Chapter 2's own theoretical material
  (endowment effect, familiarity/experience reducing WTA–WTP gap) is sitting right there,
  already cited, as one of the "meaningful potential factors" his report asks for —
  it just hasn't been pulled through to the p.86 discussion or to Chapter 5. Natural
  input to the already-planned p.86 addition, not a separate task.
- **(LOW)** The three computer-bid-distribution comparison (uniform/normal/matched-normal,
  Chapter2.tex:238–247, Figures `bdm_computer_bids`) is summarised at a sentence level in
  Chapter 5 already ("comparing uniform, normal, and matched normal distributions"). Fine
  as is; no strong case for expansion, this is task-design justification rather than a
  "finding."

### Chapter 3 — Non-Human Primate Behaviour on the BDM Task

- **(HIGH) The single-fractal behavioural context effect ($d=0.467$ Monkey V,
  $d=0.077$ Monkey U; Chapter3.tex:423–451) is not mentioned in Chapter 5's summary of
  Chapter 3 findings at all** — despite being Category D's entire subject and one of the
  two things the joint examiner report singles out by name as under-discussed relative to
  its size. Chapter 5's "Non-human primates can be trained..." section (Chapter5.tex:32–54)
  covers rank-ordering, satiety, BDM-vs-binary-choice, and optimal bidding, but has no
  sentence on the relative-valuation/range-adaptation story Chapter 3 now tells at length
  (offer-value neuron range adaptation, Padoa-Schioppa 2009; sampling-based choice,
  Stewart 2006). Given Category D's write-up already exists and is well-grounded, this is
  close to a "surface what's already written" task rather than new writing.
- **(MED) The "hot hand"-adjacent finding that monkeys bid *higher* after winning the
  previous trial, and after a higher previous computer bid** (Chapter3.tex:379, 404,
  $\beta_5$/$\beta_4$ in Table `tab:beta_regression`) is discussed at some length in
  Chapter 3 (explicitly contrasted with the psychological "hot hand" literature,
  Gilovich 1985) but never surfaces in Chapter 5. This pairs naturally with Category A's
  new win/lose computer-bid finding (item 5 above, Chapter4.tex:582–584) — both are
  cases where information about a recent/opposing bid has a behavioural or neural
  footprint it theoretically "shouldn't," on the BDM's own incentive-compatibility logic.
  A single paragraph connecting the two (bid-level effect in Chapter 3, dopamine-level
  effect in Chapter 4) would be a genuinely novel cross-chapter observation, not just a
  restatement.
- **(MED) Individual differences in what drives single-fractal bidding**
  (Chapter3.tex:483–498, Category P territory): Monkey U's bids are driven by starting-bid
  anchoring with no liquid-satiety effect; Monkey V's are dominated by total liquid
  received with almost no anchoring effect, and the *sign* of the starting-bid
  coefficient even reverses between animals. Chapter 3 discusses this reasonably
  thoroughly itself, but Chapter 5 has no discussion of individual differences between
  the two monkeys anywhere — a striking omission given how often the two monkeys diverge
  across this thesis (see also the WTP item below, and the juice/computer-bid LME
  discrepancies in Chapter 4, all of which are Monkey-V-specific). A short "on individual
  differences" paragraph gathering these threads could be a nice, honest addition,
  distinct from claiming either monkey's pattern is "the" finding.
- **(HIGH, ties to Category I's p.86 item directly) The BDM-vs-bundle-choice WTP
  divergence itself** (Chapter3.tex:629–664, Table `tab:wtp_ttest`, Figure
  `fig:wtp_comparison`): BDM WTP significantly lower than bundle-choice WTP for both
  monkeys at low/medium reward, but significantly *higher* for Monkey V at the highest
  reward level (indifference point extrapolates beyond the tested range entirely). This
  is the exact result Mak's p.86 comment refers to. Already flagged above as located at
  Chapter3.tex:629 with one existing explanation (human auction-vs-choice literature);
  see the Category I section above for what's missing there (plural "meaningful
  potential factors," not just one).
- **(LOW) Three-cluster joystick bidding typology** (Chapter3.tex:229–306,
  k-means clusters of fast-down/fast-up/dithering movement): Chapter 5's one-line summary
  ("either quickly moving to a desired bid, or dithering...") undersells this to two
  patterns when the data show three (two fast, directionally opposite, plus one slow).
  More substantively, Chapter 5's Limitations section (Chapter5.tex:100, citing Burrell
  2023) proposes studying whether effort is integrated into the dopamine value signal as
  future work, but never connects this to the joystick clustering data already collected
  and analysed in Chapter 3, or to the explicit finding there that effort costs seem
  negligible for this task (Chapter3.tex:317, "the bidding itself requires little effort
  from the monkeys"). Worth a one-line cross-reference so the future-directions
  paragraph doesn't read as if no effort-relevant data exists yet.

### Chapter 4 — Dopamine neurons encode trial-by-trial subjective reward value

This is where most of this session's own Category A/C/E work lives, and where the gap
between "what Chapter 4 now shows" and "what Chapter 5 says Chapter 4 shows" is largest.
Ranked roughly by how much the finding changes or extends the thesis's central claim:

- **(HIGH, correction) Monkey V's juice-payout bid correlation is now null under LME**
  — see Top Pick #1 above. Chapter5.tex:81 needs editing, not just supplementing.
- **(HIGH) Central-claim mixed-effects confirmation absent from Discussion** — see Top
  Pick #3. Chapter4.tex:230–264 (equation `eq:lme_general`, $\beta=0.781/0.644$,
  Figure `fig:fractal_display_lme_regression`, the spaghetti plot) is arguably the single
  most examiner-relevant piece of new material in the entire corrections process, and
  Chapter 5's core paragraph (Chapter5.tex:67) doesn't reference it.
- **(HIGH) Bayes factors for matched-bid trials absent from Discussion** — see Top Pick
  #4. Chapter4.tex:437–465.
- **(HIGH) Single-fractal dopamine context-null result absent from Discussion** — see
  Top Pick #2. Chapter4.tex:330–364.
- **(HIGH) Win/lose computer-bid regret-like signal absent from Discussion** — see Top
  Pick #5. Chapter4.tex:574–586.
- **(MED) Per-fractal split LME: Monkey V's high-fractal relationship vanishes under
  clustering correction** (Chapter4.tex:404–429, Table `tab:lme_regression_split_fractal`):
  the naive regression's *strongest* single result (Monkey V, high fractal, adjusted
  $R^2=0.62$) becomes non-significant ($\beta=0.160\pm0.578$, $p=0.782$) once cell-level
  clustering is corrected for — a striking demonstration of exactly why the
  mixed-effects correction mattered, and a natural companion example to sit alongside the
  win/lose computer-bid discrepancy (which went the other direction: null becoming
  significant). Currently only in Chapter 4; not mentioned in Chapter 5 at all. This is
  also a plausible candidate for closing out the p.145 "quick explanation" item once that
  page is re-located (per the Next Steps above) — worth checking against p.145's actual
  content before assuming it's the same issue.
- **(MED) Movement/effort residual analysis returns a clean negative result**
  (Chapter4.tex:273–305, Table `tab:residual_regression_results`): none of gross
  movement, net movement, or bidding time correlate with the residual of the bid–firing
  regression, for either monkey. This is a clean, already-run test of exactly the kind of
  effort-confound question Chapter 5's Limitations section (Chapter5.tex:100) proposes as
  future work — worth a one-line pointer there ("preliminary evidence within this task
  suggests movement parameters do not confound the bid signal, though effort was not
  systematically manipulated") so the future-directions paragraph doesn't imply the
  question is entirely untouched.
- **(LOW) Water delivery LME fully replicates the naive result** (Chapter4.tex:753–770)
  — no discrepancy, so low priority for new discussion text, but could get the same
  one-clause "confirmed by mixed-effects modelling" treatment as the central claim for
  internal consistency once/if that's added elsewhere.
- **(LOW) Recording coordinate heatmap and cell-yield summary** (Figure
  `fig:recording_coords`, Table `tab:all_cells_significance`) are purely methodological/
  descriptive; no case for discussion-chapter treatment.

### Appendices

Reviewed A–E; nothing found that constitutes an undiscussed *result* in the sense this
section is scoped to (empirical finding from this thesis's own data). Appendix A's
Random Utility Theory section and Appendix B's wanting/liking section are already
correctly cited from Chapter 4/5 respectively (Category A's regret paragraph; Category
H's work). Appendix E is pure derivation, not a data result. No action.

### A note on scope discipline

Not all of the above should necessarily go in — this is the raw candidate list, not a
plan. Given Mak's explicit framing ("a short paragraph... not a single expanded
section," already the agreed Category I approach), the realistic ceiling is probably the
five Top Picks plus maybe two or three of the MED items, not the full list. Worth
deciding the actual cut with fresh eyes next session rather than in the same pass that
generated the list.
