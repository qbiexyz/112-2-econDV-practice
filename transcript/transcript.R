
# 套件 ----
library(tidyverse)
library(waffle)   
library(ggtext)
library(showtext)
library(rnaturalearth)
library(sf)   
library(readr)

# 數據讀取、整理----
transcript <- read_csv('transcript/transcript.csv')

glimpse(transcript)

transcript_c <- transcript |>
  count(semester, suject_type) |>
  transform(
    semester = factor(
      semester,
      levels = c("freshman", "sophomore", 
                 "junior", "senior")
    ),
    suject_type = factor(
      suject_type,
      levels = c("Research Methods", "Programming",
                 "Data Science", "Sociology and Others")
    )
  )

transcript_c$suject_type <- 
  fct_relevel(transcript_c$suject_type,
              "Wheat","Maize (corn)")


# 文字相關整理 ----

title<-"成績單"
sub<-"Each square is a country, colored according to continent:<br><b><span style='color:#FFC43D;'>Africa</span></b>, <b><span style='color:#F0426B;'>Asia</span></b>, <b><span style='color:#5A4FCF;'>Europe</span></b>, <b><span style='color:#059E75;'>Central and North America</span></b>, <b><span style='color:#06D6A0;'>South America</span></b> or <b><span style='color:#F68EA6;'>Oceania</span>. "

pal_fill <- c(
  "Sociology and Others" = "#FFD06F", "Data Science" = "#376795",
  "Programming" = "#72BCD5", "Research Methods" = "#84A8CA",
  # Set alpha to 0 to hide 'z'
  'z'=alpha('white',0)
)

pal_color <- c(
  "Sociology and Others" = "white", "Data Science" = "white",
  "Programming" = "white", "Research Methods" = "white",
  # Set alpha to 0 to hide 'z'
  'z'=alpha('white',0)
)




# 畫圖 ----
p1 <- ggplot(
  transcript_c, 
  aes(values = n, fill = suject_type)
)+
  waffle::geom_waffle(
    n_rows = 2,        # Number of squares in each row
    flip = TRUE, na.rm = TRUE
  )+
  facet_wrap(
    ~semester, 
    nrow = 1, 
    strip.position = "bottom") +
  scale_x_discrete()+
  scale_fill_manual(values = pal_fill) +
  scale_color_manual(values = pal_color) +
  coord_equal()
p1
p2 <- p1 +
  # Hide legend
  guides(fill='none',color='none')+
  # Add title and subtitle
  labs(title=title,subtitle=sub)+
  theme(
    # Enable markdown for title and subtitle
    plot.title=element_markdown(),
    plot.subtitle=element_markdown(),
    # "Clean" facets 
    panel.background=element_rect(fill="white"),
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    strip.background.x = element_rect(fill="white"),
    strip.background.y = element_rect(fill="dimgrey"),
    strip.text.y = element_text(color="white")
  )
p2