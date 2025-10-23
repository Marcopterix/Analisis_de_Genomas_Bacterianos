#!/bin/bash

echo -e "#####################################################################################" "\n"
echo -e  ===== Identificación de genes de RAM en ensambles bacterianos con ResFinder ===== "\n"
echo -e          "\t"               ===== Inicio: $(date) ===== "\n"
echo -e "######################################################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfa="/home/user/Analisis_corridas/SPAdes/bacteria"
blastn_PATH="/home/user/Programas_bioinformaticos/ncbi-blast-2.16.0+/bin/blastn"
dirout="/home/user/Analisis_corridas/resfinder"
dirkf="/home/user/Analisis_corridas/kmerfinder/bacteria"
#--------------------------------------------------------------------

cd ${dirfa}

for RAM in *.fa; do
    ID=$(basename ${RAM} | cut -d '-' -f '1')

echo -e "########## ${ID} ##########"

python -m resfinder -ifa ${RAM} -b ${blastn_PATH} -o ${dirout}/${ID}_RF_out -db_res $RF_DB_PATH --acquired

mv ${dirout}/${ID}_RF_out/ResFinder_results_tab.txt ${dirout}/${ID}_RF_out/${ID}_RF_results_tmp.txt
mv ${dirout}/${ID}_RF_out/${ID}_RF_results_tmp.txt ${dirout}/.
rm -R ${dirout}/${ID}_RF_out

done

# ----------------------
# Correr solo PoinFinder
# ----------------------

echo -e "#####################################################################################" "\n"

echo -e ===== Identificación de mutaciones de RAM en ensambles bacterianos con PointFinder ===== "\n"

echo -e 		               ===== Inicio: $(date) ===== "\n"

echo -e "######################################################################################" "\n"

for especie in Salmonella Escherichia_coli Campylobacter Enterococcus_faecium Enterococcus_faecalis Neisseria_gonorrhoeae Staphylococcus_aureus Helicobacter_pylori Klebsiella Mycobacterium_tuberculosis Plasmodium_falciparum; do
    genero=$(basename ${especie} | cut -d '_' -f '1')

echo -e "Genero: ${genero}"

