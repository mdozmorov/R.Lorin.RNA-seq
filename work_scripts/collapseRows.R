library(WGCNA)
mtx<-read.table("Data_Eneg_Epos.txt",sep='\t',as.is=T)
mtx<-mtx[mtx$V1 != "",] # Remove genes with blank names
datET<-as.data.frame(mtx[,-1]) # Data frame
rowGroup<-mtx$V1 # Non-unique IDs
rowID<-rownames(datET) # Corresponding unique row IDs
tmp<-collapseRows(as.matrix(mtx[,-1]),rowGroup,rowID,method="MaxMean") # MaxMean, MinMean, maxRowVariance
names(tmp)
mtx.collapsed(tmp$datETcollapsed)

