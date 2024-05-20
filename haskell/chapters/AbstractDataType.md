---
title: Abstract Data Type
---

I often get confused by Haskell's algebraic datatype and abstract data type when I was a young learner. The main reason, I guess, is their abbrevations are both ADT. This following text gives a introduction to abstract datatype and  assumes the familiairity of algebraic datatypes.

## What is it?

Abstract datatype is an abstraction layer over data structures. In practicle, data structures are often implemented as a external library with some APIs exported. ADT gives a similiar feeling, for example, OCaml features ADT via modules: the specification is a *signature*; the implementation is a *structure*.

```ocaml
module type Queue = sig
  type 'a queue

  val empty : 'a queue
  val isEmpty : 'a queue -> bool

  val snoc : 'a -> 'a queue -> 'a queue
  val first : 'a queue -> 'a option
  val rest : 'a queue -> 'a queue option
end
```

```ocaml
module MySeq : Sequence = struct

  type 'a mylist =
    Empty
  | Cons of 'a * 'a mylist

  type 'a sequence = 'a mylist

  let empty = Empty

  let is_empty = function
    | Empty -> true
    | _ -> false

  let extend = fun e l -> Cons (e, l)

  let first = function
    | Empty -> None
    | Cons (e, l) -> Some e

  let rest = function
    | Empty -> None
    | Cons (e, l) -> Some l

  let rec index n = function
    | Empty -> None
    | Cons (e, l) when n = 0 -> Some e
    | Cons (e, Cons (_, tl)) when n > 0 -> index (n-1) tl
    | _ -> None

end
```

## How Haskell implmenets ADT?

## Comparison with Algebraic Data Type
