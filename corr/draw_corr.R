library(readxl)
library(tidyverse)
library(lavaan)
library(magrittr)
library(corrplot)


# 讀資料 ----
## 先預處理
corr1 <- read_excel("corr/corr.xlsx", 
                   sheet = "xyz3")

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

# 畫圖 ----

p <- 
corr1.1 %>%
  ggplot(aes(xvar, yvar, col = value)) + ## to get the rect filled
  geom_tile(col="black", fill="white") +
  geom_point(aes(size = abs(value), fill = value), 
             shape = "circle", stroke = 0.5) +
  labs(x = NULL, y = NULL, 
       col = "",
       title ="睡眠問題與正/負面情緒之相關係數圖", 
       subtitle = "睡眠問題(Sleep Problems, SP)、正面情緒(Positive Affect, PA)、負面情緒(Negative Affect, NA)\n時間範圍:從國一開始(以多數13歲為代表)，包含青少年到成人初期(13y ~ 30y)。", 
       caption = "(空白格為不顯著)，資料來源:臺灣青少年成長歷程研究國一樣本青少年到成人初期，共9波追蹤資料") +
  theme_classic()+
  scale_color_gradient2(mid = "#FBFEF9",low = "#A63446",high = "#0C6291", 
                        limits = c(-1,1))  +
  scale_x_discrete(expand = c(0,0)) +
  scale_y_discrete(expand = c(0,0)) +
  scale_size(range = c(1,11), guide = NULL) +
  guides(fill = FALSE) + 
  guides(colour = guide_colourbar(barwidth = 1, 
                                  barheight = 15)) +   # 調整圖例的長度和寬度
  geom_vline(xintercept = 9.5, linetype = "solid",
             size = 1.5, color = "black") + 
  theme(plot.title = element_text(size = 24, face = "bold"),
        plot.subtitle = element_text(size = 12),
        plot.caption = element_text(size = 10, color = "gray"))

p





