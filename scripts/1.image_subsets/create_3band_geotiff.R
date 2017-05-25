# create 3-band geotiff files of the complete flight path

library(rhdf5)
library(sp)
library(raster)
library(neonAOP)

h5_folder <- "D:/D03/OSBS/2014/OSBS_L1/OSBS_Spectrometer/Reflectance/"

save_folder <- "../../NEON/D03/OSBS/NEON_AOP_geotiffs/"

h5_file_paths <- list.files(h5_folder,full.names = T, pattern = "\\.h5$")
h5_file_names <- list.files(h5_folder,full.names = F, pattern = "\\.h5$")

bands3 <- c(177,53,16)
bands3_c <- paste(bands3[1],bands3[2],bands3[3],sep="_")

for(i in 1:length(h5_file_paths)){
  
  print(i)
  
  img_name <- strsplit(h5_file_names[i],"\\.")[[1]][1]
  
  t <- create_stack(h5_file_paths[i],bands = bands3, epsg = 32617, subset = F)
  
  #plot(t)
  
  writeRaster(t,paste(save_folder,img_name,"_",bands3_c,".tiff",sep=""),format="GTiff")
}

