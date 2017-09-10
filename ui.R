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
                                     )
                                     )
                        )),
               tabPanel('Help',includeMarkdown('help.md'))
               )
)


