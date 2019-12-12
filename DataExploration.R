#cosmicCancer.active =cosmicCancer[,1:175] # omit Ploidy variable (integer) in order to be able to do an MCA.
# 
# #Remove Outliers from data (https://link.springer.com/article/10.1007/s11047-015-9489-2)
#freq_matrix <- table( unlist( unname(cosmicCancer.active) ) )
#cosmicCancer.active[,"Score"] <- apply(cosmicCancer.active ,1, function(x) {sum(freq_matrix[x]/length(x) )}) # Do the sum, paste with number of cols (should be computed outside to avoid cache miss)
#outliers = boxplot(cosmicCancer.active[,"Score"])$out
#clean_data = subset(cosmicCancer.active, !(Score %in% outliers))[,1:175]
# 
# # omit col esm1 because it has one level (doesnt influence the study)
# drops <- c("esm1","ebf4","qscn6l1","cenpa","kntc2")
# clean_data= clean_data[ , !(names(clean_data) %in% drops)]
# 
# 
# 
# # MCA
# for (i in 1:ncol(clean_data)) {
#   plot(cosmicCancer[,i], main=colnames(cosmicCancer)[i],
#        ylab = "Count", col="steelblue", las = 2)
# }
# res.mca <- MCA(clean_data,  graph = TRUE)
# print(res.mca)
# 
# eig.val <- get_eigenvalue(res.mca)
# 
# fviz_screeplot(res.mca, addlabels = TRUE, ylim = c(0, 20))
# fviz_mca_biplot(res.mca, 
#                 repel = TRUE, # Avoid text overlapping (slow if many point)
#                 ggtheme = theme_minimal())
# var <- get_mca_var(res.mca)
# head(var$cos2)
# plot(res.mca)
# head(var$contrib)
# 
# fviz_mca_var(res.mca, choice = "mca.cor", 
#              repel = TRUE, # Avoid text overlapping (slow)
#              ggtheme = theme_minimal())
# 
# fviz_mca_ind(res.mca, select.var = list(cos2 = 0.4))
# fviz_mca_var(res.mca, col.var = "contrib")+
# scale_color_gradient2(low = "white", mid = "blue",
#                         high = "red", midpoint = 2) +
# theme_minimal()
# 
# #dck aurka Cenpa foxm1
# fviz_mca_var(res.mca, select.var = list(cos2 = 0.4))
# 
# fviz_mca_var(res.mca, select.var = list(contrib = 10))
# 
# #Contribution Outliers
# 
# boxplot(contrib[,c('Score')])$out
# 
# pairs.panels(contrib, stars = TRUE)
# outlier(contrib)
# md <- mahalanobis(contrib, center = colMeans(contrib), cov = cov(contrib))
# alpha <- .001
# cutoff <- (qchisq(p = 1 - alpha, df = ncol(contrib)))
# names_outliers_MH <- which(md > cutoff)
# excluded_mh <- names_outliers_MH
# res.mca$var$contrib <- contrib[-excluded_mh, ]
# contrib[excluded_mh, ]
# 
# # cos 2 outliers
# cos2 = res.mca$var$cos2
# pairs.panels(cos2, stars = TRUE)
# outlier(cos2)
# md <- mahalanobis(cos2, center = colMeans(cos2), cov = cov(cos2))
# alpha <- .01
# cutoff <- (qchisq(p = 1 - alpha, df = ncol(cos2)))
# names_outliers_MH <- which(md > cutoff)
# excluded_mh <- names_outliers_MH
# res.mca$var$cos2 <- cos2[-excluded_mh, ]
# cos2[excluded_mh, ]

