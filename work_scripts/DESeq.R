# http://davetang.org/muse/2011/01/05/deseq-vs-edger-vs-bayseq/

source("http://www.bioconductor.org/biocLite.R")
biocLite("baySeq")
biocLite("DESeq")
biocLite("edgeR")
biocLite("goseq")

library(Biobase)
library(DESeq)
sampleTable<-read.table("gene.rep.matrix.txt",sep="\t",header=T,row.names=1) # All vs. All
rownames(sampleTable)<-sampleTable[,1] # Reassign row names
sampleTable<-sampleTable[,-1] # Remove first column with row names
library("arrayQualityMetrics")
arrayQualityMetrics(new("ExpressionSet",exprs=as.matrix(sampleTable[,-9])),outdir="arrayQualityMetrics") # Need to remove last column with refseq ids
IAC<-cor(sampleTable[apply(sampleTable[,-9],1,mean) > quantile(unlist(sampleTable[,-9]))[[4]],-9]) # correlations of values in the upper 75% of expression range
library(cluster)
cluster<-hclust(as.dist(1-IAC), method="average")
plot(cluster, cex=0.7, labels=dimnames(sampleTable[,-9])[[2]])
IAC<-cor(sampleTable[apply(sampleTable[,c(-3,-5,-9)],1,mean) > quantile(unlist(sampleTable[,c(-3,-5,-9)]))[[4]],c(-3,-5,-9)]) # CTRL_2 - 3rd column, MUT_0 - 5th column
cluster<-hclust(as.dist(1-IAC), method="average")
plot(cluster, cex=0.7, labels=dimnames(sampleTable[,c(-3,-5,-9)])[[2]])

sampleCountTable<-sampleTable[,c(-3,-5,-9)] # Count table to use
sampleDesign<-data.frame(row.names = colnames(sampleCountTable),
                         condition=c(rep("CTRL",3),rep("MUT",3)),
                         replicate=c(1,2,3,1,2,3))
cds<-newCountDataSet(sampleCountTable,sampleDesign$condition)

sampleTable<-read.table("sampleTableCtrl_vs_ROpos1.txt",sep="\t",header=T) # Ctrl vs. AntiRoPos, sampleTableCtrl_vs_R)pos.txt is wrong
sampleTable<-read.table("sampleTableCtrl_vs_ROneg.txt",sep="\t",header=T) # Ctrl vs. AntiRoNeg
sampleTable<-read.table("sampleTableROneg_vs_ROpos.txt",sep="\t",header=T) # AntiRoNeg vs. AntiRoPos

countsTable<-newCountDataSetFromHTSeqCount(sampleTable,"htseq-ensembl/") # HTSeq data
# Optional: average values
# countsAverage<-cbind(rowMeans(counts(countsTable)[,sampleTable$disease == "control"]),
#                               rowMeans(counts(countsTable)[,sampleTable$disease == "Negative"]))
# colnames(countsAverage)<-c("control","Negative")
# rownames(countsAverage)<-rownames(counts(countsTable))
cds<-countsTable # Full dataset
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
resSig <- subset(res, padj<0.1 & abs(log2FoldChange) > log2(2)) # & baseMean>3) # Excludes rows with NAs
dim(resSig)
head( resSig[ order(resSig$pval), ] )
head( resSig[ order( resSig$foldChange, -resSig$baseMean ), ] ) # Most strongly downregulated
head( resSig[ order( -resSig$foldChange, -resSig$baseMean ), ] ) # Most strongly upregulated
write.table(resSig,"clipboard-128",sep="\t")
write.table(resSig,"F:/111.txt",sep="\t")
library(biomaRt)
mart<-useMart("ensembl", dataset="mmusculus_gene_ensembl")
genes<-getBM(attributes=c('ensembl_gene_id','external_gene_id','description'), 
             filters='ensembl_gene_id', values=resSig$id, mart=mart)#, uniqueRows=T)
write.table(genes,"clipboard-128",sep="\t")
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
supportedGenomes()[1,]
assayed.genes<-rownames(counts(cds)) # All gene IDs
de.genes<-rep(0,length(rownames(counts(cds)))) # Vector of zeros
# de.genes from samr
de.genes[as.numeric(c(samfit$siggenes.table$genes.up[,2], samfit$siggenes.table$genes.lo[,2]))]<-1 # Set to 1 which are DEGs
# de.genes from clipboard of ensIDs
de.genes<-readLines("clipboard")

gene.vector=as.integer(assayed.genes%in%de.genes)
names(gene.vector)=assayed.genes
# head(gene.vector)
pwf=nullp(gene.vector,"hg19","ensGene")
GO.wall=goseq(pwf,"hg19","ensGene")
# head(GO.wall)
# GO.samp=goseq(pwf,"hg19","ensGene",method="Sampling",repcnt=1000)
# head(GO.samp)
enriched.GO=GO.wall$category[p.adjust(GO.wall$over_represented_pvalue,method="BH")<.05]
head(enriched.GO)
library(GO.db)
for(go in enriched.GO[1:10]){
  print(GOTERM[[go]])
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
