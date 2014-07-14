# http://davetang.org/muse/2011/01/05/deseq-vs-edger-vs-bayseq/

source("http://www.bioconductor.org/biocLite.R")
biocLite("baySeq")
biocLite("DESeq")
biocLite("edgeR")
biocLite("goseq")

library(Biobase)
library(DESeq)
sampleTable<-read.table("sampleTable_rev.txt",sep="\t",header=T) 
sampleTable<-sampleTable[c(-4,-5),] # remove CTL4 and MUT1 outliers
sampleTable<-read.table("sampleTable_str.txt",sep="\t",header=T) 
sampleTable<-read.table("sampleTable_unstr.txt",sep="\t",header=T) 

countsTable<-newCountDataSetFromHTSeqCount(sampleTable,".") # HTSeq data
cds<-countsTable # Full dataset

library("arrayQualityMetrics")
arrayQualityMetrics(new("ExpressionSet",exprs=counts(cds)),outdir="arrayQualityMetrics_unstr",force=T) # Need to remove last column with refseq ids
IAC<-cor(counts(cds)[apply(counts(cds),1,mean) > quantile(unlist(counts(cds)))[[4]],]) # correlations of values in the upper 75% of expression range
library(cluster)
cluster<-hclust(as.dist(1-IAC), method="average")
plot(cluster, cex=0.7, labels=sampleTable[,3]) #dimnames(counts(cds))[[2]])

sampleCountTable<-sampleTable[,c(-3,-5,-9)] # Count table to use
sampleDesign<-data.frame(row.names = colnames(sampleCountTable),
                         condition=c(rep("CTRL",3),rep("MUT",3)),
                         replicate=c(1,2,3,1,2,3))
# Xist, Tsix test
barplot(counts(cds)[c("ENSMUSG00000085715","ENSMUSG00000086503"),])
# Dlk1 plot
gene<-"ENSMUSG00000040856"; gene.name<-"Dlk1"
boxplot(counts(cds)[gene,grep("CTL",colnames(counts(cds)))],counts(cds)[gene,grep("MUT",colnames(counts(cds)))],
        xlab="Condition",ylab="FPKM",main=gene.name, names=c("CTL","MUT"))

# Optional: average values
# countsAverage<-cbind(rowMeans(counts(countsTable)[,sampleTable$disease == "control"]),
#                               rowMeans(counts(countsTable)[,sampleTable$disease == "Negative"]))
# colnames(countsAverage)<-c("control","Negative")
# rownames(countsAverage)<-rownames(counts(countsTable))

slotNames(cds) # Which slots are available
pData(cds@phenoData)
head(counts(cds))
cds = estimateSizeFactors( cds ) # Normalization factors
sizeFactors( cds )
head( counts( cds, normalized=TRUE ) )
boxplot(log2(counts(cds, normalized=T))[,1:10],ylim=c(0,100))
cds = estimateDispersions( cds)#, sharingMode="gene-est-only" ) # Estimate dispersion
str( fitInfo(cds) )
head( fData(cds) ) 
plotDispEsts( cds )
# Optional: Filtering low expressed genes
rs = rowSums ( counts ( cds )) # Sum of all rows
theta = 0.4 # Remove lower 40% quantile
use = (rs > quantile(rs, probs=theta)) # Indexes what to keep and what's not
table(use) # How many to keep
cdsFilt = cds[ use, ] # Filtered dataset

# Binomial test for a single condition
levels(sampleTable[,3]) # Group names 
res = nbinomTest( cds, levels(sampleTable[,3])[1], levels(sampleTable[,3])[2] )
head(res)
plotMA(res)
hist(res$pval, breaks=100, col="skyblue", border="slateblue", main="")
#resSig = res[ res$padj < 0.1 & abs(res$log2FoldChange) > log2(1.5) , ] #  & res$baseMean>3 # Keeps NAs
resSig <- subset(res, padj<0.1 & abs(log2FoldChange) > log2(2) & baseMean>3) # Excludes rows with NAs
dim(resSig)
head( resSig[ order(resSig$pval), ] )
head( resSig[ order( resSig$foldChange, -resSig$baseMean ), ] ) # Most strongly downregulated
head( resSig[ order( -resSig$foldChange, -resSig$baseMean ), ] ) # Most strongly upregulated
library(biomaRt)
mart<-useMart("ensembl", dataset="mmusculus_gene_ensembl")
genes<-getBM(attributes=c('ensembl_gene_id','external_gene_id','description'), 
             filters='ensembl_gene_id', values=resSig$id, mart=mart)#, uniqueRows=T)
