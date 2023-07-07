---
title: What Is Gradual Guarantee?
---

In this post, I'll try to explain what is gradual guarantee intuitively and also formally. There're three main reasons:

* When I was a Racket fan during my undergraduate, I was informed that Typed Racket is a well-designed gradual language and there's a soundness proof which is ensured by a contract system that interacts between Racket (untyped) and its type system.

* One of my colleagues keep working on designing gradual type systems, and she's given [many talks](https://hkuplg.github.io/problem/session/2022/06/21/Relational-Parametricity-and-Gradual-Guarantee/) involved with gradual guarantee in our seminars, but I never really got its idea.

* Sometimes I learn some formalisation techniques from Jeremy Siek's [gradual-typing-in-agda](https://github.com/jsiek/gradual-typing-in-agda). It might be a good chance to study GTLC (Gradually Typed Lambda Calculus) seriously.

## Refined Criteria for Gradual Typing