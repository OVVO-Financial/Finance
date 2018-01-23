VN.Utility <- function (n,q,required.return,x,upside.target=NULL,downside.target=NULL){

  if(required.return<0){stop("You have a negative required return...Really?!?  Please set to a minimum of 0.")}
  
  if(min(x)>0 & required.return<1){stop("You have a negative required return...Really?!?  Please set to a minimum of 1.")}
  
  if(!is.null(downside.target)){
    if(downside.target> required.return){stop("You have a downside target greater than your required return...Really?!?  Please set downside target to below the required return.")}
  }
    
  #These can be adjusted, but objectively the expected upside and downside would be the conditional mean of each.
  if(is.null(upside.target)){upside.target <- mean(x[x>required.return])}
  if(is.null(downside.target)){downside.target <- mean(x[x<required.return])}

  if((upside.target-required.return)>abs(required.return-downside.target)){
  U0.p = ((downside.target-required.return)+(upside.target-required.return))^q
  U0.n = 0
  } else {
    U0.p = 0
    U0.n =((downside.target-required.return)+(upside.target-required.return))^n
  }

  #Expected Utility of each of the target benchmarks.
  ifelse(downside.target<0,
         downside.target.utility <- (downside.target - required.return)^n,
         downside.target.utility <- (required.return - downside.target)^n)

  upside.target.utility <- (upside.target - required.return)^q



#Definition of the output
  ## For x < downside target, negative utility of downside target less deviation (CONCAVE)
  condition.1 <- x[x<=downside.target & x<=required.return]
  output.1 <- -downside.target.utility - (downside.target - condition.1)^n - U0.n

  ## For positive instances of x < downside target.
  condition.2 <- x[x<=downside.target & x>required.return]
  output.2 <- -downside.target.utility - (downside.target - condition.2)^n - U0.n

  ## For x > downside target but less than required return, negative utility of downside target plus upside deviation (CONVEX)
  condition.3 <- x[x>downside.target & x<=required.return]
  output.3<- -downside.target.utility + (condition.3 - downside.target)^n - U0.n


  ## For x < upside target but greater than required return, positive utility of upside target less downside deviation (CONCAVE)
  condition.4 <- x[x<=upside.target & x>required.return]
  output.4 <- upside.target.utility - (upside.target - condition.4)^q + U0.p
  
  ## For x > upside target & greater than required return, positive utility of upside target plus upside deviation (CONVEX)
  condition.5 <- x[x>upside.target & x>required.return]
  output.5 <- upside.target.utility + (condition.5 - upside.target)^q + U0.p


  output=c(output.1,output.2,output.3,output.4,output.5)

  sorted.output = sort(output, decreasing = FALSE)
  
  min.xlab=min(c(x,upside.target,downside.target))
  max.xlab=max(abs(c(x,upside.target,downside.target)))
  
  range=max(c((required.return-min.xlab),(max.xlab-required.return)))

  plot(sort(x),sorted.output,pch=19,
       ylim=c(-max(abs(sorted.output)),max(abs(sorted.output))),
       xlim=c(min.xlab,max.xlab),
       col=ifelse(sorted.output<0 & sort(x)<downside.target,'red',
          ifelse(sorted.output<0 & sort(x)>downside.target,'pink',
          ifelse(sorted.output>0 & sort(x)<upside.target,'lightgreen','darkgreen'))),  
       main="Viole-Nawrocki UPM/LPM Utility",
       xlab="Security Returns",ylab="UTILITY")

  abline(h=0, v=which(sorted.output==downside.target)[1], col=c('black','red'))
  abline(v = upside.target,col='green')
  abline(v = downside.target,col='red')
  abline(v = required.return,lty=3)
  text(downside.target,max(output),"Downside Target",pos=3,col='red')
  text(upside.target,min(output),"Upside Target",pos=3,col='green')
  mtext("Required Return", side = 3,col = "black",at=required.return)
  
  return(sum(output))

}
