#!/usr/bin/env python3
import sys
import os
gold=[l.strip().split("\t")[-2] for l in open(sys.argv[1]).readlines() if l.strip()]
pred=[l.strip().split("\t")[-1] for l in open(sys.argv[1]).readlines() if l.strip()]
assert(len(gold)==len(pred))
correct=0
for g,p in zip(gold,pred):
    if g==p:
        correct+=1
total=len(gold)
print("{0}: {1:.2f}".format(os.path.basename(sys.argv[1]),correct/total*100))
