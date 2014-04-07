Understanding the biology of RepeatSoaker effect
=================================================


























Our goal is to see whether thrown away genes may be biologically interesting. What are we losing after RepeatSoaker?

We check unique genes from the Venn diagram for GO and pathway enrichment.

Unique genes without RepeatSoaker
---------------------------------


```
## 
## KEGG.db contains mappings based on older data because the original resource was removed from the the public
##   domain before the most recent update was produced. This package should now be considered deprecated and
##   future versions of Bioconductor may not have it available.  Users who want more current data are
##   encouraged to look at the KEGGREST or reactome.db packages
## 
## The number of enriched GOs:12
```

<img src="img/KEGGall.png" title="plot of chunk KEGGall" alt="plot of chunk KEGGall" width="700" />



```
## The number of enriched GOs:520
```

<img src="img/GOall.png" title="plot of chunk GOall" alt="plot of chunk GOall" width="700" />



```
## The number of enriched pathways:80
```

<img src="img/Pathwayall.png" title="plot of chunk Pathwayall" alt="plot of chunk Pathwayall" width="700" />


Unique genes with 75% RepeatSoaker
----------------------------------


```
## The number of enriched GOs:3
```

<img src="img/KEGGr75.png" title="plot of chunk KEGGr75" alt="plot of chunk KEGGr75" width="700" />



```
## The number of enriched GOs:358
```

<img src="img/GOR75.png" title="plot of chunk GOR75" alt="plot of chunk GOR75" width="700" />



```
## The number of enriched pathways:30
```

<img src="img/PathwayR75.png" title="plot of chunk PathwayR75" alt="plot of chunk PathwayR75" width="700" />


Unique genes with 50% RepeatSoaker
----------------------------------


```
## The number of enriched GOs:3
```

<img src="img/KEGGr50.png" title="plot of chunk KEGGr50" alt="plot of chunk KEGGr50" width="700" />



```
## The number of enriched GOs:315
```

<img src="img/GOR50.png" title="plot of chunk GOR50" alt="plot of chunk GOR50" width="700" />



```
## The number of enriched pathways:21
```

<img src="img/PathwayR50l.png" title="plot of chunk PathwayR50l" alt="plot of chunk PathwayR50l" width="700" />


Unique genes with 25% RepeatSoaker
---------------------------------


```
## The number of enriched GOs:10
```

<img src="img/KEGGr25.png" title="plot of chunk KEGGr25" alt="plot of chunk KEGGr25" width="700" />



```
## The number of enriched GOs:481
```

<img src="img/GOR25.png" title="plot of chunk GOR25" alt="plot of chunk GOR25" width="700" />



```
## The number of enriched pathways:52
```

<img src="img/PathwayR25.png" title="plot of chunk PathwayR25" alt="plot of chunk PathwayR25" width="700" />


Unique genes with 00% RepeatSoaker
---------------------------------


```
## The number of enriched GOs:43
```

<img src="img/KEGGr00.png" title="plot of chunk KEGGr00" alt="plot of chunk KEGGr00" width="700" />



```
## The number of enriched GOs:2178
```

<img src="img/GOR00.png" title="plot of chunk GOR00" alt="plot of chunk GOR00" width="700" />



```
## The number of enriched pathways:198
```

<img src="img/PathwayR00.png" title="plot of chunk PathwayR00" alt="plot of chunk PathwayR00" width="700" />


Comparing genes without and with RepeatSoaker treatment
========================================================
Genes without RepeatSoaker
----------------------------

```
## The number of enriched GOs:76
```

<img src="img/KEGG_noRS.png" title="plot of chunk KEGG_noRS" alt="plot of chunk KEGG_noRS" width="700" />



```
## The number of enriched GOs:4157
```

<img src="img/GO_noRS.png" title="plot of chunk GO_noRS" alt="plot of chunk GO_noRS" width="700" />



```
## The number of enriched pathways:637
```

<img src="img/Pathway_noRS.png" title="plot of chunk Pathway_noRS" alt="plot of chunk Pathway_noRS" width="700" />


Genes with RepeatSoaker
--------------------------

```
## The number of enriched GOs:80
```

<img src="img/KEGG_wRS.png" title="plot of chunk KEGG_wRS" alt="plot of chunk KEGG_wRS" width="700" />



```
## The number of enriched GOs:3622
```

<img src="img/GO_wRS.png" title="plot of chunk GO_wRS" alt="plot of chunk GO_wRS" width="700" />



```
## The number of enriched pathways:538
```

<img src="img/Pathway_wRS.png" title="plot of chunk Pathway_wRS" alt="plot of chunk Pathway_wRS" width="700" />


