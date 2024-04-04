#Import libraries
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

#Maximum likelihood estimation function
#beta[1] for the first independent variable; beta[2] for the second independent variable
#beta[3] and beta[4] for spatial autocorrelation strength
likelihood <- function(parameters, data) {
  beta <- parameters[1:4]
  sigma <- parameters[5]   
  
  
  Y_pred <- data$x1 * beta[1] + data$x2 * beta[2] + data$rho1 * beta[3] + data$rho2* beta[4]
  
  
  residuals <- data$y - Y_pred
  
  
  log_likelihood <- sum(dnorm(residuals, mean = 0, sd = sigma, log = TRUE))
  
  return(-log_likelihood)  
}






# Get access to file directory
setwd("XXXXX")
# Read all .csv files
csv_files <- list.files(pattern = "*.csv")
parameter_list <- vector("list", length = length(csv_files))
# Go through all .csv files
for (i in seq_along(csv_files)) {
  # read CSV files
  data <- read.csv(csv_files[i])
  
  #calculate two SAR coefficients
  y <- data$y
  rho2 <- (wm_w) %*% (y)
  rho1 <- (wm_w) %*% (y)
  data$rho1 <- rho1
  data$rho2 <- rho2
  data$rho1[data$Category_2 == "Group1"] <- 0
  data$rho2[data$Category_2 == "Group0"] <- 0
  #start parameters with 1
  initial_parameters <- c(1, 1, 1, 1, 1)  
  #MLE for parameters
  result <- nlminb(initial_parameters, likelihood, data =data)
  
  

  beta_estimates <- result[["par"]][1:4]
  
  parameter_list[[i]] <- beta_estimates
}

# store as dataframe
parameter_matrix <- do.call(rbind, parameter_list)
parameter_df <- as.data.frame(parameter_matrix)





