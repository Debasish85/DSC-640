# Course:DSC640
# Name:Debasish Panda 
# Exercise 5.2


# Set Directory path
setwd("C:/Users/debas/OneDrive/Desktop/Bellevue/DSC 640/Week_9_10/ex5-2")

# Import required packages
library('magrittr') 
library('ggmap')
library('ggplot2')
library('usmap')

#read the data sets
ppg <-  read.csv('ppg2008.csv')
costco <- read.csv('costcos-geocoded.csv')

# Create a statewide count of Costco
costco_sum <- costco %>% 
  dplyr::mutate(state = State) %>% 
  dplyr::group_by(state) %>%
  dplyr::summarise(store_count = dplyr::n())

### Plot1: Heat Map
heatmap(as.matrix(ppg[,2:ncol(ppg)]))

### Plot2: Spatial Chart
# plot number of Costco stores in staes through color intensity
options(repr.plot.width = 4, repr.plot.height = 3)
plot_usmap(data = costco_sum, values = "store_count", lines = "white") + 
  scale_fill_continuous(name = "Number of Costco Stores (2015)", label = scales::comma) + 
  theme(legend.position = "right")

### Plot3: Contour Plot
ggplot(ppg, aes(x=FTM, y=FTA))+
  theme_bw()+
  geom_point(alpha=0.1, col='red')+
  geom_density2d(color='black')+
  ggtitle('Contour Plot')+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(x='FTM', y='FTA')