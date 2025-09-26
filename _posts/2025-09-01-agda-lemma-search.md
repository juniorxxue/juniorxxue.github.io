---
layout: post
title: "Vibe coding with Agda tooling: Fuzzy Lemma Search"
date: 2025-09-01 00:00:00 +0000
categories: [programming]
tags: [types, programming-languages]
---

My recent Agda project about local type inference has been increased to 10k lines of code, with 1k+ number of lemmas.
As the project grows, I find it increasingly difficult to remember all the lemmas I've written.

```
--------------------------------------------------------------------------------
 Language             Files        Lines        Blank      Comment         Code
--------------------------------------------------------------------------------
 Agda                   115        14029         1744          257        12028
--------------------------------------------------------------------------------
```


To ease this kind of pain, about half a year ago, I wrote a simple regex-based command-line tool for lemma searching, which was also assisted by ChatGPT.
I used it on a daily basis, and it really helped me a lot to locate the lemmas, and avoid the duplication of proving the similar lemmas.
I'm 70% happy with it.

Nowadays, I saw a recent trend that AI is very good at front-end tasks and a possibility of enhancing the user (my) experience, 
and then decided to migrate the tool to a web-based interface.
It costed me only a few hours with copilot's help, and I managed to have a [web-based site](https://types.hk/agda-lemma-search/).
Try typing `punchIn` to sieve the lemmas about `punchIn`!

The site is hosted on GitHub Pages, the data is retrieved from a python script that scans the Agda project and generates a JSON file.
The features include:

* Fuzzy searching: multiple keywords
* Project based: search within a specific project
* Unicode input: search with unicode characters
