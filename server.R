###Load packages###
library(ggplot2)
library(cluster) 
library(data.table)
library(knitr)
library(dplyr)

library(ggmap)
###Load Data###
path <- '~/Desktop/myshinyapp/census'
setwd(path)
plotdata <- read.csv('finalpdata_filt.csv',sep=',',header=TRUE, stringsAsFactors = F)
###Functions###
plt <- function (i){
    data <- subset(plotdata, ClusterNum == i)
    cbPalette <- c('1' = "brown4",'2'= "greenyellow",'3' = "deeppink4",'4' ="skyblue4",'5' ="chocolate1",'6' ="maroon3",'7' ="seagreen", '8' = "violet")
    map <-qmap('cook')+
        geom_polygon(data = plotdata,aes(long,lat,group = group,fill='grey16'))+
        geom_polygon(data = data, aes(x=long, y=lat, group = group,fill = factor(ClusterNum),alpha=0.5),colour = "black", size = 0.2)+
        scale_fill_manual(values=cbPalette)+
        guides(fill=FALSE,alpha=FALSE)
    return (map)
}

boxp <- function(i){
    data <- na.omit(plotdata[9:19])
    p <- ggplot(data, aes(x=reorder(ClusterNum,data[,i],mean), y=data[,i])) +
        geom_boxplot(aes(group=ClusterNum,y =data[,i],color = factor(ClusterNum))) +
        theme(axis.text.x = element_text(angle=45, vjust=0.5)) +
        ylab(colnames(data)[i]) +
        geom_hline(aes(yintercept=0),size=0.7,color='black',linetype="dashed")+
        ggtitle(paste('Boxplot for',colnames(data)[i] ,'across each cluster'))
    return (p)
}

htplt <- function(i,min,max){
    nrowcnt <- nrow(plotdata)
    datasort <- plotdata[order(plotdata[,i]),]
    datause <- datasort[floor(min*nrowcnt):floor(max*nrowcnt),]
    
    map <-ggplot()+
        geom_polygon(data = plotdata,aes(long,lat,group = group),color = 'black',fill = 'black',alpha=0.5)+
        geom_polygon(data = datause ,aes(long,lat,group = group,fill = datause[,i]))+
        scale_fill_gradient(low='white',high='red',na.value = 'cyan1')+
        guides(fill=FALSE,alpha=FALSE)
    return(map)
}

###Shiny Server###
shinyServer(
    function(input, output) {
        
        output$mapc <- renderPlot({
            i <- switch(input$clnum,
                        "Cluster 1"= 1 ,"Cluster 2"=2 , 
                        "Cluster 3"=3 , "Cluster 4"=4 ,
                        "Cluster 5" =5,"Cluster 6"=6 ,
                        "Cluster 7" =7,"Cluster 8"=8)
            mapc <- plt(i)
            mapc
        })
        
        output$boxp <- renderPlot({
            v <- switch(input$var,
                        "Change_Population" = 2,
                        "Change_HouseUnits" = 3, 
                        "Change_5To7_or_more_person_household" = 4, 
                        "Change_Builst1939earlier" = 5,
                        "Change_Built_1940to1959" = 6,
                        "Change_VacantUnits" = 7,
                        "Y00_PCT_Units_HHIncome_25to50k" = 8,
                        "Y00_PCT_Units_HHIncome_50to75k" = 9,
                        "Chg_Educate_HighSchool_orLess"= 10,
                        "Chg_Educate_SomeCollege"= 11)
            boxp <- boxp(v)
            boxp
        })
        
        output$view <- renderText({
            'We can see the summary of box plot for each cluster. 
By looking at the clustering 3, we can see the change of vacant unit and income from 25kto50k variables are top ranked. So we can assume that people in clustering 3 got increasing income and willing to change their living condition.
            The rate of change of Cluster 5,6,7,8 are bottom 4 small rate of change among all clusters at vacant units, income from 25-50k and income from 50-75k variables. They are minority comparing with other 4 clusters
            Only clustering 1,2,3 has positive rate of change of educated some college variable. We can see these on the maps as well.
            All positive rate of change are two income variables, which may indicate people in cook county are getting richer.
            All negative rate of change is educate high school variable, which may indicate people in cook county are less educated than before. 
            '
        })
        
        output$heatmap <- renderPlot({
            min <- input$slider[1]*0.01
            max <- input$slider[2]*0.01
            v <- switch(input$var,
                        "Change_Population" =10,
                        "Change_HouseUnits" =11, 
                        "Change_5To7_or_more_person_household" = 12, 
                        "Change_Builst1939earlier" = 13,
                        "Change_Built_1940to1959" = 14,
                        "Change_VacantUnits" = 15,
                        "Y00_PCT_Units_HHIncome_25to50k" =16,
                        "Y00_PCT_Units_HHIncome_50to75k" =17,
                        "Chg_Educate_HighSchool_orLess"=18,
                        "Chg_Educate_SomeCollege"=19)
            heatmap <- htplt(v,min,max)
            heatmap
        })
        
        output$note <- renderText({
            note <- as.character(input$note)
            note
        })
})
