## gganimate, adapted from online materials by Kevin

# Ensure your working directory+file path for gap minder is set up properly,
# and install the following packages if they are not installed already:
library(tidyverse); theme_set(theme_light())
library(gganimate)
library(scales)
library(babynames)
gapminder <- read.csv("~/Downloads/Advanced ggplot2/gapminder_data.txt")

# traditional plot:
gapminder %>%
	ggplot(aes(x = gdpPercap, y = lifeExp, color = year)) +
	geom_point() +
	scale_x_log10(labels = scales::comma, guide=guide_axis(n.dodge=2)) +
	# scale_y_log10(labels = scales::comma) +
	scale_color_viridis_c()

# make a cursory animation with year a transition variable:
anim <- gapminder %>%
	ggplot(aes(gdpPercap, lifeExp, color = year)) +
	geom_point() +
	geom_smooth(method = "lm", formula = "y~x", se=F) +
	scale_x_log10(labels = scales::comma, guide=guide_axis(n.dodge=2)) +
	# scale_y_log10() +
	scale_color_viridis_c() +
	transition_states(year,
			  transition_length = 2,
			  state_length = 1)
anim

anim +
	ease_aes('cubic-in-out') +
	labs(title = 'Life expectancy is less dependent on per capita GDP across time',
	     subtitle = 'Current year: {closest_state}',
	     x="Country GDP per capita", y="Average life expectancy",
	     caption = "Source: Gapminder dataset (https://www.gapminder.org/data/)") +
	theme(plot.title = element_text(hjust=0.5))

# further beautify:
# add caption for gapminder dataset!



# another animation: baby name popularity through time (US baby names 1880-2017)
library(babynames)

select_names <- c("Jacob", "John", "&", "Kevin")
# Select only 
dat <- babynames %>% 
	filter(name %in% select_names) %>%
	filter(sex=="M")

# Plot
dat %>%
	ggplot( aes(x=year, y=n, group=name, color=name)) +
	geom_line() +
	geom_point() +
	scale_color_viridis_d() +
	labs(title = paste0("Popularity of ",
			    paste(select_names, collapse=", "),
			    " in the past 140 years")) +
	ylab("Number of babies born") +
	transition_reveal(year)



# Save as gif after setting your working directory:
# anim_save("babynames.gif")




