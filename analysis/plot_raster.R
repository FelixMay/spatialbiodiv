library(raster)
library(ggplot2)

rast1 <- raster("data_raw/sSBR8_rep_1_sim_1_samples_raster.grd")
plot(rast1)



rdf1 <- as.data.frame(rast1, xy = TRUE)
rdf1$layer[rdf1$layer == 2] <- 1
ggplot(rdf1, aes(x,y, fill = layer)) +
  geom_raster() +
  theme_bw()

rast2 <- raster("data_raw/sSBR8_rep_1_sim_1_sim_space_raster.grd")
plot(rast2)

rast3 <- raster("data_raw/sSBR8_rep_1_sim_2_samples_raster.grd")
plot(rast3)

rast4 <- raster("data_raw/sSBR8_rep_1_sim_2_sim_space_raster.grd")
plot(rast4)

