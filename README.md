# R_repository
R scripts


用來製作每周WAF Daily report 的圖表。
以下列出一些註議

##需先安裝的套件:
library(ggplot2)
library(chron)
library(ggrepel)

## 使用 Rscript 接收參數
arg <- commandArgs(trailingOnly = TRUE)

x <- as.vector(strsplit(arg[1], ",")[[1]])  # date

y <- argv[2]    # path


### 
# 將down time為5:00之後的點標上domain name，因為vector的＂長度＂限制不能和原本time sclase 不同，因此用　na來表示不被接上標籤的部分即可
v5[times(all$down_time) < times("05:00:00")] <-NA

