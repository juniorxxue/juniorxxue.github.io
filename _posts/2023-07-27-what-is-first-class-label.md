---
layout: post
title: What is first class label?
date: 2023-07-27 00:00:00 +0000
categories: [programming]
tags: [types]
---

In languages with first-class labels, labels are treated as first-class values that can be passed as arguments. I'll use Javascript to explain how it differs from our familiar ones.

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

While the behavior of dynamic semantics is straightforward, designing the corresponding type system is a challenge. For the purpose of this demonstration, I will be using"  *qualified type system*:

In expression `person.age`, `_.age` is a operator that access constant label age, so its type can be

```
(_.age) :: ∀ r a. (r\age) => {age :: a | r} -> a
```

`_age` indicates that given a record containing label `age`, return the term with the type associated with label `age`.

In expression `person["age"]`, since `"age"` can be given in runtime, `_._` become a operator and its type is

```
(_[_]) ::∀ r l a. (r\l) => {l :: a | r} -> Lab l -> a
```

Though `"age"` is a string, we view it as a `Lab` type. The type of `_[_]` means given a record containing a arbitrary label `l`, and a label `l`, return the term with the type associated with label `l`.
