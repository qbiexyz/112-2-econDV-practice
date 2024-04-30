library(tidyverse)
library(readxl)

sleep_data <- read_excel("C:/Users/qbieq/Desktop/2017年男女睡覺時間.xlsx")

# 將小時轉換為因子並按指定順序重新排列
hours_order <- c(21:23, 0:20)
sleep_data$小時 <- factor(sleep_data$小時, levels = hours_order)

# 將數據從寬格式轉換為長格式
sleep_data_long <- sleep_data %>%
  pivot_longer(cols = -小時, names_to = "性別", values_to = "睡覺時間百分比")

# 繪製圖形
ggplot(sleep_data_long, aes(x = 小時, y = `睡覺時間百分比`, fill = 性別)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.7) +
  scale_fill_manual(values = c("male" = "#4C78A8", "female" = "#F58518")) + # 「經濟學人」風格顏色
  theme_minimal() + # 使用簡潔主題
  labs(x = "小時", y = "睡覺時間百分比", title = "2017年台灣青少年男女睡覺時間比例") +
  theme(plot.title = element_text(hjust = 0.5), # 標題居中
        legend.title = element_blank(), # 移除圖例標題
        panel.background = element_rect(fill = "white", colour = "black")) # 背景和邊框
