## Multi-plots & repels by Kevin

# Ensure your working directory+file path for gap minder is set up properly,
# and install the following packages if they are not installed already:
library(tidyverse); theme_set(theme_light())
library(scales)
library(ggrepel)
library(patchwork)
library(cowplot)

# load gapminder dataset from last time:
gapminder <- read.csv("~/Downloads/Advanced ggplot2/gapminder_data.txt")

gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10() + 
  geom_smooth(method="lm", size=1.5) +
  labs(x="Country GDP per capita", y="Average life expectancy")

# add color per continent:
gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) + 
  scale_x_log10() + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  labs(x="Country GDP per capita", y="Average life expectancy")

# problem: data includes multiple years!! Make facet variable!
gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) + 
  scale_x_log10() + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  labs(x="Country GDP per capita", y="Average life expectancy") +
  facet_wrap(~year)

# too much going on! pick a few years:
# problem: data includes multiple years!! Make facet variable!
gapminder %>%
  filter(year %in% c(1952, 1977, 2007)) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) + 
  scale_x_log10() + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  labs(x="Country GDP per capita", y="Average life expectancy") +
  # geom_text_repel() +
  facet_wrap(~year)

# look closer at 1977: which countries are where??
# use ggrepel package to annotate!
gapminder %>%
  filter(year %in% c(1977)) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) +
  scale_x_log10() + 
  scale_color_viridis_d() + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  labs(x="Country GDP per capita", y="Average life expectancy") +
  geom_text_repel(aes(label = country)) # awful!

# Trick: zoom in in parts of plot!
# make separate plots for top and bottom!
lower_zoom <- gapminder %>%
  filter(year %in% c(1977)) %>%
  filter(gdpPercap < 1000 & lifeExp < 45)

p_lower <- gapminder %>%
  filter(year %in% c(1977)) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) +
  scale_x_log10(label = scales::comma) + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  coord_cartesian(xlim=c(300,1000), ylim=c(30,45)) +
  labs(x="Country GDP per capita", y="Average life expectancy") +
  geom_rect(aes(xmin = 300, xmax = 1000, ymin = 30, ymax = 45), color="red", fill=NA) +
  geom_text_repel(data=lower_zoom, aes(label = country, color=continent)) +
  guides(color=FALSE) # turns off the legend
p_lower

# upper zoom:
upper_zoom <- gapminder %>%
  filter(year %in% c(1977)) %>%
  filter(gdpPercap > 20000 & lifeExp > 65)

p_upper <- gapminder %>%
  filter(year %in% c(1977)) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) +
  scale_x_log10(label = scales::comma) + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  coord_cartesian(xlim=c(20000,60000), ylim=c(65,80)) +
  labs(x="Country GDP per capita", y="Average life expectancy") +
  geom_rect(aes(xmin = 20000, xmax = 60000, ymin = 65, ymax = 80), color="blue", fill=NA) +
  geom_text_repel(data=upper_zoom, aes(label = country, color=continent)) +
  guides(color=FALSE)
p_upper

# lastly, add rectangles to the un-zoomed plot:
p_all <- gapminder %>%
  filter(year %in% c(1977)) %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color=continent)) +
  scale_x_log10(label = scales::comma) + 
  geom_smooth(method="lm", formula="y~x", se=F, color="black") +
  labs(x="Country GDP per capita", y="Average life expectancy", color="Continent") + 
  geom_rect(aes(xmin = 300, xmax = 1000, ymin = 30, ymax = 45), color="red", fill=NA) +
  geom_rect(aes(xmin = 20000, xmax = 60000, ymin = 65, ymax = 80), color="blue", fill=NA)
p_all

# lastly, plot together:

# Patchwork allows rapid plotting using simple symbols:
require(patchwork)
(p_all / p_lower) | p_upper

# For more advanced plotting features, try cowplot!
require(cowplot)

legend <- get_legend(p_all) # extract legend to re-plot after

# # Alternative legend:
# legend <- get_legend(
#   p_all + theme(legend.box.margin = margin(0, 0, 0, 12)) # create some space to the left of the legend
# )

plot_grid(p_all + guides(color = FALSE), p_upper, p_lower, legend, ncol = 2,
          labels = c("A", "B", "C", ""),
          rel_heights = c(1, 0.5), rel_widths = c(1, 0.5))

# Also similar to plot_grid: 
# the arrangeGrob() and grid.arrange functions from the gridExtra package!

# Speal about grids & further customization of facets!


  
