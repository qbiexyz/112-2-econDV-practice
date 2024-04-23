# Choose color ----
colorspace::choose_color()

# Choose palette ----
colorspace::choose_palette(gui="shiny")


# Install the required package if not already installed
# install.packages("ggplot2")

# Load the package----
library(ggplot2)

# Create a data frame with the data points
data <- data.frame(
  Year = c(2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020),
  Microsoft = c(0.51, 0.28, 0.30, 0.29, 0.23, 0.22, 0.24, 0.31, 0.51, 0.78, 1.24),
  Alphabet = c(NA, NA, NA, NA, NA, NA, NA, 0.20, 0.50, 0.73, 1.02),
  Apple = c(NA, NA, NA, NA, NA, 0.35, 0.55, 0.64, 0.62, 0.85, 1.39),
  Facebook = c(NA, NA, NA, NA, NA, NA, NA, 0.18, 0.35, 0.51, 0.77),
  Amazon = c(NA, NA, NA, NA, NA, 0.06, 0.10, 0.15, 0.36, 0.80, 1.57)
)

# Create the line plot
plt2 <- ggplot(data, aes(x = Year)) +
  geom_line(aes(y = Microsoft, color = "Microsoft"), size = 1) +
  geom_line(aes(y = Apple, color = "Apple"), size = 1) +
  geom_line(aes(y = Facebook, color = "Facebook"), size = 1) +
  geom_line(aes(y = Amazon, color = "Amazon"), size = 1) +
  geom_line(aes(y = Alphabet, color = "background"), size = 3) +
  geom_line(aes(y = Alphabet, color = "Alphabet"), size = 1.5) +
  scale_y_continuous(limits = c(0, 1.6), breaks = seq(0, 1.6, 0.2)) +
  scale_x_continuous(breaks = seq(2000, 2020, 2)) +
  labs(x = "Year", y = "Market capitalisation ($trn)", title = "Trillion-dollar tech") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_manual(values = c("Microsoft" = "#7fd1dd", "Alphabet" = "#c53625", 
                                "Apple" = "#628db6", "Facebook" = "#c0a9b0", 
                                "Amazon" = "#e9c791", "background" = "white"))
# Create the line plot
plt2