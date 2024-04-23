# 讀取所需套件
library(ggplot2)
library(dplyr)

# 建立資料框
data <- tibble(
  candidate = c("candidate A", "candidate B", "candidate C"),
  supporting_rate = c(40.05, 33.49, 26.45)
)

# 建立長條圖並指定填充顏色
myPlot <- ggplot(data, aes(x = candidate, y = supporting_rate, fill = candidate)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("candidate A" = "#67c167", "candidate B" = "#4372c4", "candidate C" = "#7ededd")) +
  labs(title = "2024 presidential election", subtitle = "unit: percentage") +
  scale_y_continuous(expand = c(0, 0)) +
  theme_minimal() # 使用更簡潔的圖形主題

print(myPlot)

myPlot <- myPlot +
  theme(legend.position = "none", # 刪除圖例
        plot.margin = margin(t = 10, r = 10, b = 10, l = 10), # 調整圖表邊界
        plot.subtitle = element_text(hjust = 0.5, margin = margin(b = 20)), # 調整副標題位置與間距
        axis.title.y = element_blank()) + # 移除Y軸標題
  labs(y = "") + # 確保Y軸不顯示標題文字
  annotate("text", x = -Inf, y = Inf, label = "Supporting Rate (%)", hjust = -0.1, vjust = 2, angle = 0, size = 5, fontface = "bold") # 在左上角添加自定義文字

print(myPlot)

