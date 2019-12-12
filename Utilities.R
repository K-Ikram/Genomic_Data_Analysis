#Ploidy (purple), gene mutations (yellow), under/over expressions (green)
set_Nodes_Color = function(graph) {
  
  V(graph)[length(V(graph))]$color = "purple"
  for (i in 1:(length(V(graph)) - 1)) {
    if (grepl("[A-Z]", vertex_attr(graph)$name[i])) {
      V(graph)[i]$color = "green"
    }
    else {
      V(graph)[i]$color = "gold"
    }
    
  }
  graph
}

delete_isolate_nodes= function(graph){
  isolates <- which(igraph::degree(graph, mode = 'all') == 0) 
  delete.vertices(graph, isolates)
}

plot_graph_png=function(graph, method){
 
  par(mfrow=c(1, 1))
  pic = paste(method,".png")
  png(pic, height=10, width=14, units="in", res=250)
  deg <- igraph::degree(graph, mode = "all")
  V(graph)$size = 4
  V(graph)$label.cex = .9
  V(graph)$label.color = 'black'
  V(graph)$label.font = 2
  
  E(graph)$size = .1
  
  
  e <- get.edgelist(graph,names=FALSE)
  
  l <- qgraph.layout.fruchtermanreingold(e,vcount=vcount(graph),
                                         area=8*(vcount(graph)^2),repulse.rad=(vcount(graph)^3.1))
  
  plot(graph,layout=l,vertex.size=4)
  text = paste(method,"graph", sep =" ")
  mtext(text, side=1)
  dev.off()
}

count_variable_levels=function(data){
  var_levels = c()
  for(col in colnames(data)){
    var_levels <- c(var_levels, length(unique(data[,col])))
    
  }
  var_levels
}