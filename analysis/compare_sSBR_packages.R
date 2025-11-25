# compare different spexSBR functions
# from mobr and from spatialbiodiv

library(mobr)
library(scam)

# mobr
data(inv_comm)
data(inv_plot_attr)

inv_mob_in = make_mob_in(inv_comm, inv_plot_attr, coord_names = c('x', 'y'))

sbr1 <- rarefaction(inv_mob_in, method = "spexSBR")

plot(names(sbr1), sbr1, type = "b", col = "red")

# spatialbiodiv
library(spatialbiodiv)
sbr2 <- sSBR(inv_comm, xy_coords = inv_plot_attr[,c("x","y")])
sbr2a <- sbr2$sSBR_smooth

lines(S ~ distance, data = sbr2a, col = "blue", lwd = 3)
