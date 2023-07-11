---
title: What Is Gradual Guarantee?
---

**Warning: Don't read. Till then, I haven't really understood all the details, give me some time to sort it out**

::: ask
Any prerequisites before reading this post?
:::

::: answer
I suggest reading Jeremy Siek's [What is Gradual Typing](https://wphomes.soic.indiana.edu/jsiek/what-is-gradual-typing/), which gives an intuitive explanation of gradual typing.
:::

::: ask
Okay, so why are you curious about gradual guarantee?
:::

::: answer
There're three main reasons:

- When I was a Racket fan during my undergraduate, I was informed and curious that Typed Racket is a well-designed gradual language and there’s a soundness proof which is ensured by a contract system that interacts between Racket (untyped) and its type system.

- One of my colleagues keeps working on designing gradual type systems, and she’s given many talks involved with gradual guarantee in our seminars, shamelessly, I never really got its idea.

- Sometimes I learn some formalisation techniques from Jeremy Siek’s gradual-typing-in-agda. It might be a good chance to study GTLC (Gradually Typed Lambda Calculus) seriously.
:::

::: ask
Then, why should I learn about it?
:::

::: answer
Gradual guarantee has already been widely taken as a criteria in designing gradual type systems.
:::

::: ask
So, what does the gradual guarantee guarantee?
:::

::: answer
Good point. It guarantees that:

-
-
-

I will also show explanations in a formal way (how it hits the theorem).
:::

::: answer
Let's just check the theorem first, it's taken from [Refined Criteria for Gradual Typing](https://drops.dagstuhl.de/opus/volltexte/2015/5031/pdf/21.pdf).
:::

::: answer
Suppose $e \sqsubseteq e'$ and $\vdash e : T$.

- $\vdash e' : T'$ and $T \sqsubseteq T'$.

- If $e \Downarrow v$, then $e' \Downarrow v'$ and $v \sqsubseteq v'$. If $e \Uparrow$ then $e' \Uparrow$.

- If $e' \Downarrow v'$, then $e \Downarrow v$ where $v \sqsubseteq v'$, or $e \Downarrow blame_T l$. If $e' \Uparrow$, then $e \Uparrow$ or $e \Downarrow blame_T l$.
:::

::: ask
What do these notations mean?
:::

::: answer
- $\vdash e : T$ and $e \Downarrow v$ are what we are familiar with, they mean that $e$ is well-typed and $e$ evaluates to $v$.

- $T \sqsubseteq T'$ means that $T$ is more precise than $T'$ and $e \sqsubseteq e'$ means that $e$ is more precisely annotated than $e'$.
:::

::: ask
What about the theorem then?
:::

::: answer
The first theorem is called "static gradual guarantee", it simply tells you that making terms more dynamic doesn't affect its well-typedness.

Note here "more dynamic" means that you can replace the annotation to a less precise one, for example, changing $\lambda x:Int.~x$ to $\lambda x:*.~x$.
:::