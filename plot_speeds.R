library(RgoogleMaps)
clat = 40.773455
clon = -73.982880
z = 12

#jet.colors =colorRamp(c("#00007F", "blue", "#007FFF", "cyan",
#                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

jet.colors =colorRamp(rev(c("blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red")))


linearScale = function(x, lo, hi){
	x = (x - lo) / (hi - lo)
	return(pmax(pmin(x, 1), 0))
}








infile = "tmp_speeds.csv"



print(paste("Reading", infile))



t = read.csv(infile)

#t$speed[is.na(t$speed)] = 0

for(thresh in c(0,.5,1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60)){

outfile = paste("map_thresh", thresh, ".png", sep="")
png(outfile, 1024, 1024)
par(mar=c(2,5,3,2), family="sans", bg="black", col.axis="white",col.lab="white", fg="white")
layout(c(1,2), heights=c(7,1))

t = t[t$num_trips>=thresh,]


print(paste("-----",outfile, "-----"))
print("Computing colors")
summary(t$speed)



cvals = linearScale(t$speed, 1, 20)
cols = rgb(jet.colors(cvals)/255)
#cols=rgb(jet.colors(t$speed/31)/255)

#cols = rgb(jet.colors(log(t$speed+1)/3.44)/255)

mymap = GetMap(center=c(clat, clon), zoom=z)
print("Plotting")
PlotOnStaticMap(mymap, clat, clon, col="black", pch=15, cex=400)
PlotArrowsOnStaticMap(mymap, lat0=t$start_lat, lon0=t$start_lon, lat1=t$end_lat, lon1=t$end_lon, FUN=segments, add=T, col=cols,lwd=3)



print("Adding legend")
plot(0,0, type="n", xlim=c(0,21), ylim=c(0,1), xaxt="n", yaxt="n", , bty="n", cex.main=.8, main="")
	
        vals = (0:200)/10
        cvals = linearScale(vals, 1, 20)
	mycols = rgb(jet.colors(cvals)/255)
        yvals = rep(.6,length(vals))
	points(vals, yvals, col=mycols, pch=15, cex=2)
	
	a = c((0:4)*50 + 1)
	print(a)
	print(vals[a])
	print(vals[a])
	#axis(1, at=a, labels=round(vals[a], 2))
	#abline(v=a)
	text(x=10,y=.8,labels="Velocity (m/s)", cex=2, col.main="white")
	segments(x0=vals[a],y0=.4,x1=vals[a],y1=.6, col="white", lwd=2)
	text(x=vals[a],y=.2,labels=vals[a], cex=2, col.main="white")


dev.off()
}

