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

fnames <- system("ls *.comp",intern=T)
png("heatmapRecalibration.png",width=3*480)
par(mfrow=c(1,3))
fun(fnames[1])
#fun(fnames[2])
#fun(fnames[3])
#sapply(fnames,fun)
dev.off()
