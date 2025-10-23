#!/bin/bash

echo -e "#####################################################################################################" "\n"
echo -e =====  Ejecutando SerotypeFinder para la ideantificación de formula antigénica de E.coli ===== "\n"
echo -e                                      ===== Inicio: $(date) ===== "\n"
echo -e "#####################################################################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfa="/home/admcenasa/Analisis_corridas/SPAdes/bacteria"
dirkf="/home/admcenasa/Analisis_corridas/kmerfinder/bacteria"
dir="/home/admcenasa/Analisis_corridas/serotypefinder"
dirout="/home/admcenasa/Analisis_corridas/Resultados_all_bacteria"
#--------------------------------------------------------------------

cd ${dirfa}

for file in ${dirkf}/*.spa; do
    gene=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2' | tr ' ' '_')
    organism=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    ID_org=$(basename ${file} | cut -d '_' -f '1')

for assembly in *.fa; do
    ID=$(basename ${assembly} | cut -d '-' -f '1')

# --------
# Control
# --------

if [[ ${ID} == ${ID_org} ]]; then
        echo -e "If control: ${ID} ${ID_org}"
if [[ ${organism} != "Escherichia_coli" ]]; then
        echo -e " ---------- ${ID} encontrado como ${organism}, no encontrado como Escherichia_coli ----------"
continue
        else
echo -e " ********** ${ID} encontrado como ${organism} **********" "\n"
echo -e "########################################"
echo -e "Corriendo SerotypeFinder sobre: ${ID}"
echo -e "########################################" "\n"


mkdir -p ${dir}/${ID}_tmp_SFout

serotypefinder.py -i ${assembly} \
                  -o ${dir}/${ID}_tmp_SFout \
                  -mp blastn \
                  -p $SF_DB_PATH \
                  -x

mv ${dir}/${ID}_tmp_SFout/results_tab.tsv ${dir}/${ID}_tmp_SFout/${ID}_results_tmp_SF.tsv
mv ${dir}/${ID}_tmp_SFout/${ID}_results_tmp_SF.tsv ${dir}/.

cat ${dir}/${ID}_results_tmp_SF.tsv | awk '{print $1"\t"$2"\t"$3"\t"$4}' | sed -e "1d" > ${dir}/${ID}_results_tmp.tsv

# ---------------------------------------------------
# Concatenar todos los archivos de salida en uno solo
# ---------------------------------------------------

sed -i '1i Database\tGen\tAntigen_prediction\tIdentity' ${dir}/${ID}_results_tmp.tsv

for SF in ${dir}/*results_tmp.tsv; do
    ID=$(basename ${SF} | cut -d '_' -f '1')
echo -e "\n ########## \t ${ID} \t ########## \n $(cat ${SF})"
done >> ${dir}/SF_results_all.tsv

	  fi
	fi
    done
done

# ---------------------------------------------------------------------------------------
# Crear carpeta de resultados finales en caso de que el archivo SF_results_all.tsv exista
# ---------------------------------------------------------------------------------------

cd ${dir}

if [[ -f ./SF_results_all.tsv ]]; then
mkdir -p ${dirout}/SerotypeFinder

rm -R ./*tmp*

mv ./SF_results_all.tsv ${dirout}/SerotypeFinder/

	fi

echo -e "#########################################################################################" "\n"
echo -e  =============== Identificación de formula antigénica de E.coli terminado  =============== "\n"
echo -e  =============== Fin: $(date) =============== "\n"
echo -e "#########################################################################################" "\n"
