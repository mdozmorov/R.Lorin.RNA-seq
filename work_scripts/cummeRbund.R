# http://compbio.mit.edu/cummeRbund/manual_2_0.html
library(cummeRbund)
cuff_data<-readCufflinks("../cuffdiff-/") #, rebuild=T) # ('Eneg-Epos_diff_out')
cuff_data<-readCufflinks("../cuffdiff-.75/")
cuff_data<-readCufflinks("../cuffdiff-/")
cuff_data<-readCufflinks("../cuffdiff-/")
cuff_data<-readCufflinks("../cuffdiff-/")

pdf("diags-.pdf")
disp<-dispersionPlot(genes(cuff_data)) 
disp
genes.scv<-fpkmSCVPlot(genes(cuff_data))
genes.scv
isoforms.scv<-fpkmSCVPlot(isoforms(cuff_data))
isoforms.scv
csDensity(genes(cuff_data))
csDensity(genes(cuff_data),replicates=T)
csBoxplot(genes(cuff_data))
csBoxplot(genes(cuff_data), replicates=T)
csScatter(genes(cuff_data),'CTRL','MUT') # Time consuming
csScatterMatrix(genes(cuff_data)) # Time consuming
csDendro(genes(cuff_data))
csDendro(genes(cuff_data),replicates=T)
MAplot(genes(cuff_data),'CTRL','MUT')
MAplot(genes(cuff_data),'CTRL','MUT',useCount=T)
csVolcanoMatrix(genes(cuff_data))
csVolcano(genes(cuff_data),'CTRL','MUT')
dev.off()

# Basic info
runInfo(cuff_data)
replicates(cuff_data)

# FPKM matrix
gene.rep.matrix<-repFpkmMatrix(genes(cuff_data))

write.table(merge(gene.rep.matrix,featureNames(getGenes(cuff_data,rownames(gene.rep.matrix))),by.x="row.names",by.y="tracking_id"),"gene.rep.matrix.txt",sep="\t")

# disp<-dispersionPlot(genes(cuff_data))
mygenes<-getGenes(cuff_data,c('Irf4','Stat1','Traf6','Stat3'))
mygene<-getGene(cuff_data,'Ins1')
expressionBarplot(mygene)
expressionBarplot(isoforms(mygene))
expressionPlot(mygene)
geneSimilar<-findSimilar(cuff_data,"Irf4",n=500)
write.table(merge(geneSimilar@diff,geneSimilar@annotation,by="gene_id"),"f:/111.txt",sep="\t")
expressionPlot(geneSimilar,logMode=T,showErrorbars=F)
minExpression<-1
geneSimilarFiltered<-merge(geneSimilar@diff[geneSimilar@diff$value_1>minExpression|geneSimilar@diff$value_2>minExpression,],geneSimilar@annotation, by="gene_id")
unique(geneSimilarFiltered$gene_short_name)


# http://seqanswers.com/forums/showthread.php?t=18357
#Retrive significant gene IDs (XLOC) with a pre-specified alpha
# Returns the identifiers of significant genes in a vector format. level may be TSS, CDS
diffGeneIDs<-getSig(cuff_data,"CTRL","MUT",alpha=0.5,level='genes') 
diffGeneIDs<-sig_gene_data$gene_id # Get gene_id from filtered data
#Use returned identifiers to create a CuffGeneSet object with all relevant info for given genes
diffGenes<-getGenes(cuff_data,diffGeneIDs)
# head(fpkm(diffGenes))
# head(fpkmMatrix(diffGenes))
csHeatmap(diffGenes,clustering="both",heatscale=c(low="blue", mid="white", high="red"))
csScatter(diffGenes,"Eneg","Epos",smooth=T,drawRug=F)
csVolcano(diffGenes,"Eneg","Epos",features)
ic<-csCluster(diffGenes,k=4)

