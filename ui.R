library(shiny)
load("CreditDefault.rda")

shinyUI(fluidPage(
    titlePanel("Visualizing Lift of Bins"),
    strong("Description:"),
    "In binary classification, the proportion of target event occurences",
    "in the whole population is an important reference point. If we find",
    "a subset of population in which the said rate is significantly lower",
    "or higher, then we are wiser in the separation of future different",
    "future outcomes. The ",
    em("lift"),
    " of a group is the rate of target event occurences in the group",
    "divided by the rate of target event occurences in the whole",
    "population.", br(),
    "This application allows to bin (i.e., discretize) continous numeric",
    "attributes, and shows the lift value and the cardinality (i.e., the",
    "number of contained elements) of each different bin.", br(), br(),
    strong("Data set: "), tags$a("German Credit Data", href = 
    "http://www.myoops.org/cocw/mit/NR/rdonlyres/Sloan-School-of-Management/15-062Data-MiningSpring2003/E2EEC9FD-B1E5-4A37-A186-2638D17C4AA4/0/GermanCredit.xls"),
    "This is a data set of credit products. The target event is the default of the",
    "credit. Used attributes: Amount (credit amount in Deutsche Mark), ",
    "Duration (of credit in months), Age (of applicant in years).",
    
    br(), br(),
    sidebarLayout(
        sidebarPanel(            
            selectInput("attribute", 
                        label = "Choose an attribute to examine:",
                        choices = colnames(credit)[-ncol(credit)]),
            
            textInput("cutpoints",
                      label = "Put the cut points separated with comma (excluding min and max of attribute):",
                      "15"),
            
            br(),
            strong("Caution!"),
            "This prototype is not tolerant of improper inputs."
            ),
        
        mainPanel(
            h3(textOutput("captionSummary", container = span)),
            verbatimTextOutput("summary"),
            h3("Lift and cardinality of bins"),
            h4(textOutput("avgPop", container = span)),
            plotOutput("binPlot")
        )
    )
))