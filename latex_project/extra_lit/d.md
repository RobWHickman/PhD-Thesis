CATEGORY D — SINGLE-FRACTAL EFFECT: BEHAVIOURAL WRITE-UP — DRAFT
==================================================================
STATUS: Draft only, nothing written into chapter3.tex yet.
Companion to Category E (Chapter4.tex, "Dopaminergic Responses in
Single-Fractal Sessions" subsection — done). Target: Chapter3/chapter3.tex,
`\subsection{Single Fractal Sessions}`, paragraph at line 421.

Citation key status (all placeholder — none of these are in references.bib
yet; bold "(Author, Year)" not \cite{}, same convention as the F/G/H work):
    padoaschioppaRangeAdaptingRepresentation2009  (Padoa-Schioppa, 2009)
    toblerAdaptiveCodingReward2005                (Tobler, Fiorillo & Schultz, 2005)
    stewartDecisionSampling2006                   (Stewart, Chater & Brown, 2006)
  These are the 3-star set from this session's search. 2-star/1-star papers
  (Rustichini et al. 2017, Louie & Glimcher work, partial-adaptation 2019
  paper, Cox & Kable 2014, Vlaev et al. 2007) were not needed to make the
  argument work and are left out of the draft — available if the paragraph
  needs more support later.

Blocker before this can be implemented: the Chapter 4 cross-reference target
(Chapter4.tex:288, `\subsubsection{Dopaminergic Responses in Single-Fractal
Sessions}`) has no `\label{}` yet. Marked as a bold placeholder below —
needs a label added to chapter4.tex first, then swapped for a real
`Section~\ref{}`.

==================================================================
WHERE IT FITS IN — replaces the existing sentence "These differences could
be due to task independence effects (e.g. without the framing of the lower
and higher value rewards offered, monkey's bids might change), but seems
likely to at least in part be a temporal effect." That sentence is the
downplaying examiners flagged — it gestures at framing/temporal effects
without seriously engaging either. Everything before and after it in the
existing paragraph is unchanged.
==================================================================

... [existing text, Chapter3/chapter3.tex, up to and including:] "Testing
using Cohen's d-statistic confirmed this, returning a 'medium' difference
(0.467) for Monkey V and a 'negligible' difference (0.077) for Monkey
U\footnote{See \cite{cohenStatisticalPowerAnalysis1992} for definition of
effect size terminology. Cohen treats the threshold to 'medium' as 0.5. We
treat 0.467 as rounding up to be conservative here.}." ...

These differences are naturally interpreted as a relative valuation effect:
in single-fractal sessions, the monkey never encounters the higher- or
lower-value fractals within that session, and the range of rewards actually
on offer is correspondingly compressed to a single point. A substantial
body of work in both primate neuroeconomics and behavioural economics
suggests that subjective valuation is not computed in absolute terms, but
is instead adapted to, or evaluated relative to, the distribution of values
recently or currently available: offer-value neurons in orbitofrontal
cortex adjust their tuning to the range of values on offer within a session
(\textbf{Padoa-Schioppa, 2009}), and choice behaviour more broadly has been
characterised as a comparison of an option's value against a sampled
distribution of recently-encountered alternatives, rather than retrieval of
a fixed underlying value (\textbf{Stewart, Chater \& Brown, 2006}). On this
account, removing the higher- and lower-value fractals from the session
does not simply remove a framing cue; it changes the distribution against
which the medium fractal's value is judged, and could genuinely shift the
bid the monkey considers appropriate for it.

This differs from a purely temporal explanation, which the data argue
against. Monkey U's bids for the medium fractal show no significant
discontinuity between the last month of three-fractal sessions and the
subsequent single-fractal sessions (Wilcoxon test, p = 0.716, Cohen's d =
0.024; Figure \ref{fig:single_fractal_bids}C), continuing smoothly from
where three-fractal sessions left off rather than drifting gradually over
time. That this stability holds for the monkey who shows no reward-context
effect (Monkey U), while the effect itself is substantial for the monkey
who does (Monkey V, d = 0.467), is more consistent with a session-level,
context-triggered shift in valuation than with slow temporal drift.

We do not take the absence of this effect in Monkey U as evidence against a
genuine relative valuation account. Individual differences of this kind
recur elsewhere in this thesis (Section \ref{sec:starting_bid_liquid} —
Category P cross-ref, confirm label), and range adaptation in primate value
coding is itself typically partial rather than complete, even in its
canonical demonstrations. Dopamine neurons have separately been shown to
adapt their own coding to the range of available reward values
(\textbf{Tobler, Fiorillo \& Schultz, 2005}); the corresponding dopamine
response to the medium fractal across single- and multi-fractal sessions is
examined directly in \textbf{Chapter 4 (Section TBD — Category E
cross-ref)}, where no context-dependent modulation was found for either
monkey. This asymmetry between a real behavioural context effect in one
monkey and the absence of a matching neural one in either monkey is
discussed further there.

... [existing text continues, unchanged:] "In Figure \ref{fig:single_fractal_bids}C)
the mean monkey bid for the middle reward level is plotted over time. ...
Differences computed by a Wilcoxon test were not significant (p = 0.716)
for mean medium fractal bids made by Monkey U and Cohen's d statistic was
again negligible (0.0237)." ...

==================================================================
NOTES FOR NEXT SESSION
==================================================================
1. Add `\label{}` to Chapter4.tex:288's subsubsection heading, then swap
   the bold Chapter 4 placeholder above for a real Section~\ref{}.
2. Confirm the actual \label for the Category P discussion (starting
   bid/liquid individual-differences paragraph, Chapter3:471) — used above
   as `sec:starting_bid_liquid`, a guess, not yet verified against the file.
3. The p=0.716 / d=0.024 numbers reused above for the temporal-stability
   argument are already in the existing paragraph (same sentence, just
   given new interpretive work) — no new stats needed.
4. Once implemented: add real bibtex entries for the 3-star set to
   references.bib, swap bold placeholders for \cite{}, recompile, check
   0 undefined citations/references — same closing pattern as F/G/H.
5. Category X (p.95 effect-size language) already lives in this exact
   paragraph (Chapter3:423) — double check the final merged paragraph
   still reads consistently with that fix once implemented.
