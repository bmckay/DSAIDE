#' @title A helper function that takes a model and generates shiny UI elements
#'
#' @description This function generates shiny UI inputs for a supplied model.
#' This is a helper function called by the shiny app.
#' @param model_function a string containing the name of a simulator function for which to build inputs
#' @param is_mbmodel a logical, indicating if the simulator function follows the modelbuilder syntax
#' @param otherinputs a text string that specifies a list of other shiny inputs to include in the UI
#' @param packagename name of package using this function (DSAIDE or DSAIRM)
#' @return A renderUI object that can be added to the shiny output object for display in a Shiny UI
#' @details This function is called by the Shiny app to produce the Shiny input UI elements.
#' model_function is assumed to be the name of a function.
#' The formals of the function will be parsed to create UI elements.
#' Therefore, all simulator_ R functions/scripts need to follow a specific syntax.
#' Either it needs to be created by modelbuilder and have vars/pars/times as vector inputs.
#' Or it has all single var = X inputs. They all need to have defaults provided.
#' Non-numeric arguments of functions are removed and need to be included in the otherinputs argument.
#' @export

generate_shinyinput <- function(model_function, is_mbmodel, otherinputs = NULL, packagename)
{

    #function to wrap input elements in specified class
    #allows further styling with CSS in the shiny app
    myclassfct = function (x) {
        tags$div(class="myinput", x)
    }

    ###########################################
    #create UI elements as input/output for shiny
	#done by parsing a function/R code
    ###########################################
    ip = unlist(formals(model_function)) #get all input arguments for function

    # from input/argument vector, create the shiny inputs
    modelargs = lapply(1:length(ip), function(n)
    {
        #iplabel = paste0(names(ip[n]),', ', x3[n]) #text label for input
        myclassfct(
            shiny::numericInput(names(ip[n]), label = names(ip[n]), value = ip[n][[1]], step = 0.01*ip[n][[1]])
        ) #close myclassfct
    }) #close lapply


    # Old way of doing it by parsing roxygen documentation header of function
    # Not as flexible but has advantage that labels can be shown nicely
    # #requires that function arguments are given in a vector
    # #find R file that contains the simulator_ code of the specified name
    # fcfile = paste0(system.file("simulatorfunctions", package = packagename),'/',mbmodel,'.R')
    # #get every line in documentation part of file that starts with @param
    # x = readLines(fcfile)
    # x2 = grep('@param', x, value = TRUE)
    # pattern = ".*[:](.+)[:].*" #regex for capturing text between colons
    # x3 = gsub(pattern, "\\1",x2)
    # x3 = substr(x3,2,nchar(x3)-1); #remove blanks in front and back
    # ip = formals(mbmodel) #get model inputs
    # #remove function arguments that are not numeric
    # ip = ip[unlist(lapply(ip,is.numeric))]
    # #build shiny numeric inputs for each numeric argument in function,
    # #set the explanatory text from the file documentation as label, set the value to the function default
    # modelargs = lapply(1:length(ip), function(n)
    # {
    #     iplabel = paste0(names(ip[n]),', ', x3[n]) #text label for input
    #     myclassfct(
    #
    #         shiny::numericInput(names(ip[n]), label = iplabel, value = ip[n][[1]], step = 0.01*ip[n][[1]])
    #     ) #close myclassfct
    # }) #close lapply


    #if the user provided otherinputs (which need to be in the form of a list of shiny input elements)
    #those will be added to the whole UI structure
    #the default is an empty string, then nothing will be added
    otherargs = NULL
    if (nchar(otherinputs)>1)
    {
        otherargs = lapply(eval(str2expression(otherinputs)),myclassfct)
    }

    #return structure
    modelinputs <- tagList(
            p(
                shiny::actionButton("submitBtn", "Run Simulation", class = "submitbutton"),
                shiny::actionButton(inputId = "reset", label = "Reset Inputs", class = "submitbutton"),
                #shiny::downloadButton(outputId = "download_code", label = "Download Code", class = "submitbutton"),
                align = 'center'),
            modelargs,
            otherargs,
            myclassfct(shiny::selectInput("plotscale", "Log-scale for plot",c("none" = "none", 'x-axis' = "x", 'y-axis' = "y", 'both axes' = "both"))),
            myclassfct(shiny::selectInput("plotengine", "Plot engine",c("ggplot" = "ggplot", "plotly" = "plotly")))
        ) #end tagList

    return(modelinputs)
} #end overall function


