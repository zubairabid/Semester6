---
title: NLA Notes
author: Zubair Abid
---

# Attention Is All You Need

## Overview

- Sequential nature of RNN-based models introduces memory constraints and 
  issues with batching
- Removes recurrence, uses only attention mechanism for global dependencies
- Uses self-attention

## References to check

- Oleksii Kuchaiev and Boris Ginsburg. Factorization tricks for LSTM networks.arXiv preprintarXiv:1703.10722, 2017.
- Noam Shazeer, Azalia Mirhoseini, Krzysztof Maziarz, Andy Davis, Quoc Le, Geoffrey Hinton,and Jeff Dean.  Outrageously large neural networks:  The sparsely-gated mixture-of-expertslayer.arXiv preprint arXiv:1701.06538, 2017.


# BiDAF

[Amaze minions](https://towardsdatascience.com/the-definitive-guide-to-bi-directional-attention-flow-d0e96e9e666b)

## Embedding

- Take the query and context
- Get word embedding for both (Glove)
- Get character embedding for both (CNN?)
- Concatenate the two embeddings for both, send it through a highway network
- Get contextual embeddings for the output through a bi-LSTM to get both

## Attention

- Get a similarity matrix with $\alpha$
- Generate C2Q, getting the query words important for context. Like attention, 
  use the similarity matrix as input
- Generate Q2C, getting the context words important for query. Like before
- Megamerge the og Context matrix, C2Q, Q2C, using $\beta$

## Modelling and output layers

- two stacked biLSTMS on the query aware context
- Concat M1, M2 with G, and get prob dist over start and end indices

## Batch Normalisation

- Need to normalise the (hidden) layers, but it is infeasible to do it across 
  the board and jointly
- First simplification: Normalize each scalar feature independently, and also 
  make sure it's in identity mapping, learn these parameters while training 
  alongside the original
- Second simplification: use mini batches for estimates of mean and variance

It also:

- enables higher learning rates
- regularizes the model

## Learning Question Classifiers

- Take a question, figure out what type of answer it wants
- Uses a hierarchical classifier

## Data Intensive QA

- Take a question, reformat into a query, google it, get results, stitch them
- Has:
    - Query Reformulation
    - N-Gram harvesting
    - Answer Typing
    - Answer Tiling

## Web Question answering

- asks if more is always better, does experiments with DIQA model

## DrQA

- Answers factoid questions by looking up wikipedia, retrieving text, processing
  that.
