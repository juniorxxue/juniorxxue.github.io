---
title: \x.x Is Not Polymorphic?
---

Recently I've been working on type inference work on System F with subtyping, which basically does the job of Pierce's local type inference, but in a different flavor and mechanical formalisation in Agda.

When crafting concrete examples, I wrote down the following ones:

```
((\x. x) : ∀a. a -> a) 1
```

This expression was however, commented on by my colleague: "`\x.x` is a monomorphic function, you can't annotate it with a forall type". I paused for several seconds and started drafting on my paper:

```
-------------------- Lam
⊢ (\x. x) : a -> a
------------------------ ?
⊢ (\x. x) : ∀a. a -> a
--------------------------------------- Ann
⊢ ((\x. x) : ∀a. a -> a) : Int -> Int
-------------------------------------- App
⊢ ((\x. x) : ∀a. a -> a) 1
```

Well, which rule we are missing here? Gen rule!

```
Γ ⊢ e : A       a ∉ free(Γ)
---------------------------- Gen
Γ ⊢ e : ∀a. A
```

This rule usually appears in HM-like type systems, while not in our settings. Without the Gen rule, we only can create polymorphic functions using big lambda:

```
(/\a. (\x. x : a -> a)) 1
```

To conclude, without adopting techniques like generalisation, `\x. x` is not a polymorphic function.