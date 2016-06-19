Raw.Data <- function(Symbols,start.date){
    
  
    Data <- new.env()
    
    getSymbols(c(Symbols), from=start.date,env=Data)
    
    Returns <- eapply(Data, function(s) ROC(Ad(s), type="discrete"))
    Volume <- eapply(Data, function(s) Vo(s))
    
    ReturnsDF <<- as.data.frame(do.call(merge, na.omit(Returns)))
    VolumeDF <<- as.data.frame(do.call(merge, na.omit(Volume)))
    
    colnames(ReturnsDF) <- gsub(".Adjusted","",colnames(ReturnsDF))
    colnames(VolumeDF) <- gsub(".Adjusted","",colnames(VolumeDF))
    
    VolumeDF <<- VolumeDF[ 2:length(ReturnsDF[,1]), colSums(is.na(ReturnsDF)) == 0]
    ReturnsDF <<- ReturnsDF[2:length(ReturnsDF[,1]), colSums(is.na(ReturnsDF)) == 0]
    
    ReturnsDF <<- (ReturnsDF[-1,])
    VolumeDF <<- (VolumeDF[-1,])
    
    VolumeDF <<- VolumeDF[ , colSums(is.na(ReturnsDF)) == 0]
    ReturnsDF <<- ReturnsDF[ , colSums(is.na(ReturnsDF)) == 0]
    
    
    
  }