# script to write camera data to geotiff files


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

# diversity
#plot_list <- c(1:24,48:51)

# tower
plot_list <- c(25:44)


# loop
for(i in 1:length(plot_list)){
  
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
  file_folder <- "D:/D03/OSBS/2014/OSBS_L3/OSBS_Camera/"
  
  # folder to save images
  # leave backslash on folder name
  save_folder <-"../data/NEON_plot_spatial_data/digitizing_images/camera/"
  
  img_file_name <- paste(plot_name,"camera",sep="_")
  
  rgb_clip <- create_RGB_clip(plot_coords = plot_coords,
                              source_folder = file_folder)
  
  plotRGB(rgb_clip,stretch="lin")
  
  # use custom function to save the image
  save_raster_image(rgb_clip,
                    image_type="camera",
                    save_folder = save_folder,
                    file_name = img_file_name,
                    flatten = F,
                    img_res = 0.25)
  

}



