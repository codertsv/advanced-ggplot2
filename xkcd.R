## Re-creating the Ballmer Peak xkcd comic, by Kevin

library(xkcd)
library(extrafont)
library(tidyverse); theme_set(theme_classic())

if( 'xkcd' %in% fonts()) {
	print("xkcd fonts already installed")
} else {
	warning("Not xkcd fonts installed! Attempting to install now!")
	download.file("http://simonsoftware.se/other/xkcd.ttf",
				  dest="xkcd.ttf", mode="wb")
	system("mkdir ~/.fonts")
	system("cp xkcd.ttf ~/.fonts")
	font_import(pattern = "[X/x]kcd", prompt=FALSE)
	if(.Platform$OS.type != "unix") {
		## Register fonts for Windows bitmap output
		loadfonts(device="win")
	} else {
		loadfonts()
	}
	if( 'xkcd' %in% fonts()) {
		print("Install successful!")} else {print("Error: Unable to install xkcd fonts!")}
}


# Try the following to see if fonts + axes are xkcd-style:
xrange <- range(mtcars$mpg)
yrange <- range(mtcars$wt)
mtcars %>%
	ggplot(aes(x=mpg, y=wt)) + 
	geom_point() +
	theme(text = element_text(size = 16, family = "xkcd"),
	      axis.line = element_blank()) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0)) +
	xkcdaxis(xrange, yrange) +
  labs(x = "Miles per gallon", y = "Car weight")


# Re-create my favourite xkcd comic: the Ballmer peak (https://xkcd.com/323/)

# Simulate some data for plotting:
x <- seq(0, 0.26, length.out=1000)
y <- ifelse(x > 0.129 & x < 0.138, 
            dnorm(x-mean(x[x > 0.129 & x < 0.138]), mean=0, sd = sd(x[x > 0.129 & x < 0.138])),
            dnorm(x-mean(x), mean= -mean(x), sd = sd(x))*15)
# plot(x, y, type='l') # view the raw data created


xrange <- range(x)
yrange <- range(y)
linedata <- data.frame(x=x[y == max(y)], xend=x[y == max(y)]+0.05,
                       y=y[y == max(y)], yend=y[y == max(y)]-20)
set.seed(11)
data.frame(bac = x, skill=y) %>%
  ggplot(aes(bac, skill)) +
  geom_line(color="red") +
  theme(text = element_text(size = 16, family = "xkcd"),
        axis.line = element_blank()) +
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0)) +
  xkcdaxis(xrange, yrange) +
  labs(title = "Ballmer Peak", x = "Blood Alcohol Concentration \nin percent", y = "Programming\nskill") +
  theme(axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_text(angle=0, vjust=0.5),
        plot.title = element_text(hjust=0.5)) +
  xkcdline(data=linedata, aes(x=x, y=y, xend=xend, yend=yend),
           xjitteramount = 0.03) +
  annotate("text", x=linedata$xend+0.03, y = linedata$yend-12,
           label = "B.A.C. between\n0.129 and 0.138 confers\nsuperhuman programming\nabilities!", family="xkcd" )


