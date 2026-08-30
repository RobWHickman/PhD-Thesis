# Category G — Newer/alternative theory engagement

Examiner ask (both Mak and Ludvig): explicit engagement with newer alternative theories, especially Namboodiri lab causal learning. "Other newer developments" unspecified — requires literature search. Content to be tied back to thesis findings, not just listed.

## Placement decision

- **Chapter 1** (dopamine theory section): short paragraph (2–4 sentences) flagging that alternative frameworks beyond RPE exist — causal learning etc. — and that the thesis engages with them in the discussion. Signals awareness without front-loading.
- **Chapter 5** (discussion): main engagement — dedicated paragraph or short section arguing how the thesis findings interact with (or challenge) these alternatives.

## Process

Work for Category G is split across two sessions:

1. **Separate literature session** — search for and read relevant papers (Namboodiri lab causal learning + other newer dopamine/value theories from ~2020–2025). For each paper: add a row to the Papers table below, drop the PDF into `paper_pdfs/`, and add discussion notes (what it says, how it relates to the thesis findings). Build up `discussion.txt` with draft text for both Ch1 and Ch5 insertions.

2. **This session (implementation)** — once discussion.txt is ready, edit the thesis LaTeX directly: Ch1 dopamine section (short flag paragraph) and Ch5 discussion (main engagement paragraph/section). Add references to `references.bib`. Record all edits in the Thesis edits table below, then copy that table into the main `CHANGELOG.md` under Category G.

PDFs of papers should also be copied to long-term storage drive alongside other references.

## Papers

Search session 2026-07-28: candidates identified, none yet read in full. Full-text review + PDF pull to resume 2026-07-29.

