#Authors : Ikram KAROUCHE & Majda OULAARBI
#*********************** Network reconstruction with the MIIC approach **************************
library(bnlearn)
library(miic)
library(igraph)
library(qgraph)
source("Utilities.R")


#1 - Loading of the cosmicCancer dataset from miic package
data("cosmicCancer")


# Execute MIIC to reconstruct the graph
res.miic = miic(
  inputData = cosmicCancer,
  latent = TRUE,
  confidenceShuffle = 10,
  confidenceThreshold = 0.001
)

#Format adjenceny matrix of miic object in order to convert it to an igraph object
for (i in 1:dim(res.miic$adjMatrix)[1])
{
  for (j in 1:dim(res.miic$adjMatrix)[2])
  {
    if (res.miic$adjMatrix[i, j] %in%  c(2, -2, 6)) {
      res.miic$adjMatrix[i, j] = 1
    }
  }
}

#Convert miic to igraph with adjency matrix
res.miic.igraph = graph_from_adjacency_matrix(res.miic$adjMatrix, diag = FALSE, mode = "undirected")

#Delete vertices with degree = 0
res.miic.igraph = delete_isolate_nodes(res.miic.igraph)

#Set different colors to nodes { mutated genes : gold, over/under expressed genes : blue, Ploidy: purple }
res.miic.igraph = set_Nodes_Color(res.miic.igraph)
dev.off()

#Save the pc graph in a png picture
plot_graph_png(res.miic.igraph, "MIIC")