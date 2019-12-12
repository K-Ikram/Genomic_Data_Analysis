#Authors : Ikram KAROUCHE & Majda OULAARBI
#*********************** Network reconstruction with the PC approach **************************

library(miic)
library(bnlearn)
source("Utilities.R")
#Install the package pcalg
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("pcalg")

BiocManager::install ("Rgraphviz")

library(pcalg)

#1 - Loading of the cosmicCancer dataset from miic package
data("cosmicCancer")


#2 - Remove NA values
cosmicCancer = cosmicCancer[complete.cases(cosmicCancer), ] # omit the rows that contain Na values.

#Convert Ploidy to factor
cosmicCancer[, 'Ploidy'] = as.factor(cosmicCancer[, 'Ploidy'])

#1 - Omit the variables with 1 level
cosmicCancer = cosmicCancer[, sapply(cosmicCancer, function(col)
  length(unique(col))) > 1]

#3 - Convert the dataset to numeric using data.matrix
cosmicCancer = data.matrix(cosmicCancer)

#4 - Make the categories start from 0.
cosmicCancer = cosmicCancer - 1

#5 - Count number of variable levels
var_levels = count_variable_levels(cosmicCancer)

#6 - Prepare suffstat object
suffStat <-
  list(dm = cosmicCancer, nlev = var_levels, adaptDF = FALSE)

# Reconstruct the graph using the PC approach
res.pc = pc(
  suffStat,
  indepTest = disCItest,
  alpha = 0.01,
  labels = colnames(cosmicCancer)
)

#Convert pc network to bn object
res.pcTobn = as.bn(res.pc, check.cycles = FALSE)

#Convert bn to igraph
res.pc.igraph = igraph.from.graphNEL(as.graphNEL(res.pcTobn))


#Delete vertices with degree = 0
res.pc.igraph = delete_isolate_nodes(res.pc.igraph)

#Set different colors to nodes { mutated genes : gold, over/under expressed genes : blue, Ploidy: purple }
res.pc.igraph = set_Nodes_Color(res.pc.igraph)


#Save the pc graph in a png picture
dev = plot_graph_png(res.pc.igraph, "PC")
