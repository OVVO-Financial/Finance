Raw.Data <- function(Symbols,start.date,end.date){
    
  
    Data <- new.env()
    
    getSymbols(c(Symbols), from=start.date,to=end.date,env=Data)
    
    Returns <- eapply(Data, function(s) ROC(Ad(s), type="discrete"))
    Volume <- eapply(Data, function(s) Vo(s))
    
    ReturnsDF <<- as.data.frame(do.call(merge, na.omit(Returns)))
    VolumeDF <<- as.data.frame(do.call(merge, na.omit(Volume)))
    
    colnames(ReturnsDF) <- gsub(".Adjusted","",colnames(ReturnsDF))
    colnames(VolumeDF) <- gsub(".Adjusted","",colnames(VolumeDF))
    
### Eliminates securities without complete return series
    ReturnsDF <- ReturnsDF[,colSums(is.na(ReturnsDF))<2]
    VolumeDF <- VolumeDF[,colSums(is.na(ReturnsDF))<2]
    
### First row of differences generated NA, need to eliminate
    ReturnsDF <<- (ReturnsDF[-1,])
    VolumeDF <<- (VolumeDF[-1,])
    
    
    
  }
