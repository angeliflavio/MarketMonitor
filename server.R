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


# Application server
shinyServer(function(input,output){
    
    output$plotpe <- renderDygraph({
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
        vix_m=Quandl('CBOE/VXMT')
        vix_m=as.xts(vix_m$Close,order.by = vix_m$Date)
        vix_s=Quandl('CBOE/VXST')
        vix_s=as.xts(vix_s$Close,order.by = vix_s$Date)
        spx<-Quandl("CHRIS/CME_SP1")
        spx<-as.xts(spx$Last, order.by = spx$Date)
        spxvix <- merge.xts(vix_m,vix_s,join = 'inner')
        spxvix <- merge.xts(spxvix,spx,join = 'inner')
        dygraph(spxvix,main = 'S&P 500 Volatility') %>% 
            dyRangeSelector() %>% dySeries('spx',axis='y2')
    })
    
    output$noncommercial <- renderDygraph({
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
    
})



