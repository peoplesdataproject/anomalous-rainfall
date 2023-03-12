library(tidyverse)

lns <- readLines('https://www.cpc.ncep.noaa.gov/data/indices/soi')[88:161]
lns <- map(lns, ~str_replace_all(.x, '-999.9', ' NA ') %>% 
      str_remove(., '\\s$') %>% 
      str_split(., '\\s+') %>% 
      .[[1]] %>% 
      matrix(., nrow = 1)
      ) 
enso_matrix = matrix(nrow = length(lns)-1, ncol = 13)
for(i in 1:(length(lns)-1)){
  enso_matrix[i,] <- lns[[i+1]]
}

enso_data <- as_tibble(enso_matrix) %>% setNames(as.character(lns[[1]][-length(lns[[1]])])) %>% 
  mutate_all(as.numeric) %>% 
  pivot_longer(2:last_col(), values_to = 'Index') %>% 
  mutate(Date = as.Date(paste0(YEAR,'-',tolower(name),'-01'), format = '%Y-%b-%d')) %>% 
  relocate(Date) %>% 
  select(-YEAR, -name) %>% 
  filter(complete.cases(Index))

rm(list = c('lns','enso_matrix','i'))
