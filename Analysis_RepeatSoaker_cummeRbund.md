RepeatSoaker effect on DEGs detection
========================================================















Overlap among DEGs identified in the non-soaked data (index [[1]]) and RepeatSoaked data at 75%, 50, 25 and 1% thresholds (subsequent indexes).


```
##  all  r75  r50  r25  r01 
## 2062 2049 2043 2028 1893
```

<img src="img/diffGeneIDs.png" title="plot of chunk diffGeneIDs" alt="plot of chunk diffGeneIDs" width="700" />


We observe that soaking diminishes the number of differentially expressed genes. More rigorous soaking (less strict overlap threshold) also increases the number of genes not detected previously.




Now, we check what those genes unique to each RepeatSoaker % are. We will look at 3 things:

1) Gene names and their description. Note that not all probes can be mapped to genes, and some probes map to the same gene - therefore, the numbers in the Venn diagram and the tables below differ.

2) GO enrichment of those genes, if any. (featureNames from cummeRbund conflicts with org.Mm.ed.db package, currently not functional)

3) Reactome pathway enrichment of those genes, if any. (TODO)

The goal is to (subjectively) judge what we are loosing. 


```
## Unique genes for non-RepeatSoaked data
```

<img src="img/u1.png" title="plot of chunk u1" alt="plot of chunk u1" width="700" />



```
## Unique genes for 75%-RepeatSoaked data
```

<img src="img/u2.png" title="plot of chunk u2" alt="plot of chunk u2" width="700" />



```
## Unique genes for 50%-RepeatSoaked data
```

<img src="img/u3.png" title="plot of chunk u3" alt="plot of chunk u3" width="700" />



```
## Unique genes for 25%-RepeatSoaked data
```

<img src="img/u4.png" title="plot of chunk u4" alt="plot of chunk u4" width="700" />



```
## Unique genes for 1%-RepeatSoaked data
```

<img src="img/u5.png" title="plot of chunk u5" alt="plot of chunk u5" width="700" />


TODO: What we are gaining.