write.table(merge(resSig,genes,by.x="id",by.y="ensembl_gene_id",all.x=T),"f:/111.txt",row.names=F,sep="\t")
write.table(genes,"F:/222.txt",sep="\t")

# SAMR
library(samr)
samfit<- SAMseq(counts(cds, normalized=T), sampleTable[,3], resp.type = "Two class unpaired")
write.table(rbind(samfit$siggenes.table$genes.up,samfit$siggenes.table$genes.lo),"F:/111.txt",sep="\t")
genes<-getBM(attributes=c('ensembl_gene_id','external_gene_id','description'), 
             filters='ensembl_gene_id', values=rownames(counts(cds))[as.numeric(c(samfit$siggenes.table$genes.up[,2], samfit$siggenes.table$genes.lo[,2]))], mart=mart)#, uniqueRows=T)
write.table(genes,"F:/222.txt",sep="\t")

# GOseq
library("goseq")
supportedGenomes()[41,] # mm9
assayed.genes<-rownames(counts(cds)) # All gene IDs
de.genes<-as.integer(rep(0,length(rownames(counts(cds))))) # Vector of zeros
de.genes[assayed.genes %in% resSig$id]<-1 # Set to 1 which are DEGs
names(de.genes)<-assayed.genes
# de.genes from clipboard of ensIDs
# de.genes<-readLines("clipboard")

# head(gene.vector)
pwf=nullp(de.genes,"mm9","ensGene")
plotPWF(pwf)
GO.wall=goseq(pwf,"mm9","ensGene")
head(GO.wall)
GO.wall=goseq(pwf,"mm9","ensGene",test.cats=c("GO:MF")) # Only MF
# GO.samp=goseq(pwf,"hg19","ensGene",method="Sampling",repcnt=1000)
# head(GO.samp)
enriched.GO=GO.wall$category[p.adjust(GO.wall$over_represented_pvalue,method="BH")<0.05]
length(enriched.GO)
head(enriched.GO)
library(GO.db)
for(go in enriched.GO[1:10]){
  print(GOTERM[[go]])
  cat("--------------------------------------\n")
}

# no correction
GO.nobias=goseq(pwf,"mm9","ensGene",method="Hypergeometric")
head(GO.nobias)
enriched.GO.nobias=GO.nobias$category[p.adjust(GO.nobias$over_represented_pvalue,method="BH")<0.05]
length(enriched.GO.nobias)
for(go in enriched.GO.nobias[1:10]){
  print(GOTERM[[go]])
  cat("--------------------------------------\n")
}

#Get the mapping from ENSEMBL 2 Entrez
en2eg=as.list(org.Mm.egENSEMBL2EG)
#Get the mapping from Entrez 2 KEGG
eg2kegg=as.list(org.Mm.egPATH)
#Define a function which gets all unique KEGG IDs associated with a set of Entrez IDs
grepKEGG=function(id,mapkeys){unique(unlist(mapkeys[id],use.names=FALSE))}
#Apply this function to every entry in the mapping from ENSEMBL 2 Entrez to combine the two maps
kegg=lapply(en2eg,grepKEGG,eg2kegg)
head(kegg)
pwf=nullp(genes,"de.mm9","ensGene")
KEGG=goseq(pwf,gene2cat=kegg)
head(KEGG)
enriched.KEGG=KEGG$category[p.adjust(KEGG$over_represented_pvalue,method="BH")<0.05]
length(enriched.KEGG)
library(KEGG.db)
kegg2en<-revmap(kegg)
for(go in enriched.KEGG){
  print(KEGGPATHID2NAME[[go]])
  print(intersect(kegg2en[[go]], resSig$id) )
  cat("--------------------------------------\n")
}



