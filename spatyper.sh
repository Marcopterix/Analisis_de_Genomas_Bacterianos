#!/bin/bash

echo -e "#######################################################################################################" "\n"
echo -e ===== Ejecutando spaTyper sobre ensables de para la identificación de spa tipos en Staphylococcus ===== "\n"
echo -e                             ===== Inicio: $(date)  ===== "\n"
echo -e "#######################################################################################################" "\n"

#----------------------------------------
dirfa="$HOME/Analisis_corridas/SPAdes/bacteria"
dirkf="$HOME/Analisis_corridas/kmerfinder/bacteria"
dirst="$HOME/Analisis_corridas/spaTyper"
dirout="$HOME/Analisis_corridas/Resultados_all_bacteria"
#----------------------------------------

cd ${dirfa}

for kf in ${dirkf}/*.spa; do
    gene=$(cat ${kf} | sed -n '2p' | cut -d ' ' -f '2' | tr ' ' '_')
    org=$(cat ${kf} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    ID_org=$(basename ${kf} | cut -d '_' -f '1')

for assembly in *.fa; do
    ID=$(basename ${assembly} | cut -d '-' -f '1')


#----------------------------------------

if [[ ${ID} == ${ID_org} ]]; then
	echo -e "If control: ${ID} ${ID_org}"

if [[ ${org} != "Staphylococcus_aureus" ]]; then
	echo -e "---------- ${ID} encontrado como ${org}, no encontrado como Staphylococcus aureus. ---------- \n \n Saltando... \n"

continue

	else

echo -e "********** ${ID} encontrado como ${org} **********" "\n"
echo -e "###################################"
echo -e "Corriendo spaTyper sobre: ${ID}"
echo -e "###################################" "\n"

spaTyper -f ${assembly} \
         -r ${SPT_DB_PATH}/sparepeats.fasta \
         -o ${SPT_DB_PATH}/spatypes.txt \
         --output ${dirst}/${ID}_ST.txt


cat ${dirst}/${ID}_ST.txt | sed -e "1d" > ${dirst}/${ID}_ST_tmp.txt
sed -i '1i Contig_ID\tRepeats\tspaType' ${dirst}/${ID}_ST_tmp.txt
rm ${dirst}/${ID}_ST.txt


	   fi
        fi
    done
done

#-----------------------------------------------------------------

if compgen -G ${dirst}/*_ST_tmp.txt > /dev/null; then

for spa in ${dirst}/*_ST_tmp.txt; do
    ID=$(basename ${spa} | cut -d '_' -f '1')

    echo -e "\n ########## ${ID} ########## \n $(cat ${spa})" >> ${dirst}/spaTyper_results_all.tsv

	done
     fi

 rm ${dirst}/*_ST_tmp.txt
#-----------------------------------------------------------------

cd ${dirst}

if [[ -f ./spaTyper_results_all.tsv ]]; then

mkdir -p ${dirout}/SpaTyper

mv ./spaTyper_results_all.tsv ${dirout}/SpaTyper

	fi

echo -e "#######################################################################" "\n"
echo -e ========== Identificación de spaType en S. aureus terminado  ========== "\n"
echo -e ========== Fin: $(date)  ========== "\n"
echo -e "#######################################################################" "\n"
