coords1 <- data.frame(x = c(0,4,4),
                      y = c(3,3,0))
plot(y~x, data = coords1)
m1 <- as.matrix(dist(coords1))

# kNN

data(inv_comm)
data("inv_plot_attr")

inv_comm2 <- inv_comm[1:10,]

# The original coords are along a line, which is not that useful
coords_test <- data.frame(x = runif(nrow(inv_comm2),0,10),
                          y = runif(nrow(inv_comm2),0,10)
                          )
plot(y ~ x, data = coords_test)

#rarefaction(inv_comm2, coords = coords1, method = "spexSBR",
#            latlong = F)


#inv_mob_in = make_mob_in(inv_comm, inv_plot_attr, coord_names = c('x', 'y'))

sbr1 <- rarefaction(inv_comm2, method = "spexSBR", spat_algo = "kNN",
                    coords = coords_test, latlong = F)
sbr2 <- rarefaction(inv_comm2, method = "spexSBR", spat_algo = "convexhull",
                       coords = coords_test, latlong = F)

plot(sbr1 ~ names(sbr1), type = "l", col = "red", ylim = c(0,50), xlim = c(0,35))
lines(sbr2 ~ names(sbr2), col = "blue")
