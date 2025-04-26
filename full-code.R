############################
#### TUTORIAL GGANIMATE ####
####  ABRAHAM ARBELAEZ  ####
############################


################################################################################

# Let's load our libraries first!

library(readr) # to read csv
library(tidyverse) 
library(gganimate) # our main star
library(datasauRus) # first example
library(sportyR) # second example
library(ggmap) # third example, you may need an API key

# first example
# dinosaur shaped data!
datasaurus_dozen %>%
  filter(dataset == "dino") %>%
  ggplot(aes(x=x,y=y)) +
  geom_point() +
  theme_minimal()

# let's take a look of the whole data
ggplot(datasaurus_dozen, aes(x=x,y=y)) +
  geom_point() +
  theme_minimal()

# let's add gganimate!
plot1 <- ggplot(datasaurus_dozen, aes(x=x,y=y)) +
  geom_point() +
  theme_minimal() +
  transition_states(dataset,3,1) + 
  ease_aes() 

plot1

anim_save("dino.gif")

# changing some frames per second
animate(plot1,
        fps = 100, # frames per second
        nframes = 200) # default is 100 frames

# slower animation!
animate(plot1,
        fps = 100, # frames per second
        nframes = 500) # default is 100 frames

# faster animation!
animate(plot1,
        fps = 20, # frames per second
        nframes = 50) # default is 100 frames


# second example
# let's load our data!
url1 = "https://raw.githubusercontent.com/abraham-arbelaez/gganimate-tutorial/main/data/nfl.csv"
nfl <- read_csv(url(url1))

# let's inspect it
head(nfl)
View(nfl)

# time to plot!
# field colors
fieldcolors <- list(plot_background = NULL,
                    field_apron = "#9DC183",
                    offensive_half = "#9DC183",
                    defensive_half = "#9DC183",
                    offensive_endzone = "#0B162A",
                    defensive_endzone = "#0B162A",
                    end_line = "#ffffff",
                    sideline = "#ffffff",
                    field_border = "#196f0c",
                    field_border_outline = "#ffffff00",
                    red_zone_border = "#196f0c00",
                    red_zone_border_outline = "#ffffff00",
                    major_yard_line = "#ffffff",
                    goal_line = "#ffffff",
                    minor_yard_line = "#ffffff",
                    directional_arrow = "#ffffff",
                    try_mark = "#ffffff",
                    yardage_marker = "#ffffff",
                    restricted_area = "#ffffff",
                    coaching_box = "#f26522",
                    team_bench_area = "#0B162A",
                    team_bench_area_outline = "#0B162A",
                    coaching_box_line = "#ffcb05")

# Making the field
nfl_field <- geom_football("nfl", 
                           x_trans = 60, 
                           y_trans = 26.6667,
                           color_updates = fieldcolors)

# Displaying the field
nfl_field

# Plotting our data
nfl_field +
  geom_point(
    data = nfl,
    aes(x, y),
    color = nfl$color) 

# Creating the animation
play_anim <- nfl_field +
  geom_point(
    data = nfl,
    aes(x, y),
    color = nfl$color,
    size = 1.5) +
  transition_time(nfl$frameId) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

# Showing the animation
play_anim

# Saving animation
animate(play_anim, height = 400, width = 800)
anim_save("play.gif")

# check it!
# https://www.youtube.com/watch?v=LjXYo-_XMl0&t=269s


# third example
# gps data
url2 = "https://raw.githubusercontent.com/abraham-arbelaez/gganimate-tutorial/main/data/gpsdata.csv"
gps <- read_csv(url(url2))

# let's inspect it!
head(gps)

# if you don't have API keys...
library(leaflet)
leaflet(gps) %>% 
  addCircleMarkers(radius = 1,
                   color = "#512888") %>% 
  addTiles()

# Creating boundaries
basemap <- get_stadiamap(bbox = c(left = min(gps$lon)-0.004,
                                  bottom = min(gps$lat)-0.001,
                                  right = max(gps$lon)+0.004,
                                  top = max(gps$lat)+0.001),
                         zoom = 17)

# Visualizing boundaries
ggmap(basemap)

# Checking coordinates
ggmap(basemap) +
  geom_point(data = gps, aes(x = lon, y = lat), size = 0.05) +
  geom_path(data = gps, aes(x = lon, y = lat)) 

# Animating data
anim <- ggmap(basemap) +
  geom_point(data = gps, aes(x = lon, y = lat), size = 1.5, color = "#512888") +
  geom_path(data = gps, aes(x = lon, y = lat), size = 1, color = "#512888") + 
  transition_reveal(along = t)

animate(anim, heigh = 800, width = 800)
anim_save("walkhome.gif")
