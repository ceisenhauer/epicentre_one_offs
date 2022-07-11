# --------------------------------------------------------------------------------------------------
# proportion of confirmed measles
#
# author : catherine eisenhauer
# date : july 2022
# --------------------------------------------------------------------------------------------------

library(dplyr)
library(tinker)
library(ggplot2)


# LOAD ---------------------------------------------------------------------------------------------
fn <- here::here('data', 'drc_measles_lab.csv')
df <- rio::import(fn,
                  select = c('prov', 'zs', 'n_epid', 'year', 'debutsem', 'age_ans', 'sexe',
                             'resultats_igm_rougeole', 'resultats_igm_rubeole'),
                  col.names = c('reg', 'zone', 'epi_id', 'year', 'week', 'age', 'sex',
                                'measles', 'rubella'))

data.table::setDT(df)


# WRANGLE ------------------------------------------------------------------------------------------
df <- df %>%
        distinct() %>%
        mutate(across(c(measles, rubella),
                      function(x) case_when(x %in% c('negatif', '1') ~ FALSE,
                                            x %in% c('positif', '2') ~ TRUE,
                                            TRUE ~ NA))) %>%
        mutate(diag = case_when(measles & rubella ~ 'Both',
                                measles ~ 'Measles',
                                rubella ~ 'Rubella',
                                TRUE ~ 'Neither')) 
    

# check proportion of measles confirmations with no rubella data
df %>%
  filter(measles) %>%
  group_by(rubella) %>%
  count() %>%
  ungroup() %>%
  mutate(percent = n / sum(n))


# PLOT ---------------------------------------------------------------------------------------------
colors <- list('#02105e',
               '#203399',
               '#5364bd',
               '#acaebd')

tmp <- df %>%
    #filter(!is.na(measles) & !is.na(rubella)) %>%  # include to check % for complete tests only
    group_by(reg, diag) %>%
    count() %>%
    group_by(reg) %>%
    mutate(percent = n / sum(n)) %>%
    group_by(diag) %>%
    .summarize(med = .median(percent),
               lower = quantile(percent)[[2]],
               upper = quantile(percent)[[4]]) %>%
    mutate(label = sprintf("%.0f%%", med * 100),
           diag = factor(diag, levels = c('Measles', 'Rubella', 'Both', 'Neither')))

tmp %>%
  ggplot(aes(x = diag,
             y = med,
             color = diag)) +
  geom_point(size = 15) +
  geom_segment(aes(y = lower,
                   yend = upper,
                   x = diag,
                   xend = diag),
               size = 2,
               lineend = 'round') +
  geom_text(aes(label = label),
            size = 5,
            color = 'white',
            fontface = 'bold') +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1),
                     breaks = c(0, 0.2, 0.4, 0.6)) +
  scale_color_manual(values = colors) +
  theme_clean() +
  theme(legend.position = 'none') +
  xlab('') +
  ylab('') +
  labs(title = 'Lab Results for Suspected Measles Cases, DRC',
       subtitle = 'Median and IQR across Provinces',
       caption = 'Data from July 2020 - July 2022')

ggsave('lab_confirmation_complete_only.png',
       width = 7.75,
       height = 5.16)

