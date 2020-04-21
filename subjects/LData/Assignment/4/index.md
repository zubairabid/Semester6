---
title: Linguistic Data Assignment 4
author: Zubair Abid
layout: page
---

- try a highest frequency for baseline
- CRF on word embedding and tag
- trigram classifier


| Features                  | Weighted Precision | Weighted Recall | Weighted F1 |
|---------------------------|--------------------|-----------------|-------------|
| all (baseline)            | 0.830              | 0.840           | 0.830       |
| all but POS               | 0.798              | 0.807           | 0.795       |
| all but chunkType         | 0.821              | 0.831           | 0.830       |
| all but chunkId           | 0.812              | 0.821           | 0.811       |
| all but chunkId, POS      | 0.785              | 0.781           | 0.768       |
| only POS                  | 0.660              | 0.685           | 0.656       |
| only POS, Chunk, voice    | 0.737              | 0.735           | 0.719       |
| all but Chunk, voice      | 0.793              | 0.805           | 0.791       |
| all+word but Chunk, voice | 0.820              | 0.833           | 0.824       |
| all+word                  | 0.853              | 0.862           | 0.855       |

