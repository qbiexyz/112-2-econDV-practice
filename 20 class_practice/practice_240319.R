library(tidyverse)
library(readr)
library(httr)
library(writexl)

# 設定工作路徑
setwd("C:/Dropbox/DataVisualization/112-2-econDV-practice/240319") 

# 檔案位置 ----
## 104-108 沒有學年度欄位
## 109資料學年度寫110
## 110資料學年度寫111，且與111資料完全一致
csv_urls <- list(
  "104" = "https://stats.moe.gov.tw/files/ebook/native/104/104native_A1-1.csv",
  "105" = "https://stats.moe.gov.tw/files/ebook/native/105/105native_A1-1.csv",
  "106" = "https://stats.moe.gov.tw/files/ebook/native/106/106native_A1-1.csv",
  "107" = "https://stats.moe.gov.tw/files/ebook/native/107/107native_A1-1.csv",
  "108" = "https://stats.moe.gov.tw/files/ebook/native/108/108native_A1-1.csv",
  "110" = "https://stats.moe.gov.tw/files/ebook/native/109/109native_A1-1.csv",
  "111" = "https://stats.moe.gov.tw/files/ebook/native/111/111native_A1-1.csv",
  "112" = "https://stats.moe.gov.tw/files/ebook/native/112/112native_A1-1.csv"
)

# 初始化一個空列表來存儲數據 ----
data_list <- list()

# 下載並讀取CSV文件 ----
for (year in names(csv_urls)) {
  url <- csv_urls[[year]]
  dest_file <- paste0("data_", year, ".csv")
  
  # 使用httr::GET函數下載文件
  GET(url, write_disk(dest_file, overwrite = TRUE))
  
  # 讀取CSV文件並將其存儲在data_list列表中
  data_list[[year]] <- read_csv(dest_file)
  
  # 補齊104-108 學年度欄位
  data_list[[year]][["學年度"]] <- 
    rep(year, times = length(data_list[[year]][["學校類別"]]))
}

# 使用dplyr::bind_rows將列表中的所有DataFrame垂直合併 ----
combined_data <- bind_rows(data_list)

# 存資料
write_xlsx(list(combined_data = combined_data), "combined_data.xlsx") 

# 整理數據，將其轉換為長格式
long_data <- combined_data %>%
  pivot_longer(cols = starts_with("在學學生人數"), 
               names_to = "學位", values_to = "人數") %>%
  mutate(學位 = factor(學位, levels = c("在學學生人數_博士班",
                                        "在學學生人數_碩士班",
                                        "在學學生人數_學士班"),
                     labels = c("博士班", "碩士班", "學士班"))) |>
  transform(學年度 = as.integer(學年度)) |>
  filter(!is.na(學位))


# 定義顏色
colors <- c("博士班" = "#E41A1C", "碩士班" = "#377EB8", "學士班" = "#4DAF4A")

# 繪製百分比堆疊直條圖
ggplot(long_data, aes(x = 學年度, y = 人數, fill = 學位)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values = colors) +
  theme_minimal() +
  theme(text = element_text(family = "sans", color = "#333333"),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(vjust = -0.5),
        axis.title.y = element_blank(),
        legend.title = element_blank()) +
  labs(x = "學年度", y = "人數比例", title = "104到112學年大專校院原住民學生人數比例（排除學位NA）",
       caption = "資料來源：用戶上傳") +
  scale_x_discrete(limits = rev(unique(long_data$學年度)))  # 確保學年度是按順序顯示
