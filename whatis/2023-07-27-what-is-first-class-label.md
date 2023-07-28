---
title: What Is First Class Label?
---

Take the definition from "First-class labels for extensible rows":

>  In language with first class labels, Labels become first-class values that can be passed as arguments.

I use Javascript to illustrate the difference between it and our familiar ones.

```
const person = {
  name: "john",
  age: 50,
};

static_access = person.age;
dyn_label = "age";
dynamic_access = person[dyn_label];
```

In normal record calculi, labels are part of syntax and always statically known, as `static_access`. Thus, `age` is not a first-class label.

Javascript also supports a *computed field access* which allows you to give a variable which value can be assigned in runtime, then compute the result. And `dyn_label` is a first-class label.

## Why bother?

The behavior of dynamic semantics is straightforward, 
