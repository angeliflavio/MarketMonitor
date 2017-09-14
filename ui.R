library(shiny)
library(shinythemes)
library(markdown)
library(dygraphs)

#Application
shinyUI(
    navbarPage(theme=shinythemes::shinytheme('spacelab'),title='Market Analysis',
               tabPanel('Analysis',
                        navlistPanel(
                            tabPanel('Volatility',dygraphOutput('vix')),
                            tabPanel('PE Ratio',dygraphOutput('plotpe')),
                            tabPanel('Euro COT',
                                     verticalLayout(
                                         dygraphOutput('noncommercial'),
                                         br(),
                                         dygraphOutput('commercial')
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
                                     ))
                        )),
               tabPanel('Help',includeMarkdown('help.md'))
               )
)


