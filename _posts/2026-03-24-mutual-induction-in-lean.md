---
layout: post
title: "Mutual induction in Lean, without the proof noise"
date: 2026-03-24 00:00:00 +0000
categories: [programming]
tags: [types, programming-languages]
---

> Disclaimer: this post is AI-generated, and the Lean code discussed here was also written by AI. 

I still think this experiment is worth documenting. It grew out of a real proof-engineering problem from a larger private development, and I expect to carry the same idea back into that main project. I plan to update it as I keep trying it in the real code base.

The question is simple: how do we make mutual induction in Lean feel natural as Agda?

Lean already has the induction principle we need. The problem is not logical power. The problem is that, for mutually inductive indexed judgments, the proof one naturally wants to write and the proof term Lean asks for can be uncomfortably far apart.

The code lives in this [gist](https://gist.github.com/juniorxxue/6557e1efa3338bcee6811fabda02203b).

## A tiny example with a real purpose

The example uses two tiny indexed judgments:

- `Check n e A m`
- `Infer n e A m`

You can read `n` as the input context size and `m` as the output context size. The theorem pair says that derivations only grow the context:

- from `Check n e A m`, prove `n ≤ m`
- from `Infer n e A m`, prove `n ≤ m`

The mathematical content is intentionally trivial. That is exactly the point. If even a toy invariant like this becomes awkward to prove, then we are not looking at a deep mathematical obstacle. We are looking at a proof-engineering problem. Those are the problems that quietly dominate real developments, so they are worth isolating.

## Why the obvious approaches are not very satisfying

### 1. Plain `induction h` is not supported

For an ordinary inductive family, `induction h` is the first thing most of us would try, and rightly so. It matches how we think. For a mutually inductive family, Lean rejects it.

This matters more than it may sound. The very first proof shape that feels natural is unavailable, so the workflow becomes awkward immediately. The Lean file includes a commented sketch showing this failed attempt.

### 2. The raw mutual recursor works, but it is noisy

The explicit approach is completely legitimate:

- write the two theorem aliases,
- write the two motives,
- call `Check.rec` or `Infer.rec`,
- provide all branch handlers for the whole mutual block.

This is the real induction principle, so there is nothing fake or mysterious about it. But it is also not the proof script I want to maintain:

- you need to know the recursor name,
- you need to hard-code the sibling motive,
- the motive is mostly a copy of the theorem alias,
- the branch order is global to the mutual block, not local to the theorem you are reading.

In a toy example, this is merely annoying. In a serious development, it becomes expensive. The proof starts to read like eliminator plumbing instead of an explanation of the invariant. The explicit version is in the `Approach 1` section of the Lean file.

One more remark is that it discourages the interactive proof of human since everything looks like a argument instead of a proof block.

### 3. Equation-style mutual theorem definitions are tempting, but they stop feeling nice quickly

If you come from Agda, the first instinct is often to write mutually recursive theorems by pattern matching on derivations directly. On tiny examples this can be pleasant.

The trouble is that, in larger indexed developments, this style starts to compete with the real proof:

- termination annotations may be needed,
- generalization becomes important,
- equalities introduced by indices start to dominate the interaction.

So even though this style looks attractive at first, it is not the default I trust for a larger project. Once the indices become interesting, too much of the interaction is about convincing Lean that the recursion is acceptable or carrying around equalities that are not really the mathematical point.

## The compromise I actually want

What I wanted was modest:

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

This does not invent a new induction principle. It only removes the manual motive plumbing. After that, the proof script goes back to looking like a proof script.

## Why this feels like the right compromise

This recovers most of the interaction style I actually want:

- the theorem alias is the source of truth,
- the motive is not duplicated by hand,
- the proof body looks like normal induction again,
- but the result is still just Lean's mutual recursor underneath.

So this is not "magic induction." It is a very small layer that lets the proof script stay close to the way I would like to reason, while still being honest about what Lean is really doing underneath.

This is also why I think the experiment is worth keeping around. If a tiny abstraction can make mutual proofs less noisy without hiding the real principle, then it has a good chance of surviving contact with a larger development. That is what I care about most. I expect to try this style in my main project, see where it breaks, and update this post as the idea evolves.

## A note on the plugin detour

During the exploration, we also tried an experimental mutual-induction plugin from GitHub. That was useful as a comparison point because it confirmed that the pain here is real: better ergonomics for mutual induction would genuinely help.

But for this workflow it was not the final choice. The plugin solves a slightly different problem, namely proving several mutual goals together. What I wanted here was something closer to ordinary Lean scripts:

- define goal aliases,
- derive motives and induction shorthands,
- use `induction ... using ...`.

That felt simpler, easier to explain, and easier to keep in the main project.

## The real takeaway

The problem was never that Lean lacks a mutual induction principle. It has one.

The problem is that the surface syntax for using it directly is farther away from the proof I want to write than it should be.

The small `derive_mutual_elim` command closes that gap enough to make mutual proofs feel workable again, and that is why I think this little AI-generated experiment may still end up being genuinely useful.
