library(readxl)
library(tidyverse)
library(lavaan)
library(magrittr)
library(ggtext)

# 讀資料 ----
## 先預處理
corr1 <- read_excel("30 practice/corr/corr.xlsx", 
                   sheet = "xyz31")

cor_nm <- colnames(corr1)[-1]

## 標籤
xlevel <- c("PA_30y", "PA_27y", "PA_24y", "PA_22y", "PA_18y", "PA_16y",
            "PA_15y", "PA_14y", "PA_13y",
            "NA_13y", "NA_14y", "NA_15y", "NA_16y", "NA_18y", "NA_22y", 
            "NA_24y", "NA_27y", "NA_30y") 
ylevel <- c("SP_13y", "SP_14y", "SP_15y", "SP_16y", 
            "SP_18y", "SP_22y", "SP_24y", "SP_27y", 
            "SP_30y")

# 整理資料 ----
corr1.1 <- corr1 %>% 
  rename("yvar" = "...1") |>
  pivot_longer(cols = cor_nm , names_to = "xvar") |>
  mutate(across(c(xvar, yvar), as.factor)) |>
  transform( 
    xvar = factor(xvar,levels = xlevel),
    yvar = factor(yvar,levels = ylevel)
  )

# 假設 corr1.1 已經是一個 data frame
corr1.1 <- corr1.1 %>%
  mutate(color_value = case_when(
    value < 0 ~ "pa",     # 當數值小於 0 時使用這個顏色
    value > 0 ~ "na",    # 當數值大於等於 1 時使用這個顏色
    TRUE ~ "0"       # 其他情況不賦予顏色（可以視需求更改）
  ))

cols <- c("pa" = "#A63446", "na" = "#0C6291", "0" = "white")
# 畫圖 ----
p <- 
corr1.1 %>%
  ggplot(aes(xvar, yvar, col = color_value)) + 
  geom_tile(col="black", fill="white") +
  geom_point(aes(size = abs(value), fill = value), 
             shape = "circle", stroke = 0.5) +
  labs(x = NULL, y = NULL, 
       col = "",
       title ="不同年紀的睡眠問題與正/負面情緒之相關係數圖", 
       subtitle = "睡眠問題(Sleep Problems, SP)、正面情緒(Positive Affect, PA)、負面情緒(Negative Affect, NA)<br>圓圈:相關係數大小，顏色:<span style='color:#A63446;'>小於0</span></b>、<span style='color:#0C6291;'>大於0</span></b>",
       caption = "資料來源:臺灣青少年成長歷程研究國一樣本，從青春年到成人初期(13y ~ 30y)，共9波追蹤資料") +
  theme_classic() +
  scale_colour_manual(
    values = cols, 
    guide = NULL
  ) +
  scale_x_discrete(expand = c(0,0)) +
  scale_y_discrete(expand = c(0,0)) +
  scale_size(range = c(1,13), guide = NULL) +
  guides(fill = FALSE) + 
  geom_vline(xintercept = 9.5, linetype = "solid",
             size = 1.5, color = "black") + 
  theme(
    plot.subtitle=element_markdown(size = 14),
    plot.title = element_markdown(size = 24, face = "bold"),
    plot.caption = element_markdown(size = 12, color = "gray")
    )

p
ggsave("30 practice/corr/睡眠問題與正負面情緒之相關係數圖.png", 
       plot = p, width = 10, height = 6, dpi = 300)
