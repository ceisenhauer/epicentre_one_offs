# --------------------------------------------------------------------------------------------------
# updated outbreak list
#
# author : catherine eisenhauer
# date : july 2022
# --------------------------------------------------------------------------------------------------

library(dplyr)
library(tinker)

fns <- c('drc_measles.csv', 'drc_measles_pre_2018.csv')

df <- data.table::data.table()
for (fn in fns) {
  df <- rio::import(here::here('data', fn),
                    select = c('prov', 'zs', 'debutsem', 'pop', 'totalcas'),
                    col.names = c('reg', 'zone', 'week', 'pop', 'cases')) %>%
          rbind(df)
}

df <- df %>%
        mutate(year = lubridate::year(week),
               cases = tidyr::replace_na(cases, 0)) %>%
        group_by(reg, zone) %>%
        arrange(week, .by_group = TRUE) %>%
        identify_outbreaks()


df_epi <- df %>%
  group_by(reg, zone, outbreak_id, finished) %>%
  filter(outbreak_id != '') %>%
  rename(id = outbreak_id) %>%
  mutate(week = as.Date(week)) %>%
  .summarize(year = min(year),
             start = min(week),
             end = max(week),
             size = sum(cases),
             duration = n())

df_epi %>%
  rio::export(here::here('out', 'outbreaks_all.csv'))

