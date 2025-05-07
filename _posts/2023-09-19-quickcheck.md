---
layout: post
title: "Snippets of QuickCheck in Haskell"
date: 2023-09-19 00:00:00 +0000
categories: [programming]
tags: [haskell]
---

QuickCheck is a Haskell's package used to test properties of programs. The snippets are based on Koen Claessen and John Hughes's *"QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs"*.

```haskell
module Main where

import Test.QuickCheck
    ( orderedList,
      (==>),
      classify,
      collect,
      forAll,
      quickCheck,
      Property )

-- The programmer must specify a fixed type at which the law is to be tested
-- in some cases, we can use parametricity to argue that a property holds polymorphically
prop_RevUnit :: Int -> Bool
prop_RevUnit x =
    reverse [x] == [x]

prop_RevApp :: [Int] -> [Int] -> Bool
prop_RevApp xs ys =
    reverse (xs ++ ys) == reverse ys ++ reverse xs

prop_RevRev :: [Int] -> Bool
prop_RevRev xs =
    reverse (reverse xs) == xs

-- you can use implication (==>) to express conditional properties
prop_MaxLe :: Int -> Int -> Property
prop_MaxLe x y =
    x <= y ==> max x y == y

-- you can use "classify" and "collect" to monitor test data
ordered :: [Int] -> Bool
ordered [] = True
ordered (x:xs) = all (>= x) xs && ordered xs

insert :: Int -> [Int] -> [Int]
insert x [] = [x]
insert x (y:ys) = if x <= y then x : y : ys else y : insert x ys

prop_Insert :: Int -> [Int] -> Property
prop_Insert x xs =
    ordered xs ==> ordered (insert x xs)

-- we sieve out the case of empty lists
prop_InsertClassify :: Int -> [Int] -> Property
prop_InsertClassify x xs =
    ordered xs ==>
        classify (null xs) "trivial cases" $
            ordered (insert x xs)

-- we list the percent of cases according to the length of the list
prop_InsertCollect :: Int -> [Int] -> Property
prop_InsertCollect x xs =
    ordered xs ==>
        collect (length xs) $
            ordered (insert x xs)

-- to guide the generator to generate less trivial cases
prop_InsertOrdered :: Int -> Property
prop_InsertOrdered x =
    forAll orderedList $ \xs ->
        ordered (insert x xs)

main :: IO ()
main = do
    quickCheck prop_RevUnit
    quickCheck prop_RevApp
    quickCheck prop_RevRev
    quickCheck prop_MaxLe
    quickCheck prop_Insert
    quickCheck prop_InsertClassify
    quickCheck prop_InsertCollect
    quickCheck prop_InsertOrdered
```

## TODO

* Defining Generators
* Implementing QuickCheck
