# Heterogeneous spatial autocorrelation model (HSAM)
Variations in spatial autocorrelation strength considered in the SAR processes.

Traditional Spatial Autoregressive (SAR) Processes: The geospatial concept is shown in the 'spatially lagged term'. The spatially lagged term is composed of: (1) spatial autocorrelation strength; (2) spatial weights matrix; and (3) a matrix of spatial variables. However, traditional SAR models assume that spatial autocorrelation strength is constant over the space, which might not be effective in modelling real-world scenarios. An improved SAR process should reflect the variation of spatial autocorrelation across the space. 

We have R codes for (1) Data generation process of SAR with a consideration of heterogeneous spatial autocorrelation; and (2) Maximum Likelihood Estimation for beta values once patterns of heterogeneous autocorrelation are captured (categorized). Change point detection (Python code) for spotting structures with heterogeneous autocorrelation strength is identical with those displayed in 'Robust Geographical Detector'. 

To be submitted to International Journal of Geographical Information Science.


