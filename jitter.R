## Simple jitter by Kevin

# Ensure your working directory+file path for gap minder is set up properly,
# and install the following packages if they are not installed already:
library(tidyverse); theme_set(theme_light())
library(scales)

# Let's start with a very simple geom_jitter, but first, need a reason to use it...
# Let's try plotting mtcars's data, specifically the mpg by the number of cylinders:

mtcars %>%
  ggplot(aes(x = cyl, y = mpg)) + 
  geom_point() +
  geom_jitter(color="red", width = 0.75, height=0)

# Add a boxplot underneath!
set.seed(12)
mtcars %>%
  ggplot(aes(x = cyl, y = mpg)) + 
  geom_boxplot(aes(group = cyl)) +
  geom_jitter(color="red", width = 0.1, height=0)

# Another way of doing a similar thing: set position = position_jitterdodge(width=0.75, height=0)
