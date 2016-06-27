###########################################
#       HACKATHON ENGIE DATA POWER        #
#-----------------------------------------#
#   05 -  Pr?paration de data pour APP    #
#-----------------------------------------#
#   CP : Xue ZHAO                         #
#-----------------------------------------#
#   Date de creation : le 25/06/2016      #
#   Date de modification : le 25/06/2016  #
###########################################

## ===================== PACKAGES =============================================== ##

library(dplyr)

## ===================== Lecture des RDATAs ===================================== ##

load("~/Google Drive/hackathon-datapower/r/dashboard/data/REF_BAT.RData")

estimation = function( T_obj # Temperature objective
                      ,code_postal
                      ,H_plafont
                      ,NB_etage
                      ,flag_1990 # 1 si apres 1990; sinon 0
                      ,moyen_chauff # gaz/electricite/autre
                      ,surface
                      ,tfuture # la temperature demain
                      ){
  
  ####-------------- Estimation du C1 --------------------------------------------#### 
  T_ex = read.csv( file = "data/tempmoyenne.csv",header = TRUE,sep = ";",dec = ",")
  T_ex$Date = as.Date(as.character(T_ex$Date),"%d/%m/%Y")
  T_ex$periode_chauff = (T_ex$Date >= "2016-01-01" & T_ex$Date <= "2016-03-20") | (T_ex$Date >= "2016-11-05" & T_ex$Date <= "2016-12-31")
  
  #T_obj = 21 # user
  
  T_ex$detra = ifelse((T_ex$periode_chauff) & (T_obj - T_ex$Tm > 0)
                      ,(T_obj - T_ex$Tm)
                      ,0)
  
  T_ex$augmentation_kwh = 22.9365 + 6.9576*T_ex$detra - 0.3019*(T_ex$detra^2)
  T_ex$tx_aug_kwh = T_ex$augmentation_kwh/22.93650
  
  ####-------------- TABLE REF --------------------------------------------------####
  detra = seq(0,30,by = 0.1)
  augmentation_kwh = 22.9365 + 6.9576*detra - 0.3019*(detra^2)
  REF = data.frame(detra,augmentation_kwh)
  REF$tx = REF$augmentation_kwh/22.9365
  jk = sum(T_ex$tx_aug_kwh[!T_ex$periode_chauff])
  kk = 1660/jk
  REF$c = REF$tx*kk
  REF$c1 = REF$c-kk
  REF$c3 = REF$c1/91
  
  
  ####-------------- Estimation du C2 --------------------------------------------#### 
  
  # code_postal = 75015 # user
  quartier = substr(code_postal,4,5)
  quartier_s = ifelse(quartier %in% c('10','11','19'),1,0)
  
  # H_plafont = 2.5 # user
  # NB_etage = 8 # user
  Hauteur_moyenne = H_plafont*NB_etage
  
  # flag_1990 = FALSE # user
  flag_annee = ifelse(flag_1990,1,0)
  
  # moyen_chauff = 'gaz' # user
  
  # surface = 34 # user
  
  if (moyen_chauff == 'autre') {
    Y_estimee = (5.713 - quartier_s * 0.06336
                 - 0.4903 * flag_annee
                 - 0.05313 * Hauteur_moyenne
                 - 0.09863 * REF_BAT$sum_energie_ind_moy[REF_BAT$quartier == quartier]
                 - 0.09949 * REF_BAT$Proba_autre_moy[REF_BAT$quartier == quartier]
                 - 2.095 * REF_BAT$Proba_rien_moy[REF_BAT$quartier == quartier]
                 + 3.875*10^(-7)*REF_BAT$b_tt_moy[REF_BAT$quartier == quartier]
                 - 4.294*10^(-5)*REF_BAT$s_tt_moy[REF_BAT$quartier == quartier]
                 + 0.2933 * REF_BAT$b_tx_res_moy[REF_BAT$quartier == quartier]
                 - 1.764 * REF_BAT$s_tx_res_moy[REF_BAT$quartier == quartier])
    
  } else {
    
    Y_estimee = (5.67 - quartier_s * 6.639 *10^(-2)
                 - 0.4824 * flag_annee
                 - 0.05185 * Hauteur_moyenne
                 - 2.650 * REF_BAT$Proba_rien_moy[REF_BAT$quartier == quartier]
                 + 4.774*10^(-7)*REF_BAT$b_tt_moy[REF_BAT$quartier == quartier]
                 - 5.037*10^(-5)*REF_BAT$s_tt_moy[REF_BAT$quartier == quartier]
                 + 0.2957 * REF_BAT$b_tx_res_moy[REF_BAT$quartier == quartier]
                 - 1.832 * REF_BAT$s_tx_res_moy[REF_BAT$quartier == quartier])
  }
  
  c2 = Y_estimee/3.358562
  
  #################### FORMULE FINALE ###########################
  
  # tfuture = 15
  Facture_estimee_du_jour = ifelse((T_obj - tfuture >= 0)
                                   ,(surface*REF$c3[REF$detra == (T_obj - tfuture)]*c2)
                                   ,0)
  
  T_ex$detra2 = as.factor(T_ex$detra)
  REF$detra2 = as.factor(REF$detra)
  jointure = T_ex %>% left_join(REF,by = "detra2")
  
  Facture_estimee_annuelle =  sum(ifelse((T_obj - T_ex$Tm >= 0)
                                         ,(surface*jointure$c3[jointure$detra.x == (T_obj - jointure$Tm)]*c2)
                                         ,0))*0.13*3
  
  #################### OUTPUT ###########################
  result = list()
  result[1] = Facture_estimee_du_jour
  result[2] = Facture_estimee_annuelle
  
  return(result)
  
}



####-------------- TABLE REF BAT --------------------------------------------------####
# bat_conso_estimee_ok$quartier = substr(bat_conso_estimee_ok$code_postal,4,5)
# REF_BAT = bat_conso_estimee_ok %>% group_by(quartier) %>% summarise( sum_energie_ind_moy = mean(sum_energie_ind,na.rm = TRUE)
#                                                                      ,Proba_autre_moy = mean(Proba_autre,na.rm = TRUE)
#                                                                      ,Proba_rien_moy = mean(Proba_rien,na.rm = TRUE)
#                                                                      ,b_tt_moy = mean(b_tt,na.rm = TRUE)
#                                                                      ,s_tt_moy = mean(s_tt,na.rm = TRUE)
#                                                                      ,b_tx_res_moy = mean(b_tx_res,na.rm = TRUE)
#                                                                      ,s_tx_res_moy = mean(s_tx_res,na.rm = TRUE))
# save(REF_BAT,file = paste(sep = "",path_dossier,"/REF_BAT.RData"))

# test = estimation( T_obj  = 21# Temperature objective
#                               ,code_postal = "75015"
#                               ,H_plafont = 2.5
#                               ,NB_etage = 8
#                               ,flag_1990 = FALSE# 1 si apres 1990; sinon 0
#                               ,moyen_chauff = 'electricite'# gaz/electricite/autre
#                               ,surface = 35
#                               ,tfuture = 20)
# 



