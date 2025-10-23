#!/bin/bash

echo -e "###################################################################" "\n"
echo -e ======= Iniciando ensamble de genomas bacterianos con SPAdes ======= "\n"
echo -e  "\t"               ===== Inicio: $(date) ===== "\n"
echo -e "###################################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirfq="/home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria"
dirout="/home/admcenasa/Analisis_corridas/SPAdes/bacteria"
#--------------------------------------------------------------------

cd ${dirfq}

for R1 in *_R1_* ; do
    R2=${R1/_R1_/_R2_}
    ID="$(basename ${R1} | cut -d '_' -f '1')"

spades.py --isolate -1 ${R1} -2 ${R2} \
            -t 25 \
            -o ${dirout}/${ID}_SPAdes

mv ${dirout}/${ID}_SPAdes/contigs.fasta ${dirout}/${ID}_SPAdes/${ID}-SPAdes-assembly.fasta
mv ${dirout}/${ID}_SPAdes/${ID}-SPAdes-assembly.fasta ${dirout}/.
rm -R ${dirout}/${ID}_SPAdes

# --------------------------------------------
# Eliminar todos los contigs menores a 100 pb
# --------------------------------------------

seqtk seq -L 100 ${dirout}/${ID}-SPAdes-assembly.fasta > ${dirout}/${ID}-SPAdes-assembly.fa
chmod -R 775 ${dirout}/${ID}-SPAdes-assembly.fa

rm ${dirout}/${ID}-SPAdes-assembly.fasta

done

echo -e "##################################################################" "\n"
echo -e "\t" ===== Ensamble de genomas bacterianos terminado: $(date) ===== "\n"
echo -e "##################################################################" "\n"