#Optional: VSN
cdsBlind = estimateDispersions( cds, method="blind" )
vsd = varianceStabilizingTransformation( cdsBlind )
library(arrayQualityMetrics)
AQM<-arrayQualityMetrics(vsd,outdir="arrayQualityMetrics")
library(Biobase)
pd<-new("AnnotatedDataFrame", data=sampleTable)
cdsEset<-new("ExpressionSet",exprs=counts(cds))#,phenoData=pd)
# cdsvsc<-newCountDataSet( matrix_apply(exprs(vsd),as.integer), factor(sampleTable$disease) )
library("vsn")
par(mfrow=c(1,2))
notAllZero = (rowSums(counts(cds))>0)
meanSdPlot(log2(counts(cds)[notAllZero, ] + 1), ylim = c(0,2.5))
meanSdPlot(vsd[notAllZero, ], ylim = c(0,2.5))
cdsvsc<-newCountDataSet( matrix_apply(exprs(vsd),as.integer), factor(sampleTable$disease) )
# Fold changes moderated by vsn
mod_lfc = (rowMeans( exprs(vsd)[, conditions(cds)=="primary", drop=FALSE] ) - rowMeans( exprs(vsd)[, conditions(cds)=="control", drop=FALSE] ))
lfc = res$log2FoldChange
table(lfc[!is.finite(lfc)], useNA="always")
logdecade = 1 + round( log10( 1+rowMeans(counts(cdsBlind, normalized=TRUE)) ) )
lfccol = colorRampPalette( c( "gray", "blue" ) )(6)[logdecade]
ymax = 4.5
plot( pmax(-ymax, pmin(ymax, lfc)), mod_lfc, xlab = "ordinary log-ratio", ylab = "moderated log-ratio", cex=0.45, asp=1, col = lfccol, pch = ifelse(lfc<(-ymax), 60, ifelse(lfc>ymax, 62, 16)))
abline( a=0, b=1, col="red3")
# Heatmap of the counts table 
library("RColorBrewer")
library("gplots")
# select = order(rowMeans(counts(cds)), decreasing=TRUE)[1:30]
select<-resSig$id
# hmcol = colorRampPalette(brewer.pal(9, "GnBu"))(100)
hmcol<-greenred
mat<-counts(countsTable)[select,]
colnames(mat)<-sampleTable$disease
colnames(mat)<-sampleTable$antiro
dist.method<-"binary"  # "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski"
hclust.method<-"ward" # "ward", "single", "complete", "average", "mcquitty", "median" or "centroid"
pdf("test.pdf")
mat1<-t(scale(t(mat)))
heatmap.2(log2(mat), Colv = F, 
          distfun=function(x){dist(x,method=dist.method)}, 
          hclustfun=function(x){hclust(x,method=hclust.method)},
          col = hmcol, trace="none", margin=c(10, 6))
dev.off()

write.table(mat,"111.txt",sep="\t")
# Euclidean distance among samples
#dists = dist( t( exprs(vsd) ) )
#mat = as.matrix( dists )
# rownames(mat) = colnames(mat) = with(pData(cds), paste(condition, sep=" : "))

heatmap.2(mat, trace="none", col = rev(hmcol), margin=c(13, 13))
print(plotPCA(vsd, intgroup=c("condition")))

#GLM-based test for multivatiate conditions
fit1 = fitNbinomGLMs( cdsFilt, count ~ disease)
str(fit1)
pvals<-nbinomGLMTest(fit1)

matrix_apply <- function(m, f) {
  m2 <- m
  for (r in seq(nrow(m2)))
    for (c in seq(ncol(m2)))
      m2[[r, c]] <- f(r, c)
  return(m2)
}
