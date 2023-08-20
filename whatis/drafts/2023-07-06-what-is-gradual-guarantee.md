---
title: What Is Gradual Guarantee?
---

I will use Typed Racket to explain this concept, though authors of *Toward efficient gradual typing for structural types via coercions* commented that:

> We note that Typed Racket is sound and partially supports the gradual guarantee: its type system does not satisfy the static part of the gradual guarantee because it requires what amounts to an explicit downcast to use a Racket module from a Typed Racket module. However, the semantics of Typed Racket’s runtime checks are compatible with the dynamic part of the gradual guarantee.