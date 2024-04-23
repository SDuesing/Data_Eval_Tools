#### concatenates files
concatFiles <- function(filelist, delim = delim, colnames=colnames){
    library("tidyverse")
# list of files,
# delimtiter
# colnames: boolean (TRUE/FALSE)
  for (i in 1:length(filelist)){
    tmp <- read_delim(filelist[i], delim = delim, trim_ws=T, col_names=colnames)
    if(i == 1){
      final <- tmp
    }else{
      final <- rbind(final,tmp)
    }
  }
  return(final) 
}