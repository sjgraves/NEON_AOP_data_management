# script to write hs full band files

library(sp)
library(rgdal)
library(raster)
library(rhdf5)
library(plyr)

# install package from GitHub
#install_github("lwasser/neon-aop-package")
library(neonAOP)

# read in custom function
source("scripts/functions.R")

# read in shapefile
p_full <- readOGR("../data/NEON_plot_spatial_data/NEON plot shapefiles",
                  "OSBS_tower_plot_centroids",
                  verbose = F,
                  stringsAsFactors=F)


plot_list <- c(25:44)


# loop
for(i in 2:length(plot_list)){
  
  p <- plot_list[i]
  
  if(p < 10){
    
    plot_name <- paste0("OSBS_00",p)
    
  } else {
    
    plot_name <- paste0("OSBS_0",p)
    
  }
  
  print(paste(i,plot_name,sep="---"))
  
  # 3. extract plot coordinates
  # column 3 for tower file
  # column 2 for diversity file
  plot_coords <- find_point_coordinates(p_full,plot_name,3)
  
  # 4. create extent around point
  plot_extent <- create_extent_around_point(plot_coords,40)
  
  # often data is stored in an external drive, need a pointer to this folder
  #file_folder <- "D:/NEON_AOP_downloads/OSBS_Reflectance"
  file_folder <- "D:/D03/OSBS/2014/OSBS_L1/OSBS_Spectrometer/Reflectance"
  
  # folder to save images
  # leave backslash on folder name
  save_folder <-"../data/NEON_plot_spatial_data/digitizing_images/hs_fullBands/"
  
  
  img_bands <- c(1:426)
  
  img_file_name <- paste(plot_name,"nm350_2512",sep="_")
  
  # 1. identify path
  # path is column 19 for tower file
  # path is column 11 for diversity plots
  path <- find_flight_path(p_full,plot_name,plot_column=3,
                           path_column=19)
  
  # 2. create path name
  h5_file <- create_file_path(file_folder,path)
  
  # 5. create extent object for H5 file
  h5_extent <- create_extent(h5_file)
  
  # create new extent object that can be applied in the create_stack function
  extent_to_clip <- calculate_index_extent(clipExtent = plot_extent,
                                           h5Extent = h5_extent)
  
  # 6. Create multi-band raster object
  rgbimage <- create_stack(h5_file, 
                           bands=img_bands,
                           epsg = 32617,
                           subset=T,
                           dims = extent_to_clip)
  
  plotRGB(rgbimage,
          r=48,
          g=32,
          b=20,stretch="lin")
  
  # 7. Save raster to file
  save_raster_image(raster_object = rgbimage,
                    image_type = "spectral",
                    save_folder = save_folder,
                    file_name = img_file_name, 
                    flatten = F)
  
  
}


