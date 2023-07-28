---
title: What Is Abstracting Binding Trees?
---

In PFPL:

> An abstract binding tree (ABT) is an abstract syntax tree (AST) that also knows about binders and variables. That is to say, it generalizes AST in terms of binding.

AST is often used to represent language constructs, for example, variables, lambda abstraction and function application. You can use many representations of binding to encode lambda abstraction. However, when expressions expand to more constructs with binding, there will be a problem.

Let's say we use de Bruijn to represent lambda binding. Then, $\lambda f.~ \lambda x.~ f~x$ is

```
Lam (Lam (App (Var 1) (Var 0)))
```

where `0` points to the nearest `Lam` and `1` points to the one outer `Lam`. Everything is happy. Then we extend our language with a let expression, to represent `let x = 1 in (succ x)`, we write

```
Let (Lit 1) (Succ (Var 0))
```

We know only the second expression involved with a binding, and the first expression should be free in `Let`. However, our AST cannot tell us that. The `Lam` is lucky since there's only one parameter of it.

For the implementation of ABT, I recommend to take a closer look at Jeremy's [abstract-binding-trees](https://github.com/jsiek/abstract-binding-trees). In this library, the `Sig` is defined to denote the position of parameter with binding. For example, `Lam`, `App` and `Let` can be given as:

```
sig : Op → List Sig
sig op-lam = (ν ■) ∷ []
sig op-app = ■ ∷ ■ ∷ []
sig op-let = ■ ∷ (ν ■) ∷ []
```

The `ν` brings one variable into scope. The `■` terminates the changes in scope.