library(geobr)
library(sf)
library(ggplot2)
library(dplyr)
library(datazoom.amazonia)
library(gt)

# load, organize and save livestock data
data <- load_ppm(dataset = "ppm_cow_farming",
                 raw_data = TRUE,
                 geo_level = "state",
                 time_period = 2005:2015,
                 language = "pt")

data$ano <- as.numeric(data$ano)

data <- dplyr::filter(data,unidade_da_federacao %in% c('Pará', 'Mato Grosso','Amazonas','Rondônia','Roraima','Acre','Tocantins','Maranhão','Amapá'))

write.csv(data,'dados/dados_pecuaria.csv')


# join livestock data with spatial data and save the result
state <- read_state(code_state = 'all', year=2010, simplified=T) |>
  dplyr::filter(abbrev_state %in% c('PA','MT','AM','RO','RR','AC','TO','MA','AP'))

colnames(state)[3] <- 'unidade_da_federacao'

data2015 <- filter(data,ano == 2015)

state2015 <- left_join(state,data2015,by="unidade_da_federacao")

dev.new()
png(file="img/livestock_amz.png")
plot(state2015['valor'],axes=T,key.pos = 1)
dev.off()


# get fines data
fines <- load_ibama(dataset = "collected_fines", raw_data = FALSE,
                   states = 'all', language = "pt") |> filter(uf %in% c('PA','MT','AM','RO','RR','AC','TO','MA','AP'))

fines$count <- 1

fines$valor_pago <- as.numeric(gsub(",", ".", gsub("\\.", "", fines$valor_pago)))

fines_sum <- fines |> select(c(uf, valor_pago,count)) |> group_by(uf) |> summarise(across(c(valor_pago,count),(sum)))

colnames(fines_sum) <- c('Estado','Valor total de multas pagas (1991-2023)','Total de multas aplicadas (1991-2023)')

write.csv(fines_sum,'dados/multas.csv')

