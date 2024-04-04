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

# Empty dataframe for results
result_df <- data.frame(beta_x1 = numeric(1000),beta_x2 = numeric(1000),rho = numeric(1000))

# Get access to files
setwd("XXX")
csv_files <- list.files(pattern = "*.csv")
parameter_list <- vector("list", length = length(csv_files))
# for all files in the directory
for (i in seq_along(csv_files)) {
  # read file
  data <- read.csv(csv_files[i])
  # traditional SAR models
  lagmodel <- lagsarlm(y~x1+x2, data = data, listw = wmlist, zero.policy = TRUE)
  
  beta_estimates <- list(x1 = lagmodel[["coefficients"]][["x1"]], x2 = lagmodel[["coefficients"]][["x2"]], rho = lagmodel[["rho"]][["rho"]])
  
  
  parameter_list[[i]] <- beta_estimates
  
  parameter_df <- data.frame(beta_x1 = parameter_list[[i]]$x1,beta_x2 = parameter_list[[i]]$x2,rho = parameter_list[[i]]$rho)
  result_df[i, ] <- parameter_df
}







