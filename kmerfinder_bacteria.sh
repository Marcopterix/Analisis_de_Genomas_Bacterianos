#!/bin/bash

echo -e "########################################################################################################################" "\n"
echo -e === Ejecutar kmerfinder sobre ensambles obtenidos con SPAdes para la identificación taxonómica de bacterias === "\n"
echo -e                                        ===== Inicio: $(date) ===== "\n"
echo -e "#########################################################################################################################" "\n"

#---------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfa="/home/user/Analisis_corridas/SPAdes/bacteria"
dirout="/home/user/Analisis_corridas/kmerfinder/bacteria"
dirgen="/home/user/Analisis_corridas/Resultados_all_bacteria/Ensambles"
dirfq="/home/user/Analisis_corridas/Archivos_postrim/bacteria"
diroutfq="/home/user/Analisis_corridas/Resultados_all_bacteria/Archivos_trimming"
#---------------------------------------------------------

cd ${dirfa}

for assembly in *.fa*; do
    ID="$(basename ${assembly} | cut -d '-' -f '1')"
    ename="$(basename ${assembly} | cut -d '_' -f '1,2')"

# -----------------------------------------------------------------------
# Correr kmerfinder sobre los ensambles obtenidos con metaSPAdes o SPAdes
# -----------------------------------------------------------------------

kmerfinder_main.py -i ${assembly} \
              -db $KF_DB_PATH/bacteria/bacteria.ATG \
              -tax $KF_DB_PATH/bacteria/bacteria.tax \
              -o ${dirout}/KF_${ID}

# ----------------------------------------------------------------------------------------------------------------------
# Mover los resultados .txt y .spa un directorio atras, añadiendoles el ID de su muestra y eliminar la carpeta /KF_${ID}
# ----------------------------------------------------------------------------------------------------------------------

mv ${dirout}/KF_${ID}/results.txt ${dirout}/${ID}_results.txt
mv ${dirout}/KF_${ID}/results.spa ${dirout}/${ID}_results.spa
rm -R ${dirout}/KF_${ID}

done

# ------------------------------------------------------------------------------------
# Mover los ensambles a una carpeta nombrada con el genero del organismo identificado
# ------------------------------------------------------------------------------------

cd ${dirout}

for file in *spa; do
    genero=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    organism=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    ID=$(basename ${file} | cut -d '_' -f '1')

for assembly in ${dirfa}/*.fa; do
    assembly_ID=$(basename ${assembly} | cut -d '-' -f '1')

if [[ ${ID} != ${assembly_ID} ]]; then
       continue
 else

mkdir -p ${dirgen}/${genero}

echo -e "Moviendo ${assembly} a ${genero}"
     cp ${assembly} ${dirgen}/${genero}

        fi
    done
done

# ------------------------------------------------------------------------------------
# Mover los archivos trimmiados a una carpeta nombrada con el genero del organismo identificado
# ------------------------------------------------------------------------------------

cd ${dirout}

for file in *spa; do
    genero=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    organism=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    ID=$(basename ${file} | cut -d '_' -f '1')

for trim in ${dirfq}/*fastq.gz; do
    trim_ID=$(basename ${trim} | cut -d '_' -f '1')

if [[ ${ID} != ${trim_ID} ]]; then
       continue
 else
mkdir -p ${diroutfq}/${genero}

echo -e "Moviendo ${trim} a ${genero}"
     cp ${trim} ${diroutfq}/${genero}

        fi
    done
done


# -----------------------------------------------------
# Conjuntar los archivos .spa en uno solo de resultados
# -----------------------------------------------------

cd ${dirout}

for file in *.spa; do
    ename="$(basename ${file} | cut -d '_' -f '1')"
    echo -e "\n ########## ${ename} ########## \n$(cat ${file})"

done >> ./kmerfinder_results_all.tsv

rm *.txt
