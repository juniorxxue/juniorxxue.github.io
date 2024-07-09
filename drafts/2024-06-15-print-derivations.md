---
title: Print typing derivations using Writer monad
---

Often we justify whether the typing rules we just designed are correct or not by
testing some expressions using pen and paper's style. However, if the typing is algorithmic, there's no reason not to implement it and let program figure out which rule to apply for you!

In this blog I will give a tutorial on how to print typing derivations of STLC with bidirectional typing. The STLC rules can be found in DK's survey paper "Bidirectional Typing". For example, the one simple example is

```haskell
infer (Ann (Lam (Var 0) (Arr TInt TInt))
```

## Challenge

## More Fancy Printing?
Indent-style printing is less fancy than tree-style printing, I also consider to use package like `Data.Tree` and `Data.Tree.View` to generate nicely rendered htmls where the nodes are collapsible.

However, this requires us to change our writer state to a tree structure, and instead of appending the log from sub-derivations with certain indentation, we need to find the rightmost node and append the tree onto it, which is a bit more complicated than the current implementation.
