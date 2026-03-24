---
layout: post
title: "Mutual induction in Lean, without the proof noise"
date: 2026-03-24 00:00:00 +0000
categories: [programming]
tags: [types, programming-languages]
---

This post is a small, standalone writeup extracted from a larger private development.

The goal is not to teach a sophisticated type system. The goal is to make one specific proof-engineering issue easy to see:

- we have a mutually inductive, indexed definition,
- we want mutually proved invariants about it,
- the obvious Lean proof styles are either unsupported or much noisier than they feel in Agda,
- and we want a final style that is still honest about Lean's induction principle while being pleasant enough to use interactively.

The code lives in this [gist](https://gist.github.com/juniorxxue/6557e1efa3338bcee6811fabda02203b).

## What the file contains

The example uses two tiny indexed judgments:

- `Check n e A m`
- `Infer n e A m`

You can read `n` as the input context size and `m` as the output context size. The theorem pair says that derivations only grow the context:

- from `Check n e A m`, prove `n ≤ m`
- from `Infer n e A m`, prove `n ≤ m`

This is intentionally small. The mathematical content is trivial. The syntax and induction experience are the point.

## Why this is awkward in Lean

### 1. Plain `induction h` is not supported

For ordinary inductive families, `induction h` is the natural thing to write. For a mutually inductive family, Lean stops you. In practice, this is the first ergonomic wall: the proof one wants to write is not accepted.

The Lean file includes a commented sketch showing this failed attempt.

### 2. The raw mutual recursor works, but it is noisy

The explicit approach is mathematically fine:

- write the two theorem aliases,
- write the two motives,
- call `Check.rec` or `Infer.rec`,
- provide all branch handlers for the whole mutual block.

This is exactly the real induction principle, so there is nothing mysterious about it. But it is not a pleasant proof surface:

- you need to know the recursor name,
- you need to hard-code the sibling motive,
- the motive is mostly a copy of the theorem alias,
- the branch order is global to the mutual block, not local to the theorem you are reading.

In a small file, this is tolerable. In a real proof, it becomes a lot of syntax to carry around.

The explicit version is in the `Approach 1` section of the Lean file.

### 3. Equation-style mutual theorem definitions are tempting, but brittle

If you come from Agda, the first instinct is often to write mutually recursive theorems by pattern matching on derivations directly. On tiny examples this can be pleasant.

In larger indexed developments, though, this starts to compete with the real proof:

- termination annotations may be needed,
- generalization becomes important,
- equalities introduced by indices start to dominate the interaction.

So even though this style can be attractive, it was not the approach that scaled best for the underlying project that motivated this writeup.

## The final idea

The final idea is modest:

- keep using Lean's real mutual recursor,
- but derive the motive from the theorem alias automatically,
- and expose a short `Goal.induction` term that can be used with `induction ... using ...`.

In the file, that looks like this:

```lean
private abbrev CheckGrowsDerivedGoal : Prop :=
  ∀ {n m : Nat} {e : Tm} {A : Ty}, Check n e A m → n ≤ m

private abbrev InferGrowsDerivedGoal : Prop :=
  ∀ {n m : Nat} {e : Tm} {A : Ty}, Infer n e A m → n ≤ m

derive_mutual_elim
  CheckGrowsDerivedGoal for Check
  InferGrowsDerivedGoal for Infer
```

After that, the proofs use the much lighter shape:

```lean
induction h using CheckGrowsDerivedGoal.induction with
```

and

```lean
induction h using InferGrowsDerivedGoal.induction with
```

This does not change the induction principle. It only removes the manual motive plumbing.

## Why this felt like the right compromise

This recovered most of the interaction style we wanted:

- the theorem alias is the source of truth,
- the motive is not duplicated by hand,
- the proof body looks like normal induction again,
- but the result is still just Lean's mutual recursor underneath.

So it is not "magic induction". It is a small layer that lets the proof script look closer to how one would reason in Agda, while staying faithful to Lean's eliminator story.

## About the plugin side story

During the exploration, we also tried an experimental mutual-induction plugin from GitHub. It was useful as a comparison point: it confirmed that there is real value in better proof ergonomics for mutual induction.

But for this workflow it was not the final choice. The plugin solves a slightly different problem: proving several mutual goals together. The final approach in this writeup stays much closer to ordinary Lean proof scripts:

- define goal aliases,
- derive motives and induction shorthands,
- use `induction ... using ...`.

That felt simpler to keep in the main project.

## How to experiment

If you want to play with the file:

1. Copy [MutualInductionStory.lean](https://gist.github.com/juniorxxue/6557e1efa3338bcee6811fabda02203b) into any Lean 4 project.
2. Run Lean on it.
3. Read the `Approach 1` and `Approach 2` sections side by side.
4. Uncomment the plain `induction h` sketch to see the basic limitation directly.

## The punchline

The problem was never that Lean lacks a mutual induction principle. It has one.

The problem was that the surface syntax for using it directly is too far away from the proof one wants to write.

The small `derive_mutual_elim` command closes that gap enough to make mutual proofs feel workable again.
