# https://chitchatr.wordpress.com/2015/01/23/calculating-the-area-of-a-convex-hull/

# convex hull calculation

box.coords <- matrix(c(1, 1,
                       4, 1,
                       1, 4,
                       4, 4), nrow = 4, ncol = 2, byrow = T)

# box.coords <- matrix(c(1, 1,
#                        4, 1), nrow = 2, ncol = 2, byrow = T)
plot(box.coords[,1], box.coords[,2], pch = 20)

box.hpts <- chull(x = box.coords[,1], y = box.coords[,2])
box.hpts <- c(box.hpts, box.hpts[1])
box.chull.coords <- box.coords[box.hpts,]

# library(sp)
#
# chull.poly <- Polygon(box.chull.coords, hole=F)
# chull.area <- chull.poly@area



library(sf)
chull.poly <- st_polygon(list(box.chull.coords))
chull.area <- st_area(chull.poly)


