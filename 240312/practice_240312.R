
library(tidyverse)

library(readxl)
WVS7_sta_Gini <- read_excel("240312/WVS7_sta_Gini.xlsx")
View(WVS7_sta_Gini)

# 使用ggplot2畫出散布圖，並加上預測線
ggplot(WVS7_sta_Gini, aes(x = giniWB, y = life_sta, label = B_COUNTRY_ALPHA)) +
  geom_point(aes(color = (B_COUNTRY_ALPHA == "TWN")), show.legend = FALSE) + # 標示TWN為紅色
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) + # 非TWN為黑色，TWN為紅色
  geom_text(vjust = -0.5, hjust = 0.5) + # 添加國家代碼標籤
  geom_smooth(method = "lm", se = FALSE, color = "red") + # 添加紅色的預測線，不顯示信賴區間
  theme_minimal() + # 使用簡潔的主題
  labs(title = "生活滿意度 vs GINI指數",
       x = "生活滿意度 (1-10分)",
       y = "GINI指數")