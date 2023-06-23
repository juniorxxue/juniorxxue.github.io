---
title: Relevance Logic and Bidirectional Typing
---

Let's take some words from [Bidirectional Typing Survey](https://arxiv.org/pdf/1908.05839.pdf):

> Drawing inspiration from relevance logic, which requires variables to be used at least once (as opposed to the exactly-once constraint of linear logic), Chlipala et al. [2005] require a let-bound variable to be used at least once. This allows them to reverse the typing rule for let-expressions, reducing the annotation burden of the basic Pfenning recipe: no annotation is needed on the let-bound expression. Their typing contexts contain checking variables, whose moding is similar to the variables in our backwards bidirectional system. Such a variable must occur at least once in a checking position; that occurrence determines the type of the variable, which can be treated as synthesizing in all other occurrences.

This conclusion actually motivates quite well, we make it concrete here: consider to check a let binding expression `let f = \x.x in f` with the type `Int -> Int`. We can desugar this one into a function application, which becomes to check `(\f. f) (\x. x)`.  Note here this term cannot be checked by conventional rules of bidirectional typing since we know nothing about the function and arguments.

```
                       ?A = Int -> Int
                      ------------------------------ Var
T; . |- \x. x <= ?A    T; f : ?A |- f <= Int -> Int
--------------------------------------------------- App-Guess
T; . |- (\f. f) (\x. x) <= Int -> Int
```

We have a seperate context used for storing the unkown types, which will be solved in  the variable case and get the information back.

It's a temp understanding of this idea, I only have a vague intuition that if we have a strong property that "variables to be used at least once" then we can solve the `?A` but I haven't get into the detail yet. Will come back and say more on this.