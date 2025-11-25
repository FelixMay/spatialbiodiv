

# get_sSBR_dist <- function
# input: sample_with_coordinates_1, sample_with_coordinates_2,
# output: differenz between two sSBR curves (dependent on distance of course)

# ToDo in function body:
# - calculate distances for sSBR evaluation
# - calculate sSBR1
# - calculate sSBR2
# - calculate difference

#' Calculate the scale-dependent difference between two spatially-explicit
#' rarefaction curves
#'
#' @param comm1
#' @param coords1
#' @param comm2
#' @param coords2
#' @param spat_effort
#'
#' @return
#' @export
#'
#' @examples
get_spexSBR_dist <- function(comm1, coords1, comm2, coords2, spat_effort)
{
  spexSBR1 <- mobr::rarefaction(comm1, method = "spexSBR", effort = spat_effort,
                                coords = coords1, latlong = F,
                                spat_algo = "convexhull")

  spexSBR2 <- mobr::rarefaction(comm2, method = "spexSBR", effort = spat_effort,
                                coords = coords2, latlong = F,
                                spat_algo = "convexhull")
  delta_spexSBR <- spexSBR1 - spexSBR2

  out_dat <- data.frame(spatial_effort = unname(spat_effort),
                        delta          = unname(delta_spexSBR))

  return(out_dat)
}


# ------------------------------------------------------------------------------
# get_null_interval <- function()
# input: sample_with_coordinates_1, sample_with_coordinates_2
# output: upper and lower interval for null expectation that the two sSBR curves and
# observed difference
# do not differ

# Body
# choose number of permutation N
# Create big table OUT that will include all permutation: N rows, as many columns as distances in sSBR
# combine both data sets (with rbind or similar)
# for i in 1:N {
# permute labels between the two studies
# call get_sSBR_dist
# save distance in OUT
# }
# get 2.5% and 97.5% quantiles from every column of OUT

#' Get distance and confidence interval between spatially-explicit rarefaction curves
#'
#' @param comm1
#' @param coords1
#' @param comm2
#' @param coords2
#' @param spat_effort
#' @param nperm
#'
#' @return
#' @export
#'
#' @examples
get_spexSBR_interval <- function(comm1, coords1, comm2, coords2, spat_effort, nperm)
{
  # Reminder check if both communities have the same number of species
  nspec <- ncol(comm1)
  nsample <- nrow(comm1)

  delta_perm <- matrix(NA, nrow = nperm, ncol = length(spat_effort))

  # difference between observed spexSBR curves
  delta_obs <- get_spexSBR_dist(comm1, coords1, comm2, coords2, spat_effort)
  delta_obs <- delta_obs$delta

  # put both datasets together
  dat1 <- dplyr::bind_cols(coords1, comm1)
  dat2 <- dplyr::bind_cols(coords2, comm2)
  dat1$frag <- "frag1"
  dat2$frag <- "frag2"

  dat_all <- bind_rows(dat1, dat2)

  for(i in 1:nperm) {
    print(i)

    # permute fragmentation label
    dat_all$frag_perm <- sample(dat_all$frag, replace = FALSE)

    # split datasets
    fragA <- dat_all %>% filter(frag_perm == "frag1")
    fragB <- dat_all %>% filter(frag_perm == "frag2")

    coordsA <- fragA[,1:2]
    commA <- fragA[,3:(nspec+3)]

    coordsB <- fragB[,1:2]
    commB <- fragB[,3:(nspec+3)]

    # Get distance between permuted data sets
    delta_i <- get_spexSBR_dist(commA, coordsA, commB, coordsB, spat_effort)
    delta_perm[i,] <- delta_i$delta
  }

  out <- data.frame(spatial_effort = spat_effort,
                    obs            = delta_obs,
                    lower          = apply(delta_perm, 2, quantile, probs = 0.025),
                    upper          = apply(delta_perm, 2, quantile, probs = 0.975))
  return(out)
}
