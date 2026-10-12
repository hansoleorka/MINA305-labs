#' Assign color names to objects based on their numeric values
#' 
#' Create a vector of color codes based input values on a color ramp or color palette.  
#' 
#' @param x a vector of numeric values
#' @param n number of colors
#' @param colorRamp a color palette or color ramp created by \code{colorRampPalette} the default is \code{laser.colors}
#' @return a vector with colors depending on scaled and sorted to x 
#' @author Hans Ole Orka \email{hans.ole.orka@@gmail.org}
#' @examples 
#' x <- rnorm(100,10,5)
#' plot(x,col=color.mapper(x)
laser.colors <- function(x,n=100,colorRamp=colorRampPalette(c("blue", "cyan", "green", "yellow", "orange", "red"))){
	col.table <- colorRamp(n)
	col <- round((n-1) * ((x - min(x))/(max(x - min(x))))) + 1
	col <- col.table[col]
	return(col)
	}

