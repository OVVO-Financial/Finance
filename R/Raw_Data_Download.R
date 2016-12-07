Raw.Data <- function(Symbols,start.date=Sys.Date()-500,end.date=Sys.Date()){
    
  
    Data <- new.env()
    
    getSymbols(c(Symbols), from=start.date, to=end.date,env=Data)
    
### Generate both data.frames for returns and volume
    Returns <- eapply(Data, function(s) ROC(Ad(s), type="discrete"))
    Volume <- eapply(Data, function(s) Vo(s))
    
    ReturnsDF <- as.data.frame(do.call(merge, (Returns)))
    VolumeDF <- as.data.frame(do.call(merge, (Volume)))
    
### Name columns of data.frame      
    colnames(ReturnsDF) <- gsub(".Adjusted","",colnames(ReturnsDF))
    colnames(VolumeDF) <- gsub(".Adjusted","",colnames(ReturnsDF))
    
### Eliminates securities without complete return series
    VolumeDF <- VolumeDF[,colSums(is.na(ReturnsDF))<2]
    ReturnsDF <- ReturnsDF[,colSums(is.na(ReturnsDF))<2]
    
### First row of differences generated NA, need to eliminate    
    ReturnsDF <- (ReturnsDF[-1,])
    VolumeDF <- (VolumeDF[-1,])
    
### Stochastic Dominance Filter
    if(is.null(sd.degree)){
        ReturnsDF <<-ReturnsDF
        VolumeDF <<- VolumeDF}else{
            sd.names <- names(NNS.SD.Efficient.Set(ReturnsDF,sd.degree))
            if(is.null(sd.names)){
                sd.names=colnames(ReturnsDF)}else{sd.names=sd.names}
            ReturnsDF <- ReturnsDF[,c(sd.names)]
            VolumeDF <- VolumeDF[,c(names(ReturnsDF))]
            ReturnsDF <<- ReturnsDF
            VolumeDF <<- VolumeDF
            }
}