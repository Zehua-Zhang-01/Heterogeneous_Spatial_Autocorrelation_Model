# Import libraries
library(spatialreg)
library(spdep)
#Prepare simulation studies: 10x10 grids and get spatial weight matrix
n_rows <- 10
n_cols <- 10
grid <- st_make_grid(st_bbox(c(xmin = 0, ymin = 0, xmax = n_cols, ymax = n_rows)), cellsize = 1)
grid_polygons <- st_as_sf(grid)
grid_polygons$ID <- seq_len(nrow(grid_polygons))
w <- poly2nb(grid_polygons, queen = TRUE)
wm_w <- nb2mat(w, sty = 'W')
wmlist <- nb2listw(w,style = 'W')

# The directory where you wanna simulation data to be stored
setwd('XXXX')
# set different seed for different simulations
seeds <- 1:1000
for (seed in seeds) {
  
  set.seed(seed)
  # set the spatial autocorrelation matrix  - assume weak autocorrelation globally
  matrix <- diag(0.1, 100, 100)
  # in some areas, spatial autocorrelation strength is very strong
  # change the position values to represent different patterns
  positions <- c(21,22,23,24,25,26,27,28,29,30)
  higher_values <- rep(0.7, length(positions))
  diag(matrix)[positions] <- higher_values
  a <- diag(100)
  # set independent variables and the error
  x1 <- runif(n = 100, min = 4, max = 8) 
  x2 <- runif(n = 100, min = 4, max = 8)
  error <- rnorm(100,0,0.5)
  # generate the dependent variable via SAR processes
  y = solve(a-matrix%*%wm_w)%*%(x1+x2+error)
  df <- data.frame(y,x1,x2,error)
  lagmodel <- lagsarlm(y~x1+x2, data = df, listw = wmlist, zero.policy = TRUE)
  # calculate residuals from traditional SAR models
  df$resi <- lagmodel$residuals
  
  file_name <- paste0("data_seed_", seed, ".csv")
  
  write.csv(df, file_name)
}