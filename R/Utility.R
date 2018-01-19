VN.Utility <- function (n,q,required.return,x,upside.target=NULL,downside.target=NULL){


  #These can be adjusted, but objectively the expected upside and downside would be the conditional mean of each.
  if(is.null(upside.target)){upside.target <- mean(x[x>required.return])}
  if(is.null(downside.target)){downside.target <- mean(x[x<required.return])}


  #Expected Utility of each of the target benchmarks.
  ifelse(downside.target<required.return,
         downside.target.utility <- (required.return + abs(downside.target))^n,
         downside.target.utility <- (required.return - downside.target)^n)

  upside.target.utility <- (upside.target - required.return)^q


#Definition of the output
  ## For x < downside target, negative utility of downside target less deviation (CONCAVE)
  condition.1 <- x[x<=downside.target&x<=required.return&x<=required.return]
  output.1 <- -downside.target.utility - (abs(condition.1) - abs(downside.target))^n
  ## For positive instances of x < downside target.
  condition.2 <- x[x<=downside.target&x<=required.return&x>required.return]
  output.2 <- -downside.target.utility - (abs(downside.target) - abs(condition.2))^n
  ## For x > downside target but less than required return, negative utility of downside target plus upside deviation (CONVEX)
  condition.3 <- x[x>downside.target&x<=required.return&x<=required.return]
  output.3<- -downside.target.utility + (abs(abs(downside.target) - abs(condition.3) ))^n
  ## For positive instances of x below its required return.
  condition.4 <- x[x>downside.target&x<=required.return&x>required.return]
  output.4<- -downside.target.utility + (abs(condition.4 - abs(downside.target)))^n
  ## For x < upside target but greater than required return, positive utility of upside target less downside deviation (CONCAVE)
  condition.5 <- x[x<=upside.target&x>required.return]
  output.5 <- upside.target.utility - (upside.target - condition.5)^q
  ## For x > upside target & greater than required return, positive utility of upside target plus upside deviation (CONVEX)
  condition.6 <- x[x>upside.target&x>required.return]
  output.6 <- upside.target.utility + (condition.6 - upside.target)^q


  output=c(output.1,output.2,output.3,output.4,output.5,output.6)

  sorted.output = sort(output, decreasing = FALSE)

  plot(sort(x),sorted.output,pch=19,
       ylim=c(-max(abs(sorted.output)),max(abs(sorted.output))),
       xlim=c(-max(abs(c(x,upside.target,downside.target))),max(abs(c(x,upside.target,downside.target)))),
       col=ifelse(sorted.output<required.return&sort(x)<downside.target,'red',
          ifelse(sorted.output<required.return&sort(x)>downside.target,'pink',
          ifelse(sorted.output>required.return&sort(x)<upside.target,'lightgreen','darkgreen'))),  main="Viole-Nawrocki UPM/LPM Utility",
       xlab="Security Returns",ylab="UTILITY")
  outputs=c(output.1,output.2,output.3,output.4,output.5,output.6)

  abline(h=0, v=which(sorted.output==downside.target)[1], col=c('black','red'))
  abline(v = upside.target,col='green')
  abline(v = downside.target,col='red')
  abline(v = required.return,lty=3)
  text(downside.target,max(outputs),"Downside Target",pos=2,col='red')
  text(upside.target,max(outputs),"Upside Target",pos=4,col='green')
  text(required.return,-max(abs(outputs)),"Required Return",pos=3)
  
  return(sum(outputs))

}
