library(shiny)
library(shinythemes)
library(markdown)
library(dygraphs)

#Application
shinyUI(
    navbarPage(theme=shinythemes::shinytheme('spacelab'),title='Market Analysis',
               tabPanel('Analysis',
                        navlistPanel(
                            tabPanel('Volatility',
                                     verticalLayout(
                                        checkboxGroupInput('vix','Volatility Indicators',
                                                           choiceNames = list('Volatility Short Term','Volatility Medium Term','Difference Medium Short'),
                                                           choiceValues = list('vix_s','vix_m','diff'),
                                                           selected = 'vix_s',
                                                           inline = T),
                                        br(),
                                        dygraphOutput('vix')
                                     )),
                            tabPanel('PE Ratio',dygraphOutput('plotpe')),
                            tabPanel('COT',
                                     verticalLayout(
                                         radioButtons('cotmkt','Market',
                                                      choiceNames = list('S&P 500','Euro'),
                                                      choiceValues = list('spx','euro'),
                                                      inline = T,
                                                      selected = 'euro'),
                                         br(),
                                         checkboxGroupInput('cot','Group of Investors',
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
                                         p('Google Trend for Market Correction'),
                                         br(),
                                         dygraphOutput('googletrendd'),
                                         br(),
                                         dygraphOutput('googletrendm')
                                     )),
                            tabPanel('AAII Sentiment',dygraphOutput('aaii')),
                            tabPanel('Consumer Sentiment',dygraphOutput('cons')),
                            tabPanel('Probability of Increase in Markets',
                                     verticalLayout(
                                         p('University of Michigan Consumer Survey, Probability of Increase in Stock Markets.'),
                                         br(),
                                         dygraphOutput('prob')
                                     )),
                            tabPanel('Put/Call Ratio',
                                     verticalLayout(
                                         checkboxGroupInput('putcall','Options',
                                                            choiceNames = list('Equity','Index','Total'),
                                                            choiceValues = list('equity','putcall','total'),
                                                            inline = T,
                                                            selected = 'equity'),
                                         br(),
                                         dygraphOutput('putcall')
                                     )),
                            tabPanel('S&P 500 Cycles',
                                     verticalLayout(
                                         checkboxGroupInput('cycles','Cycles Indicators',
                                                            choiceNames = list('Cycle1','Cycle2','Cycle3','Cycle4','Cycle5'),
                                                            choiceValues = list('cycle1','cycle2','cycle3','cycle4','cycle5'),
                                                            inline = T),
                                         br(),
                                         dygraphOutput('cycles')
                                     )),
                            tabPanel('Advance Decline',
                                     verticalLayout(
                                         radioButtons('ad','Advance Decline Indicators',
                                                            choiceNames = list('Cumulative Advancing Declining Stocks','Cumulative Advancing Declining Volume','Cumulative New Highs Lows'),
                                                            choiceValues = list('num','vol','hl'),
                                                            inline = T),
                                         br(),
                                         dygraphOutput('ad')
                                     ))
                        )),
               tabPanel('Help',includeMarkdown('help.md'))
               )
)