head(features(diffGenes)) # Gene_id, gene_short_name, locus
#gene_short_name values (and corresponding XLOC_* values) can be retrieved from the CuffGeneSet by using:
names<-featureNames(diffGenes) # gene_short_name retrieval
# get the data for the significant genes??
diffGenesData<-diffData(diffGenes,features=T)
dataOut<-merge(names,diffGenesData,by.x="tracking_id",by.y="gene_id")
# write.table(dataOut,"DEG-Eneg_vs_Epos.txt",sep="\t",row.names=F,quote=F)
# further filter so in at least one condition we have high expression
tmp<-apply(cbind(dataOut$value_1,dataOut$value_2),1,max)
tmpDataOut<-dataOut[tmp>3,] # Expressed in at least one condition > 3
write.table(tmpDataOut,"DEG-Eneg_vs_Epos_filtered.txt",sep="\t",row.names=F,quote=F)


# As in the manual
gene_diff_data <- diffData(genes(cuff_data),"CTRL","MUT",features=T)
sig_gene_data <- subset(gene_diff_data, (significant == 'yes')) # Get significant only
sig_gene_data <- subset(gene_diff_data, (p_value < 0.05))
nrow(sig_gene_data)
sig_gene_data<-subset(sig_gene_data,abs(log2_fold_change)>log2(1.5)) # With 2-fold cutoff
nrow(sig_gene_data)
sig_gene_data<-sig_gene_data[sig_gene_data$value_1>3|sig_gene_data$value_2>3,] # and expression >3 in at least one condition
nrow(sig_gene_data)
# sig_gene_names<- featureNames(sig_gene_data)
write.table(merge(sig_gene_data,featureNames(getGenes(cuff_data,sig_gene_data$gene_id)),by.x="gene_id",by.y="tracking_id"),"F:/222.txt",sep="\t",row.names=F)

promoter_diff_data<-distValues(promoters(cuff_data),"Eneg","Epos")
head(promoter_diff_data)
sig_promoter_data<-subset(promoter_diff_data,significant=='yes')
nrow(sig_promoter_data)
head(sig_promoter_data)
sig_promoter_annot<-features(getGenes(cuff_data,sig_promoter_data$gene_id))
head(merge(sig_promoter_data,sig_promoter_annot,by="gene_id"))                          

# http://seqanswers.com/forums/archive/index.php/t-18893.html
# Full matrix and PCA
allGenesFPKMs<-fpkmMatrix(genes(cuff_data))
boxplot(allGenesFPKMs,ylim=c(0,20))
genes.pca<-prcomp(allGenesFPKMs)
biplot(genes.pca) # Interpreting biplot, p115. http://www.itc.nl/~rossiter/teach/R/R_mhw.pdf


gene.features<-annotation(genes(cuff_data))


mtx.fpkm<-merge(allGenesFPKMs,gene.features,by.x="row.names",by.y="gene_id")
write.table(mtx.fpkm,"FPKM_matrix.txt",sep="\t")

# Get subsets
query<-readLines("clipboard")
mtx.fpkm.s<-mtx.fpkm[mtx.fpkm$gene_short_name %in% query,]
write.table(mtx.fpkm.s,"clipboard-128",sep="\t",row.names=F)
hist(apply(mtx.fpkm.s[,2:4],1,sd),breaks=100,xlim=c(0,50)) # Lool at SD distribution
library(gplots)
mtx.fpkm.s1<-mtx.fpkm.s[apply(mtx.fpkm.s[,2:4],1,sd) > 20,]
mtx.fpkm.s1<-mtx.fpkm.s1[mtx.fpkm.s1$gene_short_name != "Fth1",]
heatmap.2(as.matrix(mtx.fpkm.s1[2:4]),ColV=F,col=greenred(50),density.info="none",trace="none",labRow=mtx.fpkm.s1$gene_short_name,labCol=colnames(mtx.fpkm.s)[2:4])
 write.table(mtx.fpkm.s1,"clipboard-128",sep="\t",row.names=F)


# Extract genomic coordinates from a list of XLOC IDs
myGeneIDs<-readLines("clipboard") # Get IDs
myGenes<-getGenes(cuff_data,myGeneIDs) # Get gene information
write.table(myGenes@annotation[,c("gene_id","gene_short_name","locus")],"clipboard-128",sep="\t",col.names=T,row.names=F) # Extract necessary columns into clipboard

