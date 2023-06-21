---
title: Strict Bidirectional Type Checking
---

Bidirectional typing is helpful in giving the annotation only in the outermost part of the expression. The type information will propagate inside. For example,

```
(\x. \y. x) <= Int -> Int -> Int
```

But this is more or less
