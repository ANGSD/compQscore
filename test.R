fun <- function(x){
    df <- as.matrix(read.table(x))
    rownames(df) <- 0:(nrow(df)-1)-33
    colnames(df) <- 0:(ncol(df)-1)-33
    df <- df[,colSums(df)>0]
    df <- df[rowSums(df)>0,]
    heatmap(log(df),scale='none',Rowv=NA,Colv=NA,main=x)
    barplot(colSums(df),main="Before recalibration")
    barplot(rowSums(df),main="After recalibration")

}

fun2 <- function(x){
    df <- as.matrix(read.table(x))
    rownames(df) <- 0:(nrow(df)-1)-33
    colnames(df) <- 0:(ncol(df)-1)-33
    df <- df[,colSums(df)>0]
    df <- df[rowSums(df)>0,]
    df2 <- melt(df)
    p1 <- ggplot(data=df2,aes(x=X2,y=X1,fill=log(value))) +geom_tile(color='white',size=0.01)+coord_equal()
    inner <- function(x){
        tmp <- melt(x)
        tmp <- data.frame(tmp,X=as.numeric(rownames(tmp)))
        tmp
    }
    p2 <- ggplot(data=inner(rowSums(df)),aes(x=X,y=value))+geom_bar(stat='identity')
    p3 <- ggplot(data=inner(colSums(df)),aes(x=X,y=value))+geom_bar(stat='identity')
    list(p1,p2,p3)
}

library(gridGraphics)
grab_grob <- function(){
  grid.echo()
  grid.grab()
}

fun3 <- function(x){
    df <- as.matrix(read.table(x))
    rownames(df) <- 0:(nrow(df)-1)-33
    colnames(df) <- 0:(ncol(df)-1)-33
    df <- df[,colSums(df)>0]
    df <- df[rowSums(df)>0,]
    heatmap(log(df),scale='none',Rowv=NA,Colv=NA,main=x)
    g1 <- grab_grob()
    barplot(colSums(df),main="Before recalibration")
    g2 <- grab_grob()
    barplot(rowSums(df),main="After recalibration")
    g3 <- grab_grob()
    c(list(g1),list(g2),list(g3))
}

fnames <- system("ls *.comp",intern=T)
gs <- sapply(fnames,fun3)

pdf("qscoreComp.pdf",width=3*7,height=length(fnames)*7)
lay <- grid.layout(nrow = length(fnames), ncol=3)
pushViewport(viewport(layout = lay))
for(i in 1:length(gs)){
    cat("i:",i,"r: ",ceiling(i/3),"c: ", (i-1 %% 3)+1,"\n")
    grid.draw(editGrob(gs[[i]], vp=viewport(layout.pos.row = ceiling(i/3),layout.pos.col = ((i-1) %% 3)+1, clip=TRUE)))
}
dev.off()
