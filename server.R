library(Quandl)
library(quantmod)
library(gtrendsR)
library(dygraphs)

# Euro COT data
euro <- Quandl('CHRIS/CME_EC2')
euro <- xts(euro[,c('Settle')],order.by = euro[,1])
colnames(euro) <- c('euro')
cot <- Quandl('CFTC/EC_F_L_ALL')
cot <- xts(cot[,-1],order.by = cot[,1])
datacot <- merge.xts(euro,cot[,c('Noncommercial Long','Noncommercial Short',
                                 'Commercial Long','Commercial Short')],join = 'inner')

# S&P500 Index Future
spx<-Quandl("CHRIS/CME_SP1")
spx<-as.xts(spx$Last, order.by = spx$Date)

# Function for downloading message
downloading <- function(){
    withProgress(message = 'Downloading Data...',value = 0,
                 {
                     for (i in 1:10){
                         incProgress(1/15)
                         Sys.sleep(0.25)}
                 })
}


# App1lication server
shinyServer(function(input,output){
    
    output$plotpe <- renderDygraph({
        downloading()
        peshiller <- Quandl("MULTPL/SHILLER_PE_RATIO_MONTH")
        peshiller <- xts(peshiller[,2],order.by = peshiller[,1])
        colnames(peshiller) <- c('peShiller')
        getSymbols('^GSPC',from='1950-01-01')
        spy <- to.monthly(GSPC)
        spy <- spy[,'GSPC.Adjusted']
        colnames(spy) <- c('spy')
        spype <- merge.xts(peshiller,spy,join = 'inner')
        dygraph(spype,main = 'S&P 500 PE Ratio') %>% 
            dyRangeSelector() %>% dySeries('spy',axis='y2')
    })
    
    output$vix <- renderDygraph({
        downloading()
        vix_m=Quandl('CBOE/VXMT')
        vix_m=as.xts(vix_m$Close,order.by = vix_m$Date)
        vix_s=Quandl('CBOE/VXST')
        vix_s=as.xts(vix_s$Close,order.by = vix_s$Date)
        spxvix <- merge.xts(vix_m,vix_s,join = 'inner')
        spxvix <- merge.xts(spxvix,spx,join = 'inner')
        dygraph(spxvix,main = 'S&P 500 Volatility') %>% 
            dyRangeSelector() %>% dySeries('spx',axis='y2')
    })
    
    output$noncommercial <- renderDygraph({
        downloading()
        dygraph(datacot[,c('euro','Noncommercial.Long','Noncommercial.Short')],
                main = 'Euro Non Commercial COT') %>% 
            dyRangeSelector() %>% dySeries('euro',axis='y2')
    })
    
    output$commercial <- renderDygraph({
        dygraph(datacot[,c('euro','Commercial.Long','Commercial.Short')],
                main = 'Euro Commercial COT') %>% 
            dyRangeSelector() %>% dySeries('euro',axis='y2')
    })
    
    output$googletrendm <- renderDygraph({
        downloading()
        getSymbols('SPY',from='2004-01-01')
        p <- Cl(to.monthly(SPY))
        gtrend <- gtrends('market correction',time='all')
        trends <- xts(gtrend$interest_over_time$hits,order.by = as.Date(gtrend$interest_over_time$date))
        merged <- merge.xts(p,trends)
        colnames(merged) <- c('p','trends')
        dygraph(merged,main = 'Google Trends Monthly') %>% 
            dyRangeSelector() %>% dySeries('p',axis='y2') %>% 
            dyOptions(connectSeparatedPoints=T)
    })
    
    output$googletrendd <- renderDygraph({
        getSymbols('SPY')
        p <- Cl(SPY)
        trend_mkt <- gtrends('market correction',time='today 3-m')
        trend_mkt_ts <- xts(trend_mkt$interest_over_time$hits,order.by = as.Date(trend_mkt$interest_over_time$date))
        merged_d <- merge.xts(p,trend_mkt_ts,join = 'inner')
        colnames(merged_d) <- c('spy','trend')
        dygraph(merged_d,main = 'Google Trends Daily') %>% 
            dyRangeSelector() %>% dySeries('spy',axis='y2')
    })
    
    output$aaii <- renderDygraph({
        downloading()
        d <- Quandl('AAII/AAII_SENTIMENT')
        d <- xts(d[,-1],order.by = d$Date)
        dygraph(d[,c(5,12)],main = 'AAII Investor Sentiment') %>% 
            dyRangeSelector() %>% dySeries('S&P 500 Weekly Close',axis='y2')
    })
    
    output$cons <- renderDygraph({
        downloading()
        d <- Quandl('UMICH/SOC1')
        d <- xts(d[,-1],order.by = d$Date)
        merged <- merge.xts(d,spx,join = 'inner')
        dygraph(merged,main = 'US Michigan Consumer Sentiment') %>% 
            dyRangeSelector() %>% dySeries('spx',axis='y2')
    })
    
    output$prob <- renderDygraph({
        downloading()
        probmarket <- Quandl('UMICH/SOC20')
        probmarket <- xts(probmarket[,-1],order.by = probmarket$Date)
        merged <- merge.xts(probmarket,spx,join = 'inner')
        merged$diff0100 <- merged[,7]-merged[,1]
        merged$diff2575 <- merged[,6]-merged[,2]
        dygraph(merged[,c(10,11,12)],main = 'Probability of Increase in Markets') %>% 
            dyRangeSelector() %>% dySeries('spx',axis='y2') %>% 
            dySeries('diff0100',fillGraph=T) %>% 
            dySeries('diff2575',fillGraph=T)
    })
    
})



