library(tidyverse)

## ----
# 生成日期序列
dates <- seq(as.Date("1960-01-01"), as.Date("1962-02-28"), by = "month")

# 假設匯率升值率是隨機生成的
set.seed(42) # 確保結果可重現
rates_usd <- runif(length(dates), -0.05, 0.05)
rates_jpy <- runif(length(dates), -0.05, 0.05)
rates_gbp <- runif(length(dates), -0.05, 0.05)

# 建立資料框
data <- tibble(
  Date = rep(dates, times = 3),
  Rate = c(rates_usd, rates_jpy, rates_gbp),
  Currency = rep(c("美元", "日元", "英鎊"), each = length(dates))
)

# 使用 ggplot2 繪製折線圖
ggplot(data, aes(x = Date, y = Rate, color = Currency)) +
  geom_line() +
  labs(x = "日期", y = "對台幣匯率升值率", color = "國家") +
  theme_minimal()

glimpse(data)

## ----
# import data
library(readr)

exchangeRate <- read_csv("240312/BP01M01.csv")

# 轉換日期1
exchangeRate <- exchangeRate %>%
  mutate(period = str_replace(期間, "M", "-"), 
         period = ymd(paste0(期間, "01")))

# 轉換日期2
## 假设exchangeRate是您的数据框或列表，包含日期字符串的列名为日期
exchangeRate$期間 <- as.Date(paste0(exchangeRate$期間, "01"),
                           format = "%YM%m%d")

# 下面展示如何計算NTD對其他幣別的匯率
exchangeRate <- exchangeRate %>%
  mutate(`日圓` = `新台幣NTD/USD` / `日圓JPY/USD`, # NTD對JPY的匯率
         `英鎊` = `新台幣NTD/USD` * `英鎊USD/GBP`, # NTD對GBP的匯率
         `港幣` = `新台幣NTD/USD` / `港幣HKD/USD`, # NTD對HKD的匯率
         `韓元` = `新台幣NTD/USD` / `韓元KRW/USD`, # NTD對KRW的匯率
         `美元` = `新台幣NTD/USD`
  )

glimpse(exchangeRate)

# 選欄位
exchangeRate <- exchangeRate %>%
  select(period, `日圓`:`美元`)


exchangeRate <- exchangeRate %>%
  arrange(period) %>%
  mutate(across(c("日圓", "英鎊", "港幣", "韓元", "美元"), 
                ~( . - lag(.) ) / lag(.), 
                .names = "成長率_{.col}"))

head(exchangeRate)

# 長表格轉換寬

exchangeRate <- exchangeRate %>% 
  pivot_longer(cols = starts_with("成長率"),
               names_to = "country",
               values_to = "升值率")

exchangeRate <- exchangeRate %>% 
  mutate(country = str_remove(country, "成長率_"))


# 繪製折線圖
ggplot(exchangeRate, aes(x = period, y = `升值率`, color = country)) +
  geom_line() +
  labs(x = "日期", y = "對台幣匯率升值率", color = "國家") +
  theme_minimal()