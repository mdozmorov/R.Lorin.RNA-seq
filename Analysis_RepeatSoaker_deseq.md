RepeatSoaker effect on DEGs detection
========================================================





















Overlap among DEGs identified in the non-soaked data (index [[1]]) and RepeatSoaked data at 75%, 50, 25 and 1% thresholds (subsequent indexes).


```
## estimating size factors
## estimating dispersions
## gene-wise dispersion estimates
## mean-dispersion relationship
## final dispersion estimates
## fitting model and testing
## estimating size factors
## estimating dispersions
## gene-wise dispersion estimates
## mean-dispersion relationship
## final dispersion estimates
## fitting model and testing
## estimating size factors
## estimating dispersions
## gene-wise dispersion estimates
## mean-dispersion relationship
## final dispersion estimates
## fitting model and testing
## estimating size factors
## estimating dispersions
## gene-wise dispersion estimates
## mean-dispersion relationship
## final dispersion estimates
## fitting model and testing
## estimating size factors
## estimating dispersions
## gene-wise dispersion estimates
## mean-dispersion relationship
## final dispersion estimates
## fitting model and testing
```

<img src="img/diffGeneIDs.png" title="plot of chunk diffGeneIDs" alt="plot of chunk diffGeneIDs" width="700" />











We observe that soaking diminishes the number of differentially expressed genes. More rigorous soaking (less strict overlap threshold) also increases the number of genes not detected previously.

Withour RepeatSoaker, we have (all genes in the rownames(res[[1]]) oval):


```
## Number of differentially expressed PROBES, no RepeatSoaker: 2019
## Number of differentially expressed GENES, no RepeatSoaker: 1991
```


Some probes map to multiple genes, hence the discrepancy in numbers. 

After trimming the data with 0% RepeatSoaker settings, we have (res[[5]] oval):


```
## Number of differentially expressed PROBES, with RepeatSoaker: 1719
## Number of differentially expressed GENES, with RepeatSoaker: 1697
```


Now, we compare these gene lists (Genes without vs. Genes with RepeatSoaker) for biological meaning. The tables are sequential, first table is for non-repeatsoaked data, second - for 0% repeatsoaked data.


```
## The number of enriched GOs:35
```

<img src="img/KEGGall_nor.png" title="plot of chunk KEGGall_nor" alt="plot of chunk KEGGall_nor" width="700" />



```
## The number of enriched GOs:33
```

<img src="img/KEGGall_r00.png" title="plot of chunk KEGGall_r00" alt="plot of chunk KEGGall_r00" width="700" />



```
## The number of enriched GOs:2035
```

<img src="img/GOall_nor.png" title="plot of chunk GOall_nor" alt="plot of chunk GOall_nor" width="700" />



```
## The number of enriched GOs:2025
```

<img src="img/GOall_r00.png" title="plot of chunk GOall_r00" alt="plot of chunk GOall_r00" width="700" />



```
## The number of enriched pathways:403
```

<img src="img/Pathwayall_nor.png" title="plot of chunk Pathwayall_nor" alt="plot of chunk Pathwayall_nor" width="700" />



```
## The number of enriched pathways:390
```

<img src="img/Pathwayall_r00.png" title="plot of chunk Pathwayall_r00" alt="plot of chunk Pathwayall_r00" width="700" />


Now, we check what those genes unique to each RepeatSoaker % are. We will look at 3 things:

1) Gene names and their description. Note that not all probes can be mapped to genes, and some probes map to the same gene - therefore, the numbers in the Venn diagram and the tables below differ.

2) GO, KEGG and Reactome Pathway enrichment of those genes, if any. 

Genes unique for different RepeatSoaker settings
-------------------------------------------------

Unique genes without RepeatSoaker
---------------------------------

<img src="img/u1.png" title="plot of chunk u1" alt="plot of chunk u1" width="700" />



```
## The number of enriched GOs:10
```

<img src="img/KEGGall.png" title="plot of chunk KEGGall" alt="plot of chunk KEGGall" width="700" />



```
## The number of enriched GOs:31
```

<img src="img/GOall.png" title="plot of chunk GOall" alt="plot of chunk GOall" width="700" />



```
## The number of enriched pathways:0
```


Unique genes with 75% RepeatSoaker
----------------------------------

<img src="img/u2.png" title="plot of chunk u2" alt="plot of chunk u2" width="700" />



```
## The number of enriched GOs:1
```

<img src="img/KEGGr75.png" title="plot of chunk KEGGr75" alt="plot of chunk KEGGr75" width="700" />



```
## The number of enriched GOs:52
```

<img src="img/GOr75.png" title="plot of chunk GOr75" alt="plot of chunk GOr75" width="700" />



```
## The number of enriched pathways:6
```

<img src="img/Pathwayr75.png" title="plot of chunk Pathwayr75" alt="plot of chunk Pathwayr75" width="700" />


Unique genes with 50% RepeatSoaker
----------------------------------

<img src="img/u3.png" title="plot of chunk u3" alt="plot of chunk u3" width="700" />



```
## The number of enriched GOs:1
```

<img src="img/KEGGr50.png" title="plot of chunk KEGGr50" alt="plot of chunk KEGGr50" width="700" />



```
## The number of enriched GOs:32
```

<img src="img/GOr50.png" title="plot of chunk GOr50" alt="plot of chunk GOr50" width="700" />



```
## The number of enriched pathways:25
```

<img src="img/Pathwayr50.png" title="plot of chunk Pathwayr50" alt="plot of chunk Pathwayr50" width="700" />


Unique genes with 25% RepeatSoaker
---------------------------------

<img src="img/u4.png" title="plot of chunk u4" alt="plot of chunk u4" width="700" />



```
## The number of enriched GOs:4
```

<img src="img/KEGGr25.png" title="plot of chunk KEGGr25" alt="plot of chunk KEGGr25" width="700" />



```
## The number of enriched GOs:101
```

<img src="img/GOr25.png" title="plot of chunk GOr25" alt="plot of chunk GOr25" width="700" />



```
## The number of enriched pathways:51
```

<img src="img/Pathwayr25.png" title="plot of chunk Pathwayr25" alt="plot of chunk Pathwayr25" width="700" />


Unique genes with 00% RepeatSoaker
---------------------------------

<img src="img/u5.png" title="plot of chunk u5" alt="plot of chunk u5" width="700" />



```
## The number of enriched GOs:10
```

<img src="img/KEGGr00.png" title="plot of chunk KEGGr00" alt="plot of chunk KEGGr00" width="700" />



```
## The number of enriched GOs:109
```

<img src="img/GOr00.png" title="plot of chunk GOr00" alt="plot of chunk GOr00" width="700" />



```
## The number of enriched pathways:43
```

<img src="img/Pathwayr00.png" title="plot of chunk Pathwayr00" alt="plot of chunk Pathwayr00" width="700" />


Other tests
------------

Let's have a look at the distribution of log2 fold change of genes in the leaves of the Venn diagram, as compared with that of the heart of the Venn diagram. It is expected that the leaves may have fold change different from the main DEGs.

<img src="img/boxPlot.png" title="plot of chunk boxPlot" alt="plot of chunk boxPlot" width="700" />


We also check the same for the expression level.

<img src="img/boxPlotExpr.png" title="plot of chunk boxPlotExpr" alt="plot of chunk boxPlotExpr" width="700" />


The leaves may have overall lower expression level, hence, more susceptible to the RepeatSoaker.

