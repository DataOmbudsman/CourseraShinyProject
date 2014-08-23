library(shiny)
library(lattice)
library(Hmisc)
load("CreditDefault.rda")
avgPop <- mean( credit[ncol(credit)][[1]] )


shinyServer(function(input, output) {
    #writing caption of summary
    output$captionSummary <- renderText({
        paste("Summary of selected attribute: ", input$attribute)
    })
    
    # writing summary of attribute
    output$summary <- renderPrint({
        dataset <- credit[[input$attribute]]
        summary(dataset)
    })
    
    # writing rate in poppulation
    output$avgPop <- renderText({
        paste("Occurance rate of target event in population: ",
              avgPop)
    })
    
    
    # preparing data for plotting + plotting
    output$binPlot <- renderPlot({
        
        # getting vector of cut points
        pointVec <- as.numeric(strsplit(input$cutpoints, split = ",",
                                        fixed = TRUE)[[1]])
            #as.numeric(strsplit(input$attribute, split = ",",
             #                           fixed = TRUE)[[1]])
        
        # transforming data
        credit_tmp <- credit
        credit_tmp$tmp <- cut2(credit[[input$attribute]],
                               c(min(credit[[input$attribute]]),
                                 pointVec,
                                 max(credit[[input$attribute]])))
        
        credit_vis <- aggregate(list(lift = credit_tmp$Default),
                                list(bin = credit_tmp$tmp),
                                mean)
        
        credit_vis$num <- summary(credit_tmp$tmp)
        
        credit_vis$lift <- round(credit_vis$lift/avgPop, 2)
        
        # lattice plot
        barchart(lift ~ bin, data = credit_vis,
                 ylim = c(0, max(credit_vis$lift) + 0.4), ylab = "Lift",
                 xlab = "Bins",
                 col = "skyblue",
                 panel = function(...) { 
                     args <- list(...)
                     panel.text(args$x, args$y, paste("Lift:", args$y), pos=3, offset=2)
                     panel.text(args$x, args$y, paste("(#:", credit_vis$num, ")", sep = ""), pos=3, offset=1)
                     panel.abline(h=1, lty = "dotted", col = "black", style=13 )
                     panel.barchart(...)
                 })
    })
})