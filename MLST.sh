#!/bin/bash

# Para descargar las bases de datos de pubMLST: mlst-download_pub_mlst -d . | bash
# Check schemes are installed: ../bin/mlst --list

echo -e "#######################################################################" "\n"
echo -e  ===== Determinación del MLST de los ensambles obtenidos con MLST ===== "\n"
echo -e "\t"                     ===== Inicio: $(date) ===== "\n"
echo -e "#######################################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfa="/home/admcenasa/Analisis_corridas/SPAdes/bacteria"
dirout="/home/admcenasa/Analisis_corridas/MLST"
#--------------------------------------------------------------------

cd ${dirfa}

for assembly in *.fa; do
    ID=$(basename ${assembly} | cut -d '-' -f '1')
    name=$(basename ${assembly} | cut -d '-' -f '2')

mlst ${assembly} > ${dirout}/${ID}_mlst_results.tsv

	done

# --------------------------------
# Conjuntar los archivos de salida
# --------------------------------

cd ${dirout}

echo -e "Muestra\tDatabase\tST\tAlelos" > ./MLST_assembly_results_all.tsv

for MLST in *_mlst_*; do
    ID=$(basename ${MLST} | cut -d '_' -f '1')
echo -e "\n$(cat ${MLST})"
done >> ./MLST_assembly_results_all.tsv

rm ./*_mlst_*

echo -e "#################################################################################" "\n"
echo -e  =============== Determinación del MLST sobre ensambles terminada  =============== "\n"
echo -e  "\t" =============== $(date) ============== "\n"
echo -e "##################################################################################"
