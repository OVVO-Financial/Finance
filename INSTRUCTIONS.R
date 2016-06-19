### Instructions
require(PerformanceAnalytics)
require(quantmod)
require(XML)
require(tseries)
require(NNS)
require(DEoptim)


#Step1: Create Symbol list
  DJIA.Symbols <- c("AAPL","AXP","BA","CAT","CSCO","CVX","DD","DIS","GE","GS","HD","IBM","INTC","JNJ","JPM","KO","MCD","MMM","MRK","MSFT","NKE","PG","PFE","TRV","UNH","UTX","V","VZ","WMT","XOM")

  ETF.Symbols <- c("SPY","GLD","FXE","TLT","VXX") #...
  
#Step2: Download Data
  Raw.Data(DJIA.Symbols,start.date="2013-01-01")

      
#Step3: Condition Data  ### RUN ONCE RETURN 3 GLOBAL VARIABLES
  Sample.period <<- 100; Backtest <<- 250;
  conditioning(Sample.period,Backtest);
  EW.port <- rowMeans(BT.Raw)

    
#Step4: Optimize Data & Portfolio Construction
  LPM.degree <<- 3;UPM.degree<<- 2;
  LPM.target = 1.00005;UPM.target=1.00005;
  Conditioned.port=VN.Lin.opt(Conditioned);
  Conditioned.weights <<- Conditioned.port;
  noquote(paste("Conditioned.port=",Conditioned.port,sep = ""))
    ### COPY & PASTE OUTPUT FROM --> Conditioned.port
  
  
  Conditioned.no.vol.port= VN.Lin.opt(Conditioned.no.vol);
  Conditioned.no.vol.weights <<- Conditioned.no.vol.port;
  noquote(paste("Conditioned.no.vol.port=",Conditioned.no.vol.port,sep = ""))
    ### COPY & PASTE OUTPUT FROM --> Conditioned.no.vol.port
      
  UN.Conditioned.port=VN.Lin.opt(Raw);
  UN.Conditioned.weights <<- UN.Conditioned.port;
  noquote(paste("UN.Conditioned.port=",UN.Conditioned.port,sep = ""))
    ### COPY & PASTE OUTPUT FROM --> UN.Conditioned.port


#Step5: Plot portfolios
  plotting()