for file in ${dirkf}/*.spa; do
    gene=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2' | tr ' ' '_')
    organism=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    ID_org=$(basename ${file} | cut -d '_' -f '1')

for RAM in *.fa; do
    ID=$(basename ${RAM} | cut -d '-' -f '1')

########################################################
########### Mutaciones de RAM para Salmonella ##########
########################################################
case ${especie} in Salmonella)
     if [[ ${genero} == ${gene} ]]; then
echo -e "If control: ${genero} ${gene}"
    if [[ ${ID_org} == ${ID} ]]; then
echo -e "If control: ${ID_org} ${ID}"

python -m resfinder -ifa ${RAM} \
       -s "Salmonella" \
       -b ${blastn_PATH} \
       -o ${dirout}/${ID}_PF_out \
       -db_res $RF_DB_PATH \
       -db_point $PF_DB_PATH --point

mv ${dirout}/${ID}_PF_out/PointFinder_results.txt ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt
mv ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt ${dirout}/.
rm -R ${dirout}/${ID}_PF_out

 else
	continue
     fi
   fi
 ;;
########################################################
############# Mutaciones de RAM para E. coli ###########
########################################################
                   Escherichia_coli)
     if [[ ${especie} == ${organism} ]]; then
echo -e "If control: ${especie} ${organism}"
    if [[ ${ID_org} == ${ID} ]]; then
echo -e "If control: ${ID_org} ${ID}"

python -m resfinder -ifa ${RAM} \
       -s "Escherichia coli" \
       -b ${blastn_PATH} \
       -o ${dirout}/${ID}_PF_out \
       -db_res $RF_DB_PATH \
       -db_point $PF_DB_PATH --point

mv ${dirout}/${ID}_PF_out/PointFinder_results.txt ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt
mv ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt ${dirout}/.
rm -R ${dirout}/${ID}_PF_out

else
      continue
     fi
   fi
 ;;
######################################################################
############# Mutaciones de RAM para Staphylococcus_aureus ###########
######################################################################
                   Staphylococcus_aureus)
     if [[ ${especie} == ${organism} ]]; then
echo -e "If control: ${especie} ${organism}"
    if [[ ${ID_org} == ${ID} ]]; then
echo -e "If control: ${ID_org} ${ID}"

python -m resfinder -ifa ${RAM} \
       -s "Staphylococcus aureus" \
       -b ${blastn_PATH} \
       -o ${dirout}/${ID}_PF_out \
       -db_res $RF_DB_PATH \
       -db_point $PF_DB_PATH --point

mv ${dirout}/${ID}_PF_out/PointFinder_results.txt ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt
mv ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt ${dirout}/.
rm -R ${dirout}/${ID}_PF_out

else
      continue
     fi
   fi
 ;;
#####################################################################
############# Mutaciones de RAM para Enterococcus_faecalis###########
#####################################################################
                   Enterococcus_faecalis)
     if [[ ${especie} == ${organism} ]]; then
echo -e "If control: ${especie} ${organism}"
    if [[ ${ID_org} == ${ID} ]]; then
echo -e "If control: ${ID_org} ${ID}"

python -m resfinder -ifa ${RAM} \
       -s "Enterococcus faecalis" \
       -b ${blastn_PATH} \
       -o ${dirout}/${ID}_PF_out \
       -db_res $RF_DB_PATH \
       -db_point $PF_DB_PATH --point

mv ${dirout}/${ID}_PF_out/PointFinder_results.txt ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt
mv ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt ${dirout}/.
rm -R ${dirout}/${ID}_PF_out

else
      continue
     fi
   fi
 ;;
#####################################################################
############# Mutaciones de RAM para Enterococcus_faecium ###########
#####################################################################
                   Enterococcus_faecium)
     if [[ ${especie} == ${organism} ]]; then
echo -e "If control: ${especie} ${organism}"
    if [[ ${ID_org} == ${ID} ]]; then
echo -e "If control: ${ID_org} ${ID}"

python -m resfinder -ifa ${RAM} \
       -s "Enterococcus faecium" \
       -b ${blastn_PATH} \
       -o ${dirout}/${ID}_PF_out \
       -db_res $RF_DB_PATH \
       -db_point $PF_DB_PATH --point

mv ${dirout}/${ID}_PF_out/PointFinder_results.txt ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt
mv ${dirout}/${ID}_PF_out/${ID}_PF_results_tmp.txt ${dirout}/.
rm -R ${dirout}/${ID}_PF_out

#else
   #   continue
  #   fi
 #  fi
# ;;


	    fi
	   fi
	esac
     done
  done
done

#El_bueno: ResFinder_results_tab.txt
#Para PF: cat PointFinder_results.txt
#Predicción fenotipo: pheno_table.txt

# ---------------------------------------------------------------
# Conjuntar los archivos de genes y mutaciones en un solo archivo
# ---------------------------------------------------------------

# ----------------
##### Genes #####
# ----------------

cd ${dirout}

if compgen -G "./*RF_results_tmp.txt" > /dev/null; then
        for gen in *RF_results_tmp.txt; do
            ename=$(basename ${gen} | cut -d '_' -f '1')

echo -e "\n########## ${ename} ########## \n$(cat ${gen})"
        done >> ./Genes_ResFinder_all.tsv
rm ./*RF_results_tmp.txt
        fi

# ---------------------
##### Mutaciones #####
# ---------------------

if compgen -G "./*PF_results_tmp.txt" > /dev/null; then
        for mut in *PF_results_tmp.txt; do
            ename=$(basename ${mut} | cut -d '_' -f '1')

echo -e "\n########## ${ename} ########## \n$(cat ${mut})"
        done >> ./Mutaciones_PointFinder_all.tsv
rm *PF_results_tmp.txt
        fi

rm ${dirkf}/*spa

echo -e "#########################################################################################"
echo -e ========== Identificación de genes y mutaciones de RAM con RF y PF terminada  ==========
echo -e "\t"  		===== Fin: $(date) =====
echo -e "#########################################################################################"
