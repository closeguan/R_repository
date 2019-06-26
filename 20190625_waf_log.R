#!/usr/bin/Rscript

arg <- commandArgs(trailingOnly = TRUE)
x <- as.vector(strsplit(arg[1], ",")[[1]])  # date
y <- arg[2]   # path


#1 拿出需要的package

library(ggplot2)
library(chron)
library(ggrepel)

#2 把 data 讀進來

raw <- read.table("y", header = T)

#3 取出duration在30以上的資料
v1 <- raw$Date[raw$durations>30]
v2 <- raw$Division[raw$durations>30]
v3 <- raw$ip[raw$durations>30]
v4 <- raw$port[raw$durations>30]
v5 <- raw$domain[raw$durations>30]
v6 <- raw$down_time[raw$durations>30]
v7 <- raw$up_time[raw$durations>30]
v8 <- raw$durations[raw$durations>30]
all <- data.frame(v1, v2, v3, v4, v5, v6, v7, v8)
names(all) <- names(raw)

#4 兩軸上的刻度
#dd <- c("6/17","6/18","6/19","6/20","6/21","6/22","6/23")
tt <- c(
   "00:00",
   "01:00",
   "02:00",
   "03:00",
   "04:00",
   "05:00",
   "06:00"
   "07:00",
   "08:00",
   "09:00",
   "10:00",
   "11:00",
   "12:00",
   "13:00",
   "14:00",
   "15:00",
   "16:00",
   "17:00",
   "18:00",
   "19:00",
   "20:00",
   "21:00",
   "22:00",
   "23:00",
   "24:00"
  )

#5 採用灰色背景
theme_set(theme_gray())

#6 畫圖兒~
#6.1 底圖

g <- ggplot(all, aes(x=times(all$down_time), y=all$Date)) +
  geom_point(aes(color=as.factor(all$domain), shape = all$Division, size = all$durations)) +
  facet_wrap( ~ all$port, nrow=2) 

#6.2 座標範圍
# 時間資料與數值資料的轉換: 01:00:00 = 1/24
# 記得修該時間軸範圍時也要修改軸上的標籤tt

g1 <- g +
  coord_cartesian(xlim=c(3/24,6/24)) +  
  scale_x_continuous(breaks=seq(3/24,6/24,1/24), labels = tt)  +
  scale_y_discrete(labels = x) 

#6.3 標題與座標軸文字
# 記得修改subtitle的日期
  
g2 <- g1 + 
  labs(title = "WAF daily report", subtitle = "2019 6/17~6/23", y = "Date", x = "Down Time") +
  theme(axis.text.x = element_text(size = 12, 
                                   angle = 45, 
                                   vjust = 1.2, 
                                   hjust = 1.2),
        axis.title.x = element_text(size = 18),
        axis.text.y = element_text(size = 14),
        axis.title.y = element_text(size = 18),
        plot.title=element_text(size=20, 
                                face="bold", 
                                family="American Typewriter",
                                color="tomato",
                                hjust=0.5,
                                lineheight=1.2),
        plot.subtitle=element_text(size=15, 
                                   family="American Typewriter",
                                   face="bold",
                                   hjust=0.5)
  ) 

#6.4 圖例

g3 <- g2 + 
  labs(color="domain", size="duration (sec)", shape="divisions") +
  theme(legend.position="bottom", legend.box = "horizontal") +
  guides(shape = guide_legend(order = 1), size = guide_legend(order = 2), color = guide_legend(order = 3)) 

#6.5 將down time為5:00之後的點標上domain name

v5[times(all$down_time) < times("05:00:00")] <- NA
g4 <- g3 +
  geom_label_repel(aes(label = v5),
                   box.padding = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') 

#7 把圖叫出來

g4

pdf(filename="Rplot_00.pdf")
dev.off()

