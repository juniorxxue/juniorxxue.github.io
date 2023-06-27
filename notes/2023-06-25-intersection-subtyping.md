---
title: Intersection Subtyping and Counters
---

# Motivation

It all came from that we want to type check: the lambda abstraction annotated with intersection types can be applied to a integer.

```
T |-0 ((\x. x) : (Int -> Int) & (Bool -> Bool)) 1 : Int
```

With a few tries, we decided to delegate the counter solution to the subtyping, which appeared only in the subsumption rule

```
T |-0 e : A      A <:n B
-------------------------- Sub
T |-n e : B
```

# Problem

We're worried about a problem that

```
T |-0 (\x.x : (I -> I) & (S -> S)) : (I -> I) & (S -> S)        (I -> I) & (S -> S) <:1 (I -> I) & (S -> S)
------------------------------------------------------------------------------------------------------------ Sub
T |-1 (\x.x : (I -> I) & (S -> S)) : (I -> I) & (S -> S)
```

Counter is `1` simply means we have 1 argument information available. In the algorithmic system, it would be like

```
T |- Top => (\x. x) : (I -> I) & (S -> S) => (I -> I) & (S -> S)   (I -> I) & (S -> S) <: [1] -> Top ~~> I -> I
----------------------------------------------------------------------------------------------------------------- Sub
T |- [1] -> Top => ((\x. x) : (I -> I) & (S -> S)) => I -> I
```

The problem is that our algorithmic system derives a `I -> I` while the declarative one derives a `(I -> I) & (S -> S)`, which is the subtyping of `I -> I` and thus should be rejected.

So one direct idea is to restrict the form of subtyping (decl.).

To reject

```
(I -> I) & (S -> S) <:1 (I -> I) & (S -> S)
```

is also meant to settle a canonical form of subtyping: the shape of RHS of subtyping should respect the counter.

If counter is n, then `A <:n A1 -> ... -> An -> ?`
If counter is ∞, then `A <:∞ B`

What about the n is `0`, we have nothing in hand, it probably means refl rule:

```
--------- Refl
A <:0 A
```

# Plain Subtyping

```
----------- Refl
Int <: Int

-------- Top
A <: Top

C <:A    B <: D
-------------------- Arr
A -> B <: C -> D

A <: C
----------- And-L
A & B <: C

B <: C
------------ And-R
A & B <: C

A <: B
A <: C
------------ And
A <: B & C
```

# Subtyping w/ Counters

I put comments in each rule;

I use syntactic sugar: `∞/0` means `∞ | 0`, `∞/n` means `∞ | n`.

```
----------- Refl (if counter is 0, we know nothing but itself, if counter is ∞, we know everything (A is given))
A <:∞/0 A

-------- Top
A <:∞ Top

C <:∞ A    B <:∞/n- D
----------------------- Arr (if counter is ∞, we know everything, otherwise, C is given,
-----------------------      note here there's a contra, but i think it's fine since in ∞, LHS and RHS are all known)
A -> B <:∞/n C -> D

A <:∞/n C
----------- And-L (delegate to some branch)
A & B <:∞/n C

B <:∞/n C
------------ And-R
A & B <:∞/n C

A <:∞ B
A <:∞ C
------------ And (?)
A <:∞ B & C
```

Let's justify those rules

# Examples

* To accept `T |-0 ((\x. x) : (I -> I) & (B -> B)) 1 : I`

```
                                                  ----------- Refl   ---------- Refl
                                                     I <:∞ I          I <:0 I
                                                  ----------------------------------- Arr
                                                     I -> I <:1 I -> I
                                                  ----------------------------------- And-L
T |-0 (\x. x) : (I -> I) & (B -> B) : I -> I        (I -> I) & (B -> B) <:1 I -> I
----------------------------------------------------------------------------------- Sub
T |-1 (\x. x) : (I -> I) & (B -> B) : I -> I      T |-0 1 : I
------------------------------------------------------------------- App2
T |-0 ((\x. x) : (I -> I) & (B -> B)) 1 : I
```

*  To reject `T |-1 (\x. x) : (I -> I) & (B -> B) : (I -> I) & (B -> B)`

```
(I -> I) & (B -> B) <:1 (I -> I)    (I -> I) & (B -> B) <:1 (B -> B)
-------------------------------------------------------------------- And <- we reject it in this rule
(I -> I) & (B -> B) <:1 (I -> I) & (B -> B)
----------------------------------------------------------- Sub
T |-1 (\x. x) : (I -> I) & (B -> B) : (I -> I) & (B -> B)
```

This is obviously not rejected, then the problem is, should we reject this term?

Note that the reason to reject it is to keep the completeness property,

# Typing

The changes on typing is subtle, after generalizing the subsumption rule, we only need to append one rule for introducing intersection types.

```
T |-j e : A   T |-j e : B
---------------------------- Ty-And
T |-j e : A & B
```

This is also the same with algo rule

```
T |- H => e => A     T |- H => e => B
--------------------------------------- Ty-And
T |- H => e => A & B
```

# Algo. Subtyping

```
T |- Top => e => B       T |- B <: H ~> C
------------------------------------------ Sub
T |- H => e => C
```

This is general form of the subsumption rule, it should respect the previous cases:

```
T |- Top => e => A      T |- A <: B
------------------------------------------------
T |- B => e => A
```



In the form of `T |- A <: H ~> B`

* if `H` is a normal type, which corresponds to the "∞" in decl., we probably don't need care about the output type, just return A
* if `H` is a hint



```
----------------- Refl
T |- A <: A ~> A


--------------------- Top
T |- A <: Top ~> A


T |- C <: A ~> C      T |- B <: D ~> B
------------------------------------------- Arr
T |- A -> B <: C -> D ~> C -> B


T |- A => e => C     T |- B <: H ~> D
-------------------------------------- Hole
T |- A -> B <: [e] -> H ~> A -> D


T |- A <: H ~> C
-------------------------------- And-L
T |- A & B <: H ~> C


T |- B <: H ~> C
-------------------------------- And-R
T |- A & B <: H ~> C


T |- A <: B ~> B
T |- A <: C ~> C
--------------------------- And
T |- A <: B & C ~> B & C
```

# Examples (Algo.)

* To accept `T |- Top => ((\x. x) : (I -> I) & (B -> B)) 1 => I`

```
T |- Top => (\x. x) : (I -> I) & (B -> B) => (I -> I) & (B -> B)   T |-  (I -> I) & (B -> B) <: [1] -> Top ~> I -> I
----------------------------------------------------------------------------------------------------------------- Sub
T |- [1] -> Top => (\x. x) : (I -> I) & (B -> B) => I -> I
------------------------------------------------------------------ App
T |- Top => ((\x. x) : (I -> I) & (B -> B)) 1 => I
```

Then about subtyping derivation:

```
T |- I => 1 => I     I <: Top ~> I
-------------------------------------------- Hole
T |- (I -> I) <: [1] -> Top ~> I -> I
------------------------------------------------------ And-L
T |-  (I -> I) & (B -> B) <: [1] -> Top ~> I -> I
```

I'm worried about the checking case, let's test
