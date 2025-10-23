#!/bin/bash

echo -e "###############################################################################" "\n"
echo -e              ===== Filtrando de lecturas de interes en equinos con bowtie2 ===== "\n"
echo -e                         ===== Inicio: $(date)  ===== "\n"
echo -e "###############################################################################" "\n"

#Para indexar una secuencia fasta a la base de datos de bowtie2: bowtie2-build genome.fasta bt2_db_virus

# --------------------------------------------------------------
# Moverse al directorio donde se encuentran las lecturas limpias
# ---------------------------------------------------------------

cd /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria

# ---------------------------------------------------------------------------------------
# Alinear y filtrar las lecturas concordantes con virus al archivo ${ID}_trim_bt.fastq.gz
# ---------------------------------------------------------------------------------------

for r1 in *_R1_*; do
    r2=${r1/_R1_/_R2_}
    ID=$(basename ${r1} | cut -d '_' -f '1')
echo -e "\n" "########## ${ID} ##########" "\n"

bowtie2 --local  -p 43 --ignore-quals --very-sensitive-local --reorder --threads 42 \
        --al-conc-gz /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/${ID}_trim_bt.fastq.gz \
        -x /home/admcenasa/db/bowtie2_db/old/Equus/bt2_db_microsat -1 ${r1} -2 ${r2}  \
        -S /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/${ID}_align.sam
#Para lecturas no alineadas: --un-conc-gz /home/secuenciacion_cenasa/Programas_Bioinformaticos/bowtie2-2.5.3-linux-x86_64/${ID}_notalig.fastq.gz
#--al-conc-gz /home/admcenasa/Analisis_corridas/Archivos_postrim/virus/bowtie_filter/${ID}_trim_bt.fastq.gz \

# ----------------------------------------
# Renombrar los archivos de salida R1 y R2
# ----------------------------------------

mv /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/${ID}_trim_bt.fastq.1.gz /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/${ID}_R1_trim_bt.fastq.gz
mv /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/${ID}_trim_bt.fastq.2.gz /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/${ID}_R2_trim_bt.fastq.gz
chmod -R 775 /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/*trim_bt.fastq*
rm /home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria/bowtie_filter/*align.sam*

done

echo -e "#############################################################" "\n"
echo -e          "\t"         ===== Fin: $(date)  ===== "\n"
echo -e "#############################################################" "\n"
