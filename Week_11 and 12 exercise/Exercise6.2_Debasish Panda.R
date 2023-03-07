# Course:DSC640
# Name:Debasish Panda 
# Exercise 6.2


# Set Directory path
setwd("C:/Users/debas/OneDrive/Desktop/Bellevue/DSC 640/Week_11_12/ex6-2")

# Import required packages
library('magrittr')
library('ggmap')
library('ggplot2')
library('usmap')


# load birth rate data
birthrate <- read.csv('birth-rate.csv')

# load crime data
crime <- read.csv('crimeratesbystate-formatted.csv') 

# load education data
education <- read.csv('education.csv') 

# check column names
colnames(birthrate)

# format year columns
colnames(birthrate) <- gsub("X", "", colnames(birthrate))

# check column names
colnames(birthrate)

### Plot1: Histogram
options(repr.plot.width = 4, repr.plot.height = 4)

# create pivotted data for plotting
birthrate_hist <- reshape2::melt(birthrate, id=c("Country")) %>%
  dplyr::mutate("Country" = as.character(Country),
                "Year" = as.character(variable),
                "Population" = value,
                "Population_int" = ceiling(value)) %>% 
  dplyr::select(c("Country","Year","Population", "Population_int"))

# create histogram of population data
hist(birthrate_hist$Population_int, col=rgb(0.2,0.8,0.5,0.5) , border=F , main="")

### Plot2: Box Plot
# create box plot of population data
birthrate_box <- birthrate_hist %>% 
  dplyr::filter(Country %in% c("United States", "India"))
boxplot(birthrate_box$Population ~ birthrate_box$Country , col="grey")


### Plot3: Bullet Chart

# create bullet chart with crime data
crime_bullet <- crime %>% 
  dplyr::filter(stringr::str_trim(state, "both") == "United States") %>% 
  dplyr::select(c(state, burglary))
bulletgraph(x=crime_bullet$burglary,ref=650,limits=c(0,500,750,1000),
            name= "USA Crime metrics",subname="Burglary",
            col="steelblue4",shades="firebrick")


### Plot4: Donut Chart

# donut chart using USA crime data
education_donut <- education %>% 
  dplyr::filter(stringr::str_trim(state, "both") == "United States") %>% 
  reshape2::melt(id=c("state")) %>% 
  dplyr::rename("category" = variable) %>% 
  dplyr::filter(category %in% c("reading","math","writing")) %>% 
  dplyr::select(-state)


# add addition columns, needed for drawing with geom_rect
education_donut$fraction = education_donut$value / sum(education_donut$value)
education_donut = education_donut[order(education_donut$fraction), ]
education_donut$ymax = cumsum(education_donut$fraction)
education_donut$ymin = c(0, head(education_donut$ymax, n=-1))

# make the plot
ggplot2::ggplot(education_donut, ggplot2::aes(fill=category, ymax=ymax, ymin=ymin, xmax=4, xmin=3)) +
  ggplot2::geom_rect() +
  ggplot2::coord_polar(theta="y") +
  ggplot2::xlim(c(0, 4)) +
  ggplot2::theme(panel.grid=ggplot2::element_blank()) +
  ggplot2::theme(axis.text=ggplot2::element_blank()) +
  ggplot2::theme(axis.ticks=ggplot2::element_blank()) +
  ggplot2::annotate("text", x = 0, y = 0, label = "Education Components") +
  ggplot2::labs(title="")


### Plot5: Pie Chart

# pie chart
slices <- education_donut$value
lbls <- education_donut$category
pie(slices, labels = lbls, main="Education Components")
