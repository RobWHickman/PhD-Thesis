# PhD Thesis Corrections — Context & Plan

**Candidate:** Robert William Hickman
**Thesis:** *A Measurement of Neuronal Encoding of Subjective Value on a Moment by Moment Basis: The encoding of value by midbrain dopamine neurons in an auction-like task*
**Institution:** University of Cambridge, Faculty of Biology, Darwin College
**Outcome:** Conditionally approved for the PhD, subject to **minor corrections (3 months)**. Examiner responsible for confirming corrections: Internal (Prof. Vincent Mak).
**Viva date:** 22 April 2026. **Degree Committee decision:** 11 May 2026.

## Agent Behaviour

- Only ever do one thing at a time. dont go beyond what is asked. at most flag there might be more to something and ask if I want to expand.
- Dont make changes automatically. Always ask for my permission.

## Where to find the source documents

The two original source documents referenced throughout this file are at the top level of this repo, alongside this CLAUDE.md:

- `Corrections_Map_doctoral.pdf` — Cambridge's general corrections process guide (administrative steps, deadlines, submission logistics).
- `1__Hickman__Robert.pdf` — the actual examination paperwork: Degree Committee decision form, both PhD1 independent examiner reports (Mak, Ludvig), the PhD2 joint report, and the handwritten viva notes. This is the primary source for everything in the "Correction categories" section below.

Any session needing to verify exact wording, page numbers, or quotes from the examiners should read these directly rather than relying solely on the categorisation below.

## Page number conventions

**IMPORTANT:** Page numbers in the examiner reports refer to the **actual PDF page numbers** (e.g., "page 28 of 238" as shown in a PDF viewer), NOT the printed page numbers that appear on the pages themselves. 

For example: what the examiners call "p.28" is the 28th page of the compiled PDF file (thesis.pdf), which displays "4" as its printed page number at the top (since frontmatter uses roman numerals and doesn't count toward the arabic numbering).

When searching for a correction listed as "p.X", count X pages into the PDF from the beginning, regardless of what number is printed on that page. This matters especially for early chapters where the discrepancy is largest.

## Where to find analysis code and scripts

The LaTeX source for this thesis lives in this repo (`~/Documents/PhD_Thesis`). The data analysis and figure-generation code is **not** inside this repo — it's a sibling directory:

```
~/Documents/thesis_scripts
```

Categories that need new analysis, data verification, or figure regeneration (e.g. the mixed-effects model, the Bayesian null test, the Table 4.3 and Fig 4.27/4.28 checks, any figure regeneration categories) will need this path pointed out explicitly at the start of that session — a Claude Code session opened at the repo root won't see it automatically, since it's outside the project directory.

Categories that are pure prose/LaTeX edits (typos, wording, theory write-up, structural fixes) shouldn't need this at all.

## How this document should be used

This file exists to give any Claude Code session — opened fresh, with no memory of other sessions — enough context to work on this thesis's corrections without re-deriving it from scratch each time.

**This file is informational only.** It does not contain instructions to make any edits. Each correction category below will be tackled in its own separate Claude Code chat, with its own specific brief. A session reading this file should treat it as background/orientation, not as a task list to act on unprompted.

The original examiner reports and Degree Committee paperwork are the source of truth for what was requested. This file is Robert's own synthesis/categorisation of that feedback, done in conversation with Claude (chat UI), to make the corrections tractable as a sequence of small, single-purpose passes rather than one overwhelming edit. Categories are deliberately split fine — prefer more, narrower chats over fewer, broader ones.

## A note on pushback and domain authority

Constructive pushback is welcome and expected during these corrections — if an examiner's suggestion seems statistically questionable, under-specified, or could be implemented multiple ways, say so and explain the tradeoffs before just implementing something.

That said, Robert has a PhD in this field and years of hands-on experience with this exact dataset, analysis pipeline, and the conventions of the relevant literature (electrophysiology, behavioural economics, primate research norms around sample size, etc.). There will be points where he's made a judgment call knowing things a general-purpose review can't fully capture — field conventions, what reviewers will and won't accept, why a standard-looking choice (e.g. small-n designs, particular statistical defaults) is actually well-justified in this area. If Robert says something like "this is how the field works" or otherwise makes clear he's settled on an approach, that should be treated as a final decision, not a cue to keep relitigating it. Push back once, clearly, then defer to his judgment and move on to implementation.

---

## Examiners' feedback — general overview

Two independent examiner reports (Internal: Prof. Vincent Mak, Judge Business School; External: Prof. Elliot Ludvig, University of Warwick) plus a brief handwritten joint report. Both examiners were positive overall — language like "compelling," "ingenious design," "diligent and comprehensive," "merits publication" — and both independently arrived at the same recommendation (minor corrections, 3 months). Their substantive concerns overlap heavily, which is reassuring: it means there isn't a conflicting set of asks to reconcile, just one shared set of priorities raised twice.

The feedback splits broadly into:
1. **Statistical/analytical additions** — new analyses, not just rewording (mixed-effects model, Bayesian null test, binning justification).
2. **Theoretical engagement** — discussion of how findings relate to existing theory (RPE/RL, causal learning, relative valuation) — the "lit review" item, but more "integrate with theory" than "survey the last 5 years."
3. **Specific figure/data discrepancies** — places where text and figures seem to disagree, or where a figure/table needs verifying against the data.
4. **Minor textual fixes** — typos, missing brackets, mislabelled axes, caption errors. Largest in volume, smallest in difficulty per item.
5. **Structural/presentational suggestions** — converting bullet lists to prose, moving appendix content into the main text, notation consistency.
6. **Administrative/disclosure additions** — data/code availability statement, ethics statement, within-week behavioural cycle question.

Both examiners are also clear that this is in the spirit of incremental improvement, not a fundamental challenge to the thesis's conclusions — useful framing for triage; nothing here should require redoing core results.

---

## Correction categories (to be tackled one per chat)

Each category below is scoped to be a single focused chat. Where an item touches both data/analysis and write-up, that's noted, but the split itself is kept narrow on purpose.

### Category A — Mixed-effects model for the central bid–dopamine claim
**What's needed:** Re-analyse the thesis's most central result (dopamine response correlates with bid) using a mixed-effects model, to account for hierarchical structure in the data (monkey / neuron / trial). Both examiners raised this independently and explicitly — the single most repeated substantive request.
**Rough complexity:** High. Genuine new statistical analysis, not prose editing — needs the original data/code, a decision on random-effects structure, and the figure/text/numbers updated to match. Likely the single most time-consuming category.
**Where the difficulty lives:** Access to and familiarity with the original analysis pipeline/data; defensible random-effects structure with only n=2 monkeys; possibly re-running downstream figures (4.11, 4.13B, 4.17) that depend on this result.

### Category B — Bid-binning justification
**What's needed:** p.139 — bids were binned for the primary analysis rather than used as a continuous predictor; examiner asks for justification, or for the analysis to use raw bids directly.
**Rough complexity:** Medium. Likely resolved as a side-effect of Category A's re-analysis (if bids end up modelled continuously there), but kept as its own category since it could equally be addressed by writing a justification alone, without new analysis.
**Where the difficulty lives:** Deciding whether this is a "redo with continuous predictor" task or a "write a justification" task — worth resolving that question first, ideally with knowledge of how Category A turned out.

### Category C — Bayesian null test (utility vs. magnitude dissociation)
**What's needed:** Chapter 4's claim of no difference in neuronal responding across magnitude when bids are matched is currently argued from a non-significant frequentist test. Needs a Bayesian test (e.g. Bayes factor) to properly quantify evidence *for* the null.
**Rough complexity:** Medium. Statistically self-contained (doesn't depend on Category A), but needs the underlying data and a justified choice of Bayesian test/prior.
**Where the difficulty lives:** Choosing and justifying a sensible Bayesian approach; standard in principle, needs care in framing for the write-up.

### Category D — Single-fractal effect: behavioural write-up
**What's needed:** Both examiners flagged that the single- vs multi-fractal session effect (d ≈ 0.46) is downplayed relative to its actual size. Revise the discussion of the *behavioural* effect to take it more seriously, situating it in relative-valuation theory from the behavioural economics literature.
**Rough complexity:** Medium. Primarily a writing/theory task, not new analysis.
**Where the difficulty lives:** Needs at least a little literature grounding in relative valuation theory — light touch compared to Category K, but not zero.

### Category E — Single-fractal effect: dopamine re-analysis
**What's needed:** Examine whether the corresponding **dopamine** signal shows the same single- vs multi-fractal effect seen behaviourally — described by examiners as potentially "extremely strong evidence" for the dopamine-as-utility (not reward) thesis if it holds up.
**Rough complexity:** Medium–High, complexity depends on whether this is a quick re-slice of existing dopamine analysis or requires new processing.
**Where the difficulty lives:** Scope is the open question — worth scoping early in this chat. The "extremely strong evidence" framing means it's worth getting right rather than rushing, even though it's not explicitly a stats-heavy task like A or C.

### Category F — RPE/RL theoretical engagement
**What's needed:** Deeper engagement with reward prediction error / reinforcement learning theory and how (or whether) the thesis's results sit comfortably with it — examiners note the strong dopamine responses to *predicted* outcomes are potentially challenging for standard RPE accounts and should be discussed as such, not glossed over. Concentrated mainly in Chapters 1 and 5.
**Rough complexity:** High. Needs critical engagement with existing theory, not just a survey — examiners are pointing at a specific tension in the data that needs addressing head-on.
**Where the difficulty lives:** This is the part most likely to need real intellectual effort rather than just literature gathering — it's an argument to construct, not just a section to fill in.
**Status note (2026-08-02):** Done, jointly with Category G in the same paragraphs (see `extra_lit/` for full process) — new Chapter 1 paragraph plus Chapter 5 Section 5.4.3 Paragraphs 1–2 address the predicted-outcome tension directly, tied to the thesis's own 5.3.1 result, closed out with a Kahnt & Schoenbaum (2025, *Nat Rev Neurosci*) citation. Copied into main `CHANGELOG.md`.

### Category G — Newer/alternative theory engagement (causal learning etc.)
**What's needed:** Explicit engagement with newer alternative theories that could explain the findings — examiners specifically name the Namboodiri lab's causal-learning work — plus other relevant developments from roughly the last 5 years. This is the closest of all categories to a traditional "lit review" addition.
**Rough complexity:** High. Needs real literature search against current work, not recall from memory — citation accuracy matters here.
**Where the difficulty lives:** Judgment on how much new literature to bring in and how directly to tie each piece back to the thesis's own results, rather than listing related work without engagement.
**Status note (2026-08-02):** Done, jointly with Category F in the same paragraphs (see `extra_lit/CHANGELOG.md` for full process). Causal learning (ANCCR) engaged properly — Jeong et al. 2022 and Namboodiri 2024 in Chapter 1, Garr et al. 2024 as the strongest empirical citation in Chapter 5 Section 5.4.3 Paragraph 3. Copied into main `CHANGELOG.md`.

### Category H — Promote appendix theory content into main chapters
**What's needed:** Some of the more interesting theory-relevant material is currently relegated to the appendices; examiners want it surfaced into the main chapters (likely 1 and/or 5) where the theoretical discussion is happening.
**Rough complexity:** Medium. More restructuring than new writing, but needs to be integrated smoothly rather than just relocated.
**Where the difficulty lives:** Deciding what counts as "the interesting bits" worth promoting, and making the surrounding prose still flow once they're moved.
**Status note (2026-08-02):** Done. Short pointer paragraph added to Chapter 5 Section 5.4.3 (between the ANCCR paragraph and the closing paragraph), plus two small updates to Appendix B itself bringing its wanting/liking discussion up to date with 2023–2025 literature and bridging it to the prediction-error framing used elsewhere. Copied into main `CHANGELOG.md`. Full process in `extra_lit/h.txt`.

### Category I — Expand Section 5.4 discussion
**What's needed:** The core dopamine-bid discussion is currently concentrated on one page in Section 5.4; examiners want this expanded, and note the rest of Section 5 already contains "good insights" worth building on.
**Rough complexity:** Medium. Largely a writing/expansion task building on existing material rather than new research.
**Where the difficulty lives:** Likely to overlap with Categories F/G/H in practice (the expanded discussion will probably need to reference the same theory) — worth doing after those, or at least being aware of what they produced.
**Status note (2026-08-02):** Scoped, not yet drafted. Verbatim examiner text (Mak only, not corroborated by Ludvig) is narrower than the summary above: not primarily a theory-engagement ask, but "what's actually novel here beyond well-established dopamine findings," with three specific pointers — the Section 5.4 discussion itself, p.86 (BDM vs. binary-choice utility discrepancy vs. Al-Mohammad & Schultz 2022), and p.145/p.155 (places where a surprising result gets only a one-line explanation). Approach decided: a short paragraph of extra interpretation per flagged result, not a single expanded section.

### Category J — Ch1 p.30: EUT overstatement
**What's needed:** Bottom of p.30 overstates the role of Expected Utility Theory in modern decision-making research; behavioural economics has largely moved to Cumulative Prospect Theory and beyond, and rarely starts from EUT in judgment-and-decision-making work today.
**Rough complexity:** Low. A contained factual/framing correction to a paragraph, not a new section.
**Where the difficulty lives:** Minimal — mostly just rewriting the offending paragraph accurately.

### Category K — Ch1 p.32: Rescorla-Wagner mischaracterisation
**What's needed:** The thesis currently describes Rescorla-Wagner as having cause-effect structure; examiner notes it's actually associative (not strictly predictive) and trial-level only. Needs correcting.
**Rough complexity:** Low. Contained, single-paragraph fix.
**Where the difficulty lives:** Minimal — needs an accurate, precise restatement of what R-W actually is and isn't.

### Category L — Table 4.3 data error
**What's needed:** Table 4.3 appears to report the same data on three different rows. Needs verifying against source data and correcting.
**Rough complexity:** Low–Medium. Small in scope but requires checking against the actual data before editing, not just a text fix.
**Where the difficulty lives:** Needs the underlying numbers to confirm what should actually be in each row.

### Category M — Fig 4.27/4.28 text-figure mismatch
**What's needed:** Fig 4.27A appears to show medium above high, with all conditions trending up, yet the text (p.163) states only medium and high increase. Same issue in Fig 4.27B, and again in Fig 4.28 (Monkey U shows medium above high, not significant, not aligned with the figure). Needs confirming what the data actually show, then correcting text and/or figure and/or caption to match, with brief additional explanation if the surprising pattern is confirmed as real.
**Rough complexity:** Medium. Self-contained but needs real data verification — three related figures, possibly one root cause.
**Where the difficulty lives:** Determining whether this is a plotting error, a writing error, or a genuine unexplained data pattern — these have different fixes.

### Category N — Fig 4.5 neuron inclusion clarification
**What's needed:** Unclear what happened to some putative dopamine neurons between the upper and lower plots of Fig 4.5 — were they excluded for not being dopaminergic, for not responding to unpredicted rewards, or due to an inclusion threshold (e.g. minimum number of test repetitions)? Needs clarifying in the text/caption.
**Rough complexity:** Low–Medium. Likely just needs the inclusion-criteria logic restated clearly, but requires checking against the actual filtering applied.
**Where the difficulty lives:** Reconstructing exactly what filtering logic was applied if it isn't immediately obvious from existing code/notes.

### Category O — Fig 3.4 end-of-session criterion
**What's needed:** What determined the end of a session isn't currently stated; needs adding.
**Rough complexity:** Low. Should be a short factual addition once the criterion is confirmed.
**Where the difficulty lives:** Minimal, assuming the criterion is known/documented somewhere.

### Category P — Starting bid / total liquid: opposite effects across monkeys
**What's needed:** Chapter 3 reports seemingly opposite effects of starting bid and total liquid consumed across the two monkeys, without much discussion of what this means for interpreting the results. Needs expanding.
**Rough complexity:** Medium. A genuine interpretive discussion to write, though no new analysis required if the underlying numbers are already in hand.
**Where the difficulty lives:** This needs actual interpretive judgment about individual differences between the two monkeys — not just description.

### Category Q — Table 3.10 / Figure 1.1 reference check
**What's needed:** p.112 — Table 3.10 may be referencing Figure 1.1 when it should reference a more recent figure from the bundle experiment. Needs checking and correcting the cross-reference if wrong.
**Rough complexity:** Low. Quick to check, quick to fix.
**Where the difficulty lives:** None expected — likely a simple `\ref` error.

### Category R — Tie-fighter plot clarity (p.111)
**What's needed:** Unclear what the "tie fighter" markers represent; the BDM-vs-choice comparison seems to be missing one series (a "blue tie fighter"); axis range may need expanding; caption is hard to parse regarding which measure (BDM or Choice) is being used as utility vs. as the comparison.
**Rough complexity:** Medium. Likely needs both a plotting fix (missing series, axis range) and a caption rewrite.
**Where the difficulty lives:** Needs the original plotting code to add the missing series — not a text-only fix.

### Category S — Fig 3.10 axis label legibility
**What's needed:** Axis labels are an unreadable stream of numbers; needs cleaner organisation given how much data is being shown.
**Rough complexity:** Medium. Plotting/formatting fix, not conceptual.
**Where the difficulty lives:** Needs the original plotting code/environment to regenerate the figure with reorganised labels.

### Category T — Fig 3.12 y-axis labels
**What's needed:** Top row of Fig 3.12 has y-axis labels missing or on the wrong side. Needs fixing.
**Rough complexity:** Low–Medium. Contained plotting fix.
**Where the difficulty lives:** Needs the original plotting code.

### Category U — Fig 4.4 caption and missing y-axis scales
**What's needed:** Caption currently has left/right (or blue/orange) described backwards; also, the figure has no y-axis scales shown despite the caption stating they differ. Needs caption correction and scales added.
**Rough complexity:** Low–Medium. The caption fix is text-only; adding axis scales needs the plotting code.
**Where the difficulty lives:** Two different fix types bundled in one figure — worth doing the caption fix immediately and treating the axis-scale addition as the harder sub-task.

### Category V — Fig 1.2 real vs simulated data demarcation
**What's needed:** Fig 1.2 mixes real data (panel a) with simulated data (panels b and c) without clear visual demarcation between them. Needs a visual distinction added (e.g. labelling, styling, or annotation).
**Rough complexity:** Low–Medium. Contained single-figure fix.
**Where the difficulty lives:** Needs the original plotting code.

### Category W — Minor textual corrections (typos, brackets, small wording fixes)
**What's needed:** The long list of small, mechanical fixes: missing/misplaced brackets (Eq 1.5, p.33, p.46, Singh ref p.68), wrong equation reference (p.28: should be Eq 1.2 not 1.3), spelling typos ("Exuded"→"excluded" p.73, "finial"→"final" p.80, "Spit"→"split" p.87, "Biding"→"bidding" p.157, "big"→"bid" p.163, "monkeys bids"→"monkeys' bids" p.62, "starting big"→"starting bid" p.157, "Wilcox.text"→"Wilcox.test" p.123), missing words ("of" p.99, "an" p.93/p.208/p.210), double semicolon (p.181), stray paragraph-only period (p.145), Mirenowicz and Schultz 1994 missing brackets (p.100), missing space ("one-sided and unless," p.123), missing Table reference (p.76, end of penultimate paragraph), missing Table 4.3 reference (p.145, 4th line from bottom), unclear sentence (p.164, "no tercile split" clause). Three additional items from the examiner report not in the original list: dashed lines used twice with different meanings in Fig 3.4 caption needing clarification (p.75), Footnote 5 in Chapter 3 has overprecise numbers (p.92, intercept values reported to 5 decimal places), and "trail" used instead of "trial" four times in Table 3.9 (p.108, Chapter3:583,584,590,591).
**Rough complexity:** Low per item, but high in volume. This is the original "spelling/grammar" pass — straightforward to batch, lowest risk category.
**Where the difficulty lives:** Almost none technically — main risk is making sure every one of the ~20+ scattered items is actually located and fixed. Good candidate for a structured proofreading checklist/skill.

### Category X — Effect size mischaracterisation (p.95)
**What's needed:** p.95 describes d = 0.47 as "small," but it's conventionally a medium effect size, and is treated as important in psychology. Needs correcting — kept separate from Category W since it's a substantive accuracy point (and connects conceptually to Category D's d ≈ 0.46 discussion) rather than a typo.
**Rough complexity:** Low. Single-location fix, but worth cross-checking against Category D's language for consistency once both are done.
**Where the difficulty lives:** Minimal alone — the only care needed is keeping language consistent with wherever else effect sizes are discussed.

### Category Y — Bullet points to prose (p.59, p.70)
**What's needed:** Two locations use long bullet-point lists where examiners want proper prose narrative instead.
**Rough complexity:** Low–Medium. Mechanically simple, just time-consuming to do well (bullets often hide implicit logical connectors that need to be made explicit in prose).
**Where the difficulty lives:** Making sure the rewritten prose doesn't lose information that was implicit in the bullet structure.

### Category Z — Prospect theory / loss aversion in intro (p.50)
**What's needed:** The introduction doesn't really discuss prospect theory or loss aversion; examiner suggests moving relevant content from an appendix into the intro.
**Rough complexity:** Medium. Likely a relocate-and-integrate task rather than fresh writing, but needs smooth integration into the intro's existing flow.
**Where the difficulty lives:** Same risk as Category H — deciding what to move and making it fit the surrounding prose.

### Category AA — Appendix E notation consistency (Budget vs Bmax)
**What's needed:** Appendix E starts with "Budget" then switches to "Bmax" without clear signposting. Pick one term and use it consistently throughout, ideally defining it once at the start.
**Rough complexity:** Low–Medium. Needs care to catch every instance, but each individual edit is trivial.
**Where the difficulty lives:** Just thoroughness — missing one instance leaves the inconsistency half-fixed.

### Category AB — Appendix E equation (E.7) repetition
**What's needed:** Equation (E.7) repeats the left-hand-side term too often across its multiple lines; needs tightening.
**Rough complexity:** Low. Contained equation formatting fix.
**Where the difficulty lives:** Minimal.

### Category AC — Formal presentation of payoff/cost functions (Appendix E)
**What's needed:** Examiner suggests explicitly and formally presenting the payoff and cost-of-misbehaviour functions for uniform, normal, and matched-normal bid distributions, ideally in an appendix; notes even the uniform case (simplest) could be more complete in the current Appendix E.
**Rough complexity:** Medium. Needs actual mathematical derivation/write-up, not just rewording.
**Where the difficulty lives:** This is real technical writing — needs the underlying derivations to be correct and clearly presented, not just expanded prose.

### Category AD — Softmax/logit choice rule mention (App A, p.209)
**What's needed:** The logit choice rule used is equivalent to softmax, which has long precedent in other fields; examiner suggests this is worth an explicit mention/citation.
**Rough complexity:** Low. A short addition with a citation or two.
**Where the difficulty lives:** Minimal — mostly just sourcing the right citation(s) for softmax's broader use.

---

## Suggested rough prioritisation

Not a strict order, but a sensible one given complexity and dependency. Grouped loosely by theme; within a theme, do the listed order.

**Quick wins first (low complexity, low risk, do anytime, ideally early):**
Category W (typos) → Category X (effect size) → Category J (EUT) → Category K (Rescorla-Wagner) → Category Q (Table 3.10 ref) → Category O (Fig 3.4 criterion) → Category AB (Eq E.7) → Category AD (softmax mention)

**Data/figure verification (needs source data, do before anything downstream cites these numbers):**
Category L (Table 4.3) → Category M (Fig 4.27/4.28) → Category N (Fig 4.5) → Category P (starting bid/liquid)

**Figure regeneration (needs plotting code/environment, can batch together):**
Category R (tie-fighter) → Category S (Fig 3.10 axes) → Category T (Fig 3.12 axes) → Category U (Fig 4.4) → Category V (Fig 1.2)

**Core statistical work (the biggest lift, do once you can focus, in this order due to dependencies):**
Category A (mixed-effects model) → Category B (bid-binning justification — depends on A's outcome) → Category C (Bayesian null test) → Category E (single-fractal dopamine re-analysis — may reuse A's pipeline)

**Theory/discussion (do after the stats above are finalised, so discussion reflects final numbers):**
Category D (single-fractal behavioural write-up) → Category F (RPE/RL engagement) → Category G (newer theory/lit review) → Category H (promote appendix theory) → Category I (expand 5.4)

**Structural/style (lowest stakes, do whenever there's spare time):**
Category Y (bullets to prose) → Category Z (prospect theory in intro) → Category AA (Budget/Bmax) → Category AC (formal payoff/cost functions)

---

## After all corrections are made

Once every category above has been addressed, the following remain before resubmission:

- **Internal consistency / final pass:** a holistic re-read once everything's in, since several categories touch overlapping material (e.g. Category D and Category X both discuss effect sizes; Category A's results feed into Categories F/G/I's discussion). Worth a dedicated session checking for new inconsistencies introduced by the correction process itself.
- **Von Neumann-Morgenstern axioms verification (Chapter 1):** ~~Check that the four axioms (completeness, transitivity, continuity, independence) match their canonical equations and descriptions as presented on Wikipedia — symbols should now be consistent throughout (using ≻ for strict preference, ≽ for weak preference, ~ for indifference).~~ **Done (2026-08-06)** — Robert checked manually; only fix needed was a footnote after the transitivity equation (Chapter1.tex:80) noting the stated relation holds more generally for weak preference ($X \succeq Y \text{ and } Y \succeq Z \Rightarrow X \succeq Z$), subsuming the strict/indifferent cases. Compiles clean.
- **Equation 6 LaTeX error (Appendices):** ~~Check for LaTeX error on B_subject notation.~~ **Done (2026-08-06).** Confirmed covered by the earlier "Robert Corrections" fix (AppendixE:51, `{B_subject}` → `B_{subject}`) — searched the whole thesis, zero remaining malformed instances anywhere.
- **Figure 4.17 title:** ~~Check for "n" error in figure title.~~ **Done (2026-08-06).**
- **Data and code availability statement:** Source text located (2026-08-05, via PMC open-access mirror of Hill et al. 2024, *Nat Commun*, PMC11408490) — both point to the same Figshare DOI (10.6084/m9.figshare.25734288): "All processed data generated in this study have been deposited in the Figshare database..." and "All code used for analyses in this study has been deposited in the Figshare database..." Should be a short, self-contained addition to the thesis (Methods or an appendix), adapting this text rather than reusing verbatim — could be its own small chat.
- **Ethics statement:** Source text located (2026-08-05, same source) — Methods → "Animal ethics, welfare, and surgical implantation": names the two monkeys, Home Office licence (Animals (Scientific Procedures) Act 1986), and the full chain of UK/UCam ethical oversight bodies (AWERB, NC3Rs, NVS, NACWO, etc.). Mak's report asks for this "in a form the student deems appropriate" — adapt, don't just paste verbatim. Another small, self-contained addition.
- **Robert's own action item (not a text-editing task):** put the thesis's own analysis scripts and data (the `thesis_scripts` repo referenced throughout this project, and/or the corrections-specific `.Rmd` files used this session) on GitHub or similar, separately from the Hill et al. (2024) Figshare deposit. **Then fix url in ethics statement** — Chapter3.tex's new `\subsection{Data and Code Availability}` (end of the Animals subsection) currently has a literal placeholder, `\textbf{[GITHUB URL PLACEHOLDER --- fix before submission]}`, in the sentence covering the corrections-specific scripts. Swap it for the real URL once the repo is up.
- **Optional/exploratory:** ~~Mak raises a speculative question about within-week behavioural cycles given the weekly fluid-restriction schedule (p.44) — framed as "I wonder if," not a required correction.~~ **Closed (2026-08-05), no action needed.** Chapter3.tex:122 already states recording was rarely attempted on Mondays "due to any lingering satiety from the unrestricted liquid access over the weekend" — the within-week cycle Mak is speculating about is already the stated reason for that design choice. No new stats or text needed. (Note: actual restriction schedule per Chapter3.tex:93 is Saturday evening–Friday afternoon restricted, i.e. free access is Friday afternoon–Saturday evening only, not Friday–Sunday — worth remembering if this ever needs re-examining.)
- **Build/compile check:** full recompile after all edits, checking cross-references, figure/table numbering hasn't shifted, and the bibliography still builds cleanly — especially important since the theory categories add new citations and several figure categories involve regeneration.
- **Final corrections letter:** Cambridge's process (per the Corrections Process guide) requires a separate list of corrections mapped to original and new page numbers, submitted alongside the corrected thesis to the Examiner(s), copying Student Registry and the Degree Committee. Worth maintaining a running log (e.g. `corrections_progress.md`, separate from this file) mapping each examiner comment to where/how it was addressed, rather than reconstructing this from memory at the end — the 3-month minor-corrections deadline doesn't leave much slack for this to become a scramble later.
- **Submission logistics reminder:** corrections are due within 3 months of the outcome communication; Internal Examiner (Mak) is the one who needs to confirm corrections are satisfactory before this moves to hardbound/electronic submission.
