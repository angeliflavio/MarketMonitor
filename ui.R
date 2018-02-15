library(shiny)
library(shinythemes)
library(markdown)
library(dygraphs)

#Application
shinyUI(
    navbarPage(theme=shinythemes::shinytheme('spacelab'),title='Market Monitor',
               tabPanel('Analysis',
                        navlistPanel(
                            tabPanel('Volatility',
                                     verticalLayout(
                                        includeMarkdown('vix.md'),
                                        br(),
                                        checkboxGroupInput('vix','Volatility Indicators',
                                                           choiceNames = list('Volatility Short Term','Volatility Medium Term','Difference Medium Short'),
                                                           choiceValues = list('vix_s','vix_m','diff'),
                                                           selected = 'vix_s',
                                                           inline = T),
                                        br(),
                                        dygraphOutput('vix')
                                     )),
                            tabPanel('PE Ratio',
                                     includeMarkdown('pe.md'),
                                     br(),
                                     dygraphOutput('plotpe')),
                            tabPanel('COT',
                                     verticalLayout(
                                         includeMarkdown('cot.md'),
                                         br(),
                                         radioButtons('cotmkt','Market',
                                                      choiceNames = list('S&P 500','US Treasury Bonds','Euro','Yen','British Pound','VIX Futures','Gold'),
                                                      choiceValues = list('spx','bond','euro','yen','gbp','vix','gold'),
                                                      inline = T,
                                                      selected = 'euro'),
                                         checkboxGroupInput('cot','Positions',
                                                            choiceNames = list('Non Commercial Long','Non Commercial Short','Non Commercial Net','Commercial Long','Commercial Short','Commercial Net'),
                                                            choiceValues = list('Noncommercial.Long','Noncommercial.Short','Noncommercial.Net','Commercial.Long','Commercial.Short','Commercial.Net'),
                                                            inline = T,
                                                            selected = 'Noncommercial.Net'),
                                         br(),
                                         dygraphOutput('cot'),
                                         br()
                                    )),
                            tabPanel('Google Trends',
                                     verticalLayout(
                                         includeMarkdown('gtrend.md'),
                                         br(),
                                         dygraphOutput('googletrendd'),
                                         br(),
                                         dygraphOutput('googletrendm')
                                     )),
                            tabPanel('AAII Sentiment',
                                     includeMarkdown('aaii.md'),
                                     dygraphOutput('aaii')),
                            tabPanel('Consumer Sentiment',
                                     includeMarkdown('cons.md'),
                                     dygraphOutput('cons')),
                            tabPanel('Probability of Increase in Markets',
                                     verticalLayout(
                                         includeMarkdown('prob.md'),
                                         br(),
                                         dygraphOutput('prob')
                                     )),
                            tabPanel('Put/Call Ratio',
                                     verticalLayout(
                                         includeMarkdown('pc.md'),
                                         checkboxGroupInput('putcall','Options',
                                                            choiceNames = list('Equity','Index','Total'),
                                                            choiceValues = list('equity','putcall','total'),
                                                            inline = T,
                                                            selected = 'equity'),
                                         br(),
                                         dygraphOutput('putcall')
                                     )),
                            tabPanel('Advance Decline',
                                     verticalLayout(
                                         includeMarkdown('ad.md'),
                                         br(),
                                         radioButtons('ad','Advance Decline Indicators',
                                                            choiceNames = list('Cumulative Advancing Declining Stocks','Cumulative Advancing Declining Volume','Cumulative New Highs Lows'),
                                                            choiceValues = list('num','vol','hl'),
                                                            inline = T),
                                         br(),
                                         dygraphOutput('ad')
                                     )),
                            tabPanel('S&P500 Quarterly RSI',
                                     verticalLayout(
                                         br(),
                                         dygraphOutput('rsiquarterly')
                                     ))
                        )),
               tabPanel('Help',includeMarkdown('help.md'))
               )
)