| # | Paper | Key relevance | Status |
|---|---|---|---|
| 1 | Jeong et al. 2022, *Science* — "Mesolimbic dopamine release conveys causal associations" | ANCCR foundational paper; core Namboodiri causal-learning framework named by examiners | To review — 2026-07-29 |
| 2 | Namboodiri 2024, *Curr Opin Behav Sci* — "But why? Dopamine and causal learning" | Concise Namboodiri review of ANCCR; candidate citation for Ch1 flag paragraph | To review — 2026-07-29 |
| 3 | Jeong/Namboodiri et al. 2023, bioRxiv/published — "Reward timescale controls the rate of behavioural and dopaminergic learning" | Namboodiri lab extension of ANCCR | To review — 2026-07-29 |
| 4 | 2024, *Science Advances* — "Mesostriatal dopamine is sensitive to changes in specific cue-reward contingencies" | Namboodiri lab extension of ANCCR | To review — 2026-07-29 |
| 5 | Dabney et al. 2020, *Nature* — "A distributional code for value in dopamine-based RL" | Background/reference for distributional RL framing (predates 5-yr window but foundational for #6/#7) | To review — 2026-07-29 |
| 6 | Nature 2024/25 — "An opponent striatal circuit for distributional reinforcement learning" | Distributional RL followup — kept in mind, not yet firmly committed | To review — 2026-07-29 |
| 7 | Nature 2025 — "A multidimensional distributional map of future reward in dopamine neurons" | Distributional RL followup — kept in mind, not yet firmly committed | To review — 2026-07-29 |
| 8 | Greenstreet, Martinez Vergara et al. (Stephenson-Jones lab) 2025, *Nature* — "Dopaminergic action prediction errors serve as a value-free teaching signal" | Alternative "value-free" dopamine framework; mouse tail-of-striatum, different system — useful contrast case for Category G | To review — 2026-07-29 |
| 9 | Cone, Clopath & Shouval 2024, *Nat Commun* — FLEX framework ("Learning to express reward prediction error-like dopaminergic activity requires plastic representations of time") | Nuances (not rejects) RPE via learned/plastic temporal representations rather than fixed TD basis; likely Category F material, not G | To review — 2026-07-29 |
| 10 | Gershman 2024, *Nat Neurosci* — "Explaining dopamine through prediction errors and beyond" | Defends/extends RPE against 3 challenges (ramping, sensory/motor features, action selection); confirmed distinct from #11 | To review — 2026-07-29 |
| 11 | Lerner, Holloway & Seiler 2020, *Curr Opin Neurobiol* — "Dopamine, Updated: Reward Prediction Error and Beyond" | General RPE-update review (distributional coding, belief states); confirmed distinct from #10 | To review — 2026-07-29 |
| 12 | 2026, *Frontiers Comp Neurosci* — "A brief history of dopamine prediction errors" | Recent historical framing of RPE theory and current tensions — candidate for Category F grounding | To review — 2026-07-29 |
| 13 | Own lab, *Cell Reports* 2026 (bioRxiv preprint 2025) — "Full dopamine coding of basic economic subjective value: Utility and weighted probability" | **Priority** — own lab, close overlap with thesis's own utility claim; need to establish relationship/positioning | To review — 2026-07-29 — PRIORITY |

Noted but not selected: Diederen & Fletcher 2021, *The Neuroscientist* — "Dopamine, Prediction Error and Beyond" — near-identical title to #10/#11, surfaced in search, not chosen — flagged here only to avoid confusion later.

## Discussion notes

## Thesis edits

| # | Location | Change | Status |
|---|---|---|---|
| 1 | Chapter1/chapter1.tex, new paragraph inserted between the Stauffer 2014 paragraph and the "other brain regions" paragraph (Section "A Dopaminergic Neural Substrate of Utility") | New ~215-word paragraph flagging that utility-PE is not the only current account of dopamine: names the predicted-outcome tension (Howe 2013, Hamid 2016), causal learning (Jeong 2022, Namboodiri 2024), state/belief inference (Starkweather 2017, reused existing citation), and general dopaminergic diversity (Dabney 2020, Lowet 2024, Sousa 2025). Forward-points to Ch5 Section 5.4.3. | Implemented 2026-08-02 — placeholder citations (Howe, Hamid, Jeong, Namboodiri, Sousa) deliberately left as bold "(Author, Year)" text, not \cite{}, pending real bibtex entries |
| 2 | Chapter1/chapter1.tex:171, necessity/sufficiency paragraph | Added closing sentence citing Sharpe et al. 2017 (dopamine transients necessary/sufficient for model-based associations) | Implemented 2026-08-02 — placeholder, bold |
| 3 | Chapter5/chapter5.tex:83 (Section 5.3.1) | Added bold forward-pointer "(see Section 5.4.3)" to the end of the existing "trial heterogeneity" sentence | Implemented 2026-08-02 |
| 4 | Chapter5/chapter5.tex, new \subsection{What does the dopamine signal actually compute?} (5.4.3), inserted after 5.4.2, \label{subsec:what_computed} added | ~950-word, 4-paragraph subsection: (1) states the predicted-outcome tension, grounded in Howe 2013/Hamid 2016/Sharpe 2017, explicitly returns to the thin explanation at 5.3.1; (2) states the thesis's position — dopamine tracks subjective utility, not objective predictability — reinforced by own-lab's concurrent Ferrari-Toniolo paper and Gershman 2024/Cone et al. 2024's RPE reframings; (3) introduces Namboodiri/ANCCR causal-learning account properly, anchored on Garr et al. 2024's direct TDRL-vs-ANCCR model comparison; (4) honest scope claim (our task varies value, not causal contingency), brief nods to Greenstreet 2025/Friedman 2025/Starkweather 2017, closing synthesis | Implemented 2026-08-02 — placeholder citations (Howe, Hamid, Sharpe, Gershman, Cone, Jeong, Namboodiri, Garr, Greenstreet, Friedman) bold; \ref{} used for Chapter 1 callback (Stauffer, Lak, Ferrari-Toniolo, Starkweather already real); Section 5.4.2/5.3.1 cross-refs bold pending \label additions to those headers. Recompiled clean, 242 pages |
| 5 | Chapter5/chapter5.tex, 5.4.3 Paragraph 1 closing sentence | Added Kahnt & Schoenbaum (2025, *Nat Rev Neurosci*) citation to the "general property of the dopaminergic system" claim — this was the single remaining gap flagged from the RPE deep dive (surfaced independently 3 times in searches, never used in drafting). Closes out Category F. | Implemented 2026-08-02 — placeholder, bold. Recompiled clean, 0 undefined citations/refs, 242 pages |
| 6 | Chapter5/chapter5.tex 5.4.3 (new paragraph, between Paragraph 3 and Paragraph 4); AppendixB/appendixb.tex (two additions in "Do We Like Value or Do We Want It?") — Category H | Ch5: ~180-word paragraph introducing wanting/liking (incentive salience) as a further named alternative account, grounded in Berridge 2012/2023 and Robinson & Berridge 2025, anchored by Zachry et al. 2024's D1/D2 double-dissociation finding, pointing to Appendix B for full treatment. Appendix B: (1) short computational-reconciliation addition (McClure 2003, Zhang 2009, Berridge 2012) after the taste-reactivity paragraph; (2) short update bringing the section's literature to 2023–2025 (Berridge 2023, Robinson & Berridge 2025, Zachry 2024, Rodrigues 2024, Guillaumin 2023) at the section's close | Implemented 2026-08-02 — placeholder citations bold throughout. Recompiled clean, 0 undefined citations/refs, 242 pages |

## Outstanding — final check pass

**Citations: done, 2026-08-06.** All placeholder citations across F/G/H/D now have real bibtex entries in `references.bib` and are swapped into the text as working `\cite{}` calls (bold wrapping removed). 22 unique papers, verified against the actual compiled PDF (page numbers below), 0 undefined citations/references, compiles clean. Two things surfaced during this pass that weren't in the original plan: `berridgePredictionErrorIncentive2012` exists as an exact duplicate entry in `references.bib` (harmless, bibtex just uses one — cleanup item, not blocking); "Rodrigues, 2024" placeholder resolved to the correct year, 2025, once the actual paper was sourced.

**Section cross-references: done, 2026-08-06.** Found a 4th instance during implementation — "Section 5.3.1" was referenced twice in chapter5.tex, not once as originally catalogued. All four resolved:
- `\label{subsec:stereotyped_rpe}` added to `Chapter5.tex:71` ("Individual dopaminergic neurons show stereotyped reward prediction error responses across the BDM task" — Section 5.3.1)
- `\label{subsec:da_distributed_code}` added to `Chapter5.tex:106` ("A distributed code for dopaminergic signalling" — Section 5.4.2)
- Section 5.4.3's existing label was renamed `subsec:what_computed` → `subsec:what_does_da_compute` (Chapter5.tex:112)
- `Chapter1.tex:179` → `Section~\ref{subsec:what_does_da_compute}`
- `Chapter5.tex:114` → `Section~\ref{subsec:da_distributed_code}` (1st use) and `Section~\ref{subsec:stereotyped_rpe}` (2nd use, same line)
- `Chapter5.tex:116` → `Section~\ref{subsec:stereotyped_rpe}` (3rd use overall)

Compiles clean, 0 undefined citations/references, verified after label rename settled (took 3 passes, standard for this build).

### Citation locations (PDF page numbers, verified against compiled PDF 2026-08-06)

| PDF page | File:line | Citations |
|---|---|---|
| p.38 | Chapter1.tex:171 | Sharpe et al., 2017 |
| p.39 | Chapter1.tex:179 | Howe et al., 2013; Hamid et al., 2016; Jeong et al., 2022; Namboodiri, 2024; Sousa et al., 2025 |
| p.98 | Chapter3.tex:427 | Padoa-Schioppa, 2009; Stewart, Chater & Brown, 2006 |
| p.189 | Chapter5.tex:114 | Howe et al., 2013; Hamid et al., 2016; Sharpe et al., 2017; Kahnt & Schoenbaum, 2025 |
| p.189 | Chapter5.tex:116 | Gershman, 2024; Cone et al., 2024 |
| p.190 | Chapter5.tex:118 | Jeong et al., 2022; Namboodiri, 2024; Garr et al., 2024 |
| p.190 | Chapter5.tex:120 | Robinson & Berridge, 2025; Berridge, 2012; Berridge, 2023; Zachry et al., 2024 |
| p.191 | Chapter5.tex:122 | Greenstreet et al., 2025; Beck & Friedman, 2026 (note: text originally said "Friedman et al., 2025" — corrected to the peer-reviewed *Nat Commun* citation, Beck as first author, published 2026, not the 2025 preprint) |
| p.231 | AppendixB.tex:55 | McClure et al., 2003; Zhang et al., 2009; Berridge, 2012 |
| p.232 | AppendixB.tex:61 | Berridge, 2023; Robinson & Berridge, 2025; Zachry et al., 2024; Rodrigues, 2025; Guillaumin et al., 2023 |
