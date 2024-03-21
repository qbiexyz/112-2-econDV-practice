
# cost-of-loving ----

result <- list()
  
# 建立一個數據框以儲存估計數據
cost_of_loving <- data.frame(
  city = c("Shanghai", "New York", "Bahrain", "Los Angeles", "Paris", "Amman", "Caracas", "Moscow", "Milan", "Beijing", "Barcelona", "St Petersburg", "Abu Dhabi", "Düsseldorf", "Zurich"),
  meal = c(250, 300, 110, 260, 220, 100, 50, 140, 180, 200, 170, 130, 120, 190, 210),
  drinks = c(70, 90, 30, 80, 60, 25, 15, 40, 50, 55, 45, 35, 32, 52, 58),
  wine = c(450, 520, 150, 470, 420, 160, 90, 250, 300, 330, 280, 220, 210, 310, 340),
  cinema = c(30, 35, 12, 32, 28, 10, 5, 18, 22, 24, 20, 15, 14, 23, 25),
  taxi = c(5, 10, 3, 8, 7, 2, 1, 4, 6, 6, 5, 4, 3, 6, 7)
)

# 將數據框轉換為長格式以用於ggplot2
library(tidyr)
cost_long <- gather(cost_of_loving, key = "expense_type", value = "cost", -city)

# 使用ggplot2繪製圖形
library(ggplot2)
ggplot(cost_long, aes(x = city, y = cost, fill = expense_type)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "City", y = "Cost ($)", title = "Cost-of-Loving Index")
