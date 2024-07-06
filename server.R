library(Quandl)
library(quantmod)
library(gtrendsR)
library(dygraphs)
library(alphavantager)
library(dplyr)

# api keys
Quandl.api_key('yoz2iiNXroUsDcsFzXiF')
av_api_key('14QN80MEWU581HI7')


# S&P500 Index Future
spx <- getSymbols("^GSPC",auto.assign = FALSE, from = "1980-01-01")
spx <- spx$GSPC.Adjusted
colnames(spx) <- c('spx')

# Euro COT data
#euro <- Quandl('CHRIS/CME_EC2',type = 'xts')$Settle
euro_tbl <- av_get("EUR/USD", av_fun = "FX_DAILY", outputsize = "full")
euro <- xts(euro_tbl, euro_tbl$timestamp)
euro <- euro$close
remove(euro_tbl)
colnames(euro) <- c('euro')
eurocot <- Quandl('CFTC/099741_FO_L_ALL',type = 'xts')
eurocot <- merge.xts(euro,eurocot[,c('Noncommercial Long','Noncommercial Short',
                                 'Commercial Long','Commercial Short')],join = 'inner')
eurocot$Noncommercial.Net <- eurocot$Noncommercial.Long-eurocot$Noncommercial.Short
eurocot$Commercial.Net <- eurocot$Commercial.Long-eurocot$Commercial.Short
# S&P 500 COT data
spxcot <- Quandl('CFTC/13874P_FO_L_ALL',type = 'xts')
spxcot <- merge.xts(spx,spxcot[,c('Noncommercial Long','Noncommercial Short',
                                 'Commercial Long','Commercial Short')],join = 'inner')
spxcot$Noncommercial.Net <- spxcot$Noncommercial.Long-spxcot$Noncommercial.Short
spxcot$Commercial.Net <- spxcot$Commercial.Long-spxcot$Commercial.Short
# japanese yen
yen <- Quandl('CHRIS/CME_JY2',type = 'xts')$Settle
colnames(yen) <- c('yen')
yencot <- Quandl('CFTC/097741_FO_L_ALL',type = 'xts')
yencot <- merge.xts(yen,yencot[,c('Noncommercial Long','Noncommercial Short',
                                     'Commercial Long','Commercial Short')],join = 'inner')
yencot$Noncommercial.Net <- yencot$Noncommercial.Long-yencot$Noncommercial.Short
yencot$Commercial.Net <- yencot$Commercial.Long-yencot$Commercial.Short
# british pound
#gbp <- Quandl('CHRIS/CME_BP2',type = 'xts')$Settle
gbp_tibble <- av_get("GBP/USD", av_fun = "FX_DAILY", outputsize="full")
gbp <- xts(gbp_tibble, gbp_tibble$timestamp)
gbp <- gbp$close
remove(gbp_tibble)
colnames(gbp) <- c('gbp')
gbpcot <- Quandl('CFTC/096742_FO_L_ALL',type = 'xts')
gbpcot <- merge.xts(gbp,gbpcot[,c('Noncommercial Long','Noncommercial Short',
                                  'Commercial Long','Commercial Short')],join = 'inner')
gbpcot$Noncommercial.Net <- gbpcot$Noncommercial.Long-gbpcot$Noncommercial.Short
gbpcot$Commercial.Net <- gbpcot$Commercial.Long-gbpcot$Commercial.Short
# volatility index
vix <- getSymbols('^VIX')
vix <- Cl(VIX)
colnames(vix) <- c('vix')
vixcot <- Quandl('CFTC/1170E1_FO_L_ALL',type = 'xts')
vixcot <- merge.xts(vix,vixcot[,c('Noncommercial Long','Noncommercial Short',
                                  'Commercial Long','Commercial Short')],join = 'inner')
vixcot$Noncommercial.Net <- vixcot$Noncommercial.Long-vixcot$Noncommercial.Short
vixcot$Commercial.Net <- vixcot$Commercial.Long-vixcot$Commercial.Short
# gold cot
gold <- Quandl('LBMA/GOLD',type = 'xts')[,1]
colnames(gold) <- c('gold')
goldcot <- Quandl('CFTC/088691_FO_L_ALL',type = 'xts')
goldcot <- merge.xts(gold,goldcot[,c('Noncommercial Long','Noncommercial Short',
                                  'Commercial Long','Commercial Short')],join = 'inner')
goldcot$Noncommercial.Net <- goldcot$Noncommercial.Long-goldcot$Noncommercial.Short
goldcot$Commercial.Net <- goldcot$Commercial.Long-goldcot$Commercial.Short
# treasury cot
bond <- spx
colnames(bond) <- 'bond'
bondcot <- Quandl('CFTC/020601_FO_L_ALL',type = 'xts')
bondcot <- merge.xts(bond,bondcot[,c('Noncommercial Long','Noncommercial Short',
                                    'Commercial Long','Commercial Short')],join = 'inner')
bondcot$Noncommercial.Net <- bondcot$Noncommercial.Long-bondcot$Noncommercial.Short
bondcot$Commercial.Net <- bondcot$Commercial.Long-bondcot$Commercial.Short

# Function for displaying 'downloading...' message
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
        #vix_m=Quandl('CBOE/VXMT')
        #vix_m=as.xts(vix_m$Close,order.by = vix_m$Date)
        vix_m <- getSymbols("^VIX6M", auto.assign = F)
        vix_m <- vix_m$VIX6M.Close
        vix_s <- getSymbols("^VIX9D", auto.assign = F)
        vix_s <- vix_s$VIX9D.Close
        #vix_s=Quandl('CBOE/VXST')
        #vix_s=as.xts(vix_s$Close,order.by = vix_s$Date)
        spxvix <- merge.xts(vix_m,vix_s,join = 'inner')
        spxvix <- merge.xts(spxvix,spx,join = 'inner')
        colnames(spxvix) <- c("vix_m", "vix_s", "spx")
        spxvix$diff <- spxvix$vix_m-spxvix$vix_s
        d <- dygraph(spxvix[,c('spx',input$vix)],main = 'S&P 500 Volatility') %>% 
                dyRangeSelector() %>% dySeries('spx',axis='y2')
        if ('diff' %in% input$vix){d <- dySeries(d,'diff',fillGraph=T)}
        d
    })
    
    output$cot <- renderDygraph({
        downloading()
        if (input$cotmkt=='euro'){datacot <- eurocot}
        else if (input$cotmkt=='spx'){datacot <- spxcot}
        else if (input$cotmkt=='yen'){datacot <- yencot}
        else if (input$cotmkt=='gbp'){datacot <- gbpcot}
        else if (input$cotmkt=='vix'){datacot <- vixcot}
        else if (input$cotmkt=='gold'){datacot <- goldcot}
        else if (input$cotmkt=='bond'){datacot <- bondcot}
        d <- dygraph(datacot[,c(input$cotmkt,input$cot)],main = 'Commitment of Traders') %>% 
                dyRangeSelector()   
        if (input$cotmkt=='euro'){d <- dySeries(d,'euro',axis='y2')}
        else if (input$cotmkt=='spx'){d <- dySeries(d,'spx',axis = 'y2')}
        else if (input$cotmkt=='yen'){d <- dySeries(d,'yen',axis='y2')}
        else if (input$cotmkt=='gbp'){d <- dySeries(d,'gbp',axis='y2')}
        else if (input$cotmkt=='vix'){d <- dySeries(d,'vix',axis='y2')}
        else if (input$cotmkt=='gold'){d <- dySeries(d,'gold',axis='y2')}
        else if (input$cotmkt=='bond'){d <- dySeries(d,'bond',axis='y2')}
        if ('Commercial.Net' %in% input$cot){d <- dySeries(d,'Commercial.Net',fillGraph = T)}
        if ('Noncommercial.Net' %in% input$cot){d <- dySeries(d,'Noncommercial.Net',fillGraph = T)}
        d
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
    
    output$putcall <- renderDygraph({
        downloading()
        putcall <- Quandl('CBOE/SPX_PC',type = 'xts')
        putcall <- putcall[,1]
        putcall <- EMA(putcall,n=10)
        equity <- Quandl('CBOE/EQUITY_PC',type = 'xts')
        equity <- equity[,4]
        equity <- EMA(equity,n=10)
        total <- Quandl('CBOE/TOTAL_PC',type = 'xts')
        total <- total[,4]
        total <- EMA(total,n=10)
        d <- merge.xts(spx['2006-10-01::'],equity)
        d <- merge.xts(d,putcall)
        d <- merge.xts(d,total)
        colnames(d) <- c('spx','equity','putcall','total')
        dygraph(d[,c('spx',input$putcall)],main = 'Put Call Ratio') %>% 
            dyRangeSelector() %>% 
            dySeries('spx',axis='y2') 
    })
    
    
    output$ad <- renderDygraph({
        downloading()
        ad <- Quandl(c('URC/NYSE_ADV','URC/NYSE_DEC','URC/NYSE_ADV_VOL','URC/NYSE_DEC_VOL','URC/NYSE_52W_HI','URC/NYSE_52W_LO'),type = 'xts')
        getSymbols('^GSPC',from='1950-01-01')
        p <- Cl(GSPC)
        ad <- merge.xts(p,ad)
        ad <- na.omit(ad)
        colnames(ad) <- c('p','numadv','numdec','voladv','voldec','numhig','numlow')
        ad$num <- cumsum(ad$numadv-ad$numdec)
        ad$vol <- cumsum(ad$voladv-ad$voldec)
        ad$hl <- cumsum(ad$numhig-ad$numlow)
        d <- dygraph(ad[,c('p',input$ad)],main = 'Market Breadth') %>% 
            dyRangeSelector() %>% dySeries('p',axis='y2') 
        if ('num' %in% input$ad){d <- dySeries(d,'num',fillGraph = T)}
        if ('vol' %in% input$ad){d <- dySeries(d,'vol',fillGraph = T)}
        if ('hl' %in% input$ad){d <- dySeries(d,'hl',fillGraph = T)}
        d
    })
    
    output$rsiquarterly <- renderDygraph({
        downloading()
        getSymbols('^GSPC',from='1900-01-01')
        p <- Cl(to.quarterly(GSPC))
        rsi <- RSI(p,n=12)
        d <- merge.xts(p,rsi)
        colnames(d) <- c('spx','rsi')
        dygraph(d) %>% dyRangeSelector() %>% 
            dySeries('rsi',axis='y2') %>% 
            dyAxis('y',logscale = T)
    })
})



