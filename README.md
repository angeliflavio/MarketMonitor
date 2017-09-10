# MarketMonitor

This is an RShiny App to monitor the financial markets using a series of sentiment and trend indicators. The application is hosted on [shinyapps.io](https://angelf.shinyapps.io/MarketMonitor).

### Data

For the **S&P 500**, the US index representing top 500 companies for market capitalization, the indicators include

* the **Volatility Index** (short and medium term)
* the **Price Earnings Ratio** calculated using the CAPE method by Robert Shiller
* the **Google Trends** number of hits for *market correction*

For the *Euro / Dollar* currency exchange, the indicators include

* the *Commitment of Traders* on the Euro future contracts
 
### Packages

The data has been downloaded using ```quantmod```, ```Quandl``` and ```gtrendsR```. The charts have been created using ```dygraphs```.