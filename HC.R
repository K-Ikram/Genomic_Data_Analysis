#Authors : Ikram KAROUCHE & Majda OULAARBI
#*********************** Network reconstruction with the hill-climbing approach **************************
library(igraph)
library(qgraph)
library(bnlearn)
library(miic)
source("Utilities.R")

#1 - Loading of the cosmicCancer dataset from miic package
data("cosmicCancer")

#2- Convert cosmicCancer to dataframe
cosmicCancer=as.data.frame(cosmicCancer)

#2.a- Omit Na values from dataset 

countNan = sum(is.na(cosmicCancer))
nrow(cosmicCancer[!complete.cases(cosmicCancer),])/nrow(cosmicCancer) #0.991% of data to omit
# The concerned Variable is Ploidy
cosmicCancer = cosmicCancer[complete.cases(cosmicCancer),] # omit the rows that contain Na values.


#2.b- Convert Ploidy variable to Factor
cosmicCancer[,'Ploidy']=as.factor(cosmicCancer[,'Ploidy'])

#2.c - Omit variables with 1 level from the dataset
ncol(cosmicCancer [, sapply(cosmicCancer, nlevels) == 1]) #13 variables with 1 level
cosmicCancer= cosmicCancer [, sapply(cosmicCancer, nlevels) > 1]

#Construct a network with hc from bnlearn
res.hc = hc(cosmicCancer)

#Convert hc network to igraph 
res.hc.igraph= igraph::igraph.from.graphNEL(as.graphNEL(res.hc))


#Delete vertices with degree = 0
res.hc.igraph=delete_isolate_nodes(res.hc.igraph)

#Set different colors to nodes
res.hc.igraph = set_Nodes_Color(res.hc.igraph)

#Save the graph in a png picture
dev=plot_graph_png(res.hc.igraph,"HC")


#betweenness

res.hc.betweenness = data.frame()
res.hc.betweenness$edg1 = as.data.frame(e[,1])
res.hc.betweenness$edg2 = e[,2]
head(res.hc.betweenness[,3])
res.hc.betweenness= cbind(res.hc.betweenness, edge.betweenness(res.hc.igraph))
res.hc.betweenness[res.hc.betweenness[order(res.hc.betweenness[,3]),]]

                   