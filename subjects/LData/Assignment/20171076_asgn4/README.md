---
title: Linguistics Data 2 Assignment 4
author: Zubair Abid (20171076)
date: 2020-04-21 20:12
---

# Problem

We are trying to predict AnnCorra tags to be assigned across a sentence, given
previously annotated data that also contains feature information of each word,
including POS tags, gender, number, case, vibhakti, TAM, and chunk type. 

# Solution

We build a CRF classifier that takes the features of the word as input, and
returns as output the AnnCorra tag for the specific word. 

As the tagging depends on the features provided, we change that to check for
differences in the result. Starting off with a baseline of including all 
features for consideration, we move on to include and exclude features to then
compare their relative performance.

# Results

# Evaluating the model, and notes on running the code

For ease of evaluation, a script and a test file have been provided. You can 
run it by typing `python eval.py crf_model.pkl testfile.pkl`, where 
`crf_model.pkl` is the downloaded model file, and `testfile.pkl` is the provided
test file. It will output the F-Score, and a class-wise breakdown of the result.

For running the python notebooks, we need to download the provided 
`AnnCorra.zip` provided and extract it into a folder. Then, create a `Data`
folder. Now all that needs to be run is `./dataformatter.ipynb` and
`./CRFTagger.ipynb`, in succession. The model takes about 10 minutes to train
on an i7-5600U.
