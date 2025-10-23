#!/bin/bash

echo -e "##################################################################################################" "\n"
echo -e ===== Ejecutando SeqSero2 sobre ensambles para la ideantificación de serotipos de Salmonella ===== "\n"
echo -e                                   ===== Inicio: $(date) ===== "\n"
echo -e "##################################################################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfa="/home/admcenasa/Analisis_corridas/SPAdes/bacteria"
dirkf="/home/admcenasa/Analisis_corridas/kmerfinder/bacteria"
dirss2="/home/admcenasa/Analisis_corridas/seqsero2"
dirout="/home/admcenasa/Analisis_corridas/Resultados_all_bacteria"
#--------------------------------------------------------------------

cd ${dirfa}

for file in ${dirkf}/*.spa; do
    gene=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2' | tr ' ' '_')
    organism=$(cat ${file} | sed -n '2p' | cut -d ' ' -f '2,3' | tr ' ' '_')
    ID_org=$(basename ${file} | cut -d '_' -f '1')

for assembly in *.fa; do
    ID=$(basename ${assembly} | cut -d '-' -f '1')

# ---------
# Control
# ---------

if [[ ${ID} == ${ID_org} ]]; then
        echo -e "If control: ${ID} ${ID_org}"
if [[ ${gene} != "Salmonella" ]]; then
        echo -e " ---------- ${ID} encontrado como ${organism}, no encontrado como Salmonella ----------"
continue
	else

echo -e "********** ${ID} encontrado como ${gene} **********" "\n"
echo -e "###################################"
echo -e "Corriendo SeqSero2 sobre: ${ID}"
echo -e "###################################" "\n"

SeqSero2_package.py -t 4 \
                    -i ${assembly} \
                    -m k \
                    -d ${dirss2}/${ID}_tmp_SeqSero2out \
                    -p 15

mkdir -p ${dirss2}/SeqSero2_log

mv ${dirss2}/${ID}_tmp_SeqSero2out/SeqSero_log.txt ${dirss2}/${ID}_tmp_SeqSero2out/${ID}_SeqSero_log.txt
mv ${dirss2}/${ID}_tmp_SeqSero2out/${ID}_SeqSero_log.txt ${dirss2}/SeqSero2_log/.

# ------------------------------------------
# Renombrar y mover los archivos *result.tsv
# ------------------------------------------

mv ${dirss2}/${ID}_tmp_SeqSero2out/SeqSero_result.tsv ${dirss2}/${ID}_tmp_SeqSero2out/${ID}_tmp_result.tsv
mv ${dirss2}/${ID}_tmp_SeqSero2out/${ID}_tmp_result.tsv ${dirss2}/
cat ${dirss2}/${ID}_tmp_result.tsv | sed -e "1d" | tr ' ' '_' > ${dirss2}/${ID}_tmp_filt.tsv

# -------------------------------------
# Modificar los archivos .tsv de salida
# -------------------------------------

cat ${dirss2}/${ID}_tmp_filt.tsv >> ${dirss2}/SeqSero2_tmp_filt.tsv | uniq

           fi
	fi
    done
done

cd ${dirss2}

if [[ -f ./SeqSero2_tmp_filt.tsv ]]; then

sed -i '1i Sample_name\tOutput_directory\tInput_files\tO_antigen_prediction\tH1_antigen_prediction(fliC)\tH2_antigen_prediction(fljB)\tPredicted_identification\tPredicted_antigenic_profile\tPredicted_serotype\tNote' ./SeqSero2_tmp_filt.tsv
awk '{print $1"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10}' ./SeqSero2_tmp_filt.tsv > ./SeqSero2_result_filt.tsv

rm -R *tmp*

	fi

if [[ -f ./SeqSero2_result_filt.tsv ]]; then
if [[ -d ./SeqSero2_log ]]; then
mkdir -p ${dirout}/SeqSero2

mv ./SeqSero2_result_filt.tsv ${dirout}/SeqSero2/
mv ./SeqSero2_log ${dirout}/SeqSero2/

      fi
    fi

echo -e "###################################################################################" "\n"
echo -e  =============== Identificación de serotipo de Salmonella terminado  =============== "\n"
echo -e  =============== Fin: $(date) =============== "\n"
echo -e "###################################################################################" "\n"
