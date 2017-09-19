#### The App

This online application has been coded in **R** and hosted online using **ShinyApps**. It is meant to be used as a tool to analyse and monitor the financial markets. In particular, the App is built around a series of specific indicators that measure trend and sentiment of the main markets.

The assets covered include stocks (S&P500), currencies (Euro, British Pound, Japanese Yen) and commodities (Gold).

The application and its features are under continuous improvement and new indicators will be added to the analysis.
  
   
#### The Data

The time series used have been downloaded from

* **Quandl** API, a platform for financial, economic and alternative data sourcing information from over 500 publishers
* **Yahoo Finance**, used to download historical series of different assets
* **Google Trends**, the service showing how popular specific searches are
  
     
#### The Code

The App has been built using ```RShiny``` and the relative code is available on [GitHub](https://github.com/angeliflavio/MarketMonitor). The packages used to download the time series are ```Quandl```, ```gtrendsR``` and ```quantmod```. The graphs are produced using ```dygraphs```, an R interface to the dygraphs JavaScript charting library.
