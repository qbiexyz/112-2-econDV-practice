
library(tidyverse)
library(ggrepel)
library(readxl)
library(hrbrthemes)

WVS7_sta_Gini <- read_excel("240312/WVS7_sta_Gini.xlsx")

# 使用ggplot2畫出散布圖，並加上預測線
ggplot(WVS7_sta_Gini, aes(x = giniWB, y = life_sta, label = B_COUNTRY_ALPHA)) +
  geom_text_repel(aes(color = B_COUNTRY_ALPHA == "TWN"), box.padding = 0.35, 
                  point.padding = 0.5, segment.color = 'grey50') +
  geom_point(aes(color = B_COUNTRY_ALPHA == "TWN"), size = 2.5) +
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "GINI指數 (World Bank)", y = "生活滿意度 (1-10分)", title = "GINI指數與生活滿意度的關係") +
  theme_minimal() +
  guides(color = FALSE)


# 繪圖
ggplot(WVS7_sta_Gini, aes(x = giniWB, y = life_sta, label = B_COUNTRY_ALPHA)) +
  geom_point(aes(color = ifelse(B_COUNTRY_ALPHA == "TWN", "red", "black")), size = 2) +
  geom_text_repel() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") + # 加入預測線，不顯示信賴區間
  scale_color_identity() + # 使TWN可以用紅色標示
  theme_economist() + # 使用經濟學人風格
  labs(x = "Gini Index (World Bank)", y = "Life Satisfaction", 
       title = "Relationship between Gini Index and Life Satisfaction by Country",
       subtitle = "Data Source: World Bank, 2017") +
  theme(legend.position = "none") # 不顯示圖例



ggplot(WVS7_sta_Gini, aes(x = giniWB, y = life_sta, label = B_COUNTRY_ALPHA)) +
  geom_point(aes(color = (B_COUNTRY_ALPHA == "TWN")), size = 3) + # 特別標示TWN
  geom_text_repel() + # 確保標籤不重疊
  geom_smooth(method = "lm", se = FALSE) + # 加入預測線
  scale_color_manual(values = c("FALSE" = "black", "TRUE" = "red")) + # 設定顏色
  labs(x = "GINI指數 (World Bank提供)", y = "生活滿意度 (1到10分)", title = "GINI指數與生活滿意度的關係") +
  theme_ipsum(base_size = 14, base_family = "Helvetica") + # 使用hrbrthemes的主題
  theme(legend.position = "none") # 不顯示圖例
