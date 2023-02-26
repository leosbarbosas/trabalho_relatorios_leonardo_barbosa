library(geobr)
library(sf)
library(datazoom.amazonia)

data <- load_ppm(dataset = "ppm_aquaculture",
                 raw_data = FALSE,
                 geo_level = "country",
                 time_period = 2015:2018)
deter_amz <- load_deter(dataset = 'deter_amz',
                        raw_data = FALSE)



library(ggplot2)
library(datazoom.amazonia)

data <- load_ppm(dataset = "ppm_cow_farming",
                 raw_data = TRUE,
                 geo_level = "state",
                 time_period = 2005:2015,
                 language = "pt")

data$ano <- as.numeric(data$ano)

data <- dplyr::filter(data,unidade_da_federacao %in% c('Pará', 'Mato Grosso','Amazonas','Rondônia','Roraima','Acre','Tocantins','Maranhão','Amapá'))

write.csv(data,'dados/dados_pecuaria.csv')

ggplot(data = data, aes(x = ano, y = valor, group = unidade_da_federacao, colour = unidade_da_federacao)) +
  geom_line()


data2 <- load_ibama(dataset = "collected_fines", raw_data = FALSE,
                   states = "BA", language = "pt")
