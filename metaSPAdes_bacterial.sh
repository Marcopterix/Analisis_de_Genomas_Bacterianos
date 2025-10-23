#!/bin/bash

echo -e "#############################################################" "\n"
echo -e ======= Ensamble de genomas bacterianos con metaSPAdes ======= "\n"
echo -e                 ===== Inicio: $(date) ===== "\n"
echo -e "##############################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfq="/home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria"
dirout="/home/admcenasa/Analisis_corridas/SPAdes/bacteria"
#--------------------------------------------------------------------

cd ${dirfq}

for R1 in *_R1_* ; do
    R2=${R1/_R1_/_R2_}
    ID="$(basename ${R1} | cut -d '_' -f '1')"

spades.py --meta -1 ${R1} -2 ${R2} \
          -t 25 \
          -o ${dirout}/${ID}_metaSPAdes

mv ${dirout}/${ID}_metaSPAdes/contigs.fasta ${dirout}/${ID}_metaSPAdes/${ID}-metaSPAdes-assembly.fasta
mv ${dirout}/${ID}_metaSPAdes/${ID}-metaSPAdes-assembly.fasta ${dirout}/.
rm -R ${dirout}/${ID}_metaSPAdes

# ----------------------------------
# Eliminar contigs menores a 100 pb
# ----------------------------------

cd ${dirout}

seqtk seq -L 100 ${dirout}/${ID}-metaSPAdes-assembly.fasta > ${dirout}/${ID}-metaSPAdes-assembly.fa

chmod -R 775 ${dirout}/${ID}-metaSPAdes-assembly.fa

rm ${dirout}/${ID}-metaSPAdes-assembly.fasta

	done

echo -e "##################################################################"
echo -e                   ===== Fin: $(date) =====
echo -e "##################################################################"
