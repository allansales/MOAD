library("dplyr")
library("wordVectors")

cosSim_model <- function(w1, w2, modelo){
  cosineSimilarity(modelo[[w1]],modelo[[w2]]) %>% as.numeric()
}

create_pares <- function(x, y=NULL, a, b, modelo){
  
  targets = x  
  if(!is.null(y)){
    targets = c(x, y)  
  }
  
  features = c(a, b)
  
  pares = expand.grid(target = targets, feature = features)
  
  pares$target = pares$target %>% as.character()
  pares$feature = pares$feature %>% as.character()
  
  pares = pares %>%
    rowwise() %>%
    mutate(cos_sim = cosSim_model(target, feature, modelo))
  
  targets_a = pares %>% filter(feature %in% a)
  targets_b = pares %>% filter(feature %in% b)
  return(list(targets_a = targets_a, targets_b = targets_b))
}