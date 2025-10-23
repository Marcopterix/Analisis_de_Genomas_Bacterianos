#!/bin/bash

echo -e "#########################################################################" "\n"
echo -e ===== Moviendo archivos de resultados obtenidos a una sola carpeta ===== "\n"
echo -e "\t" ===== Inicio: $(date) ===== "\n"
echo -e "#########################################################################" "\n"

#-------------------------------------------------------------------
# Definir rutas de directorios de entrada y salida
dirout="/home/admcenasa/Analisis_corridas/Resultados_all_bacteria"
dirfq="/home/admcenasa/Analisis_corridas/fastQC/bacteria"
dirfqpt="/home/admcenasa/Analisis_corridas/fastQC_ptrim/bacteria"
dirmqc="/home/admcenasa/Analisis_corridas/fastQC/bacteria/multiqc"
dirmqcpt="/home/admcenasa/Analisis_corridas/fastQC_ptrim/bacteria/multiqc"
#dirk2=""
dirbk="/home/admcenasa/Analisis_corridas/Bracken/bacteria"
dirkf="/home/admcenasa/Analisis_corridas/kmerfinder/bacteria"
dirsMLST="/home/admcenasa/Analisis_corridas/stringMLST"
dirMLST="/home/admcenasa/Analisis_corridas/MLST"
dirRAM="/home/admcenasa/Analisis_corridas/AMRFinder"
direns="/home/admcenasa/Analisis_corridas/SPAdes/bacteria"
dirlc="/home/admcenasa/Analisis_corridas/Corrida_bacterias"
dirpt="/home/admcenasa/Analisis_corridas/Archivos_postrim/bacteria"
#--------------------------------------------------------------------

mkdir -p ${dirout}
cd ${dirout}

#-----------------------------------
mkdir -p FastQC
mkdir -p FastQC/Lecturas
mkdir -p FastQC/Lecturas_pt
mkdir -p FastQC/Lecturas/multiQC
mkdir -p FastQC/Lecturas_pt/multiQC
#-----------------------------------
mv ${dirfq}/*fastqc* ./FastQC/Lecturas
mv ${dirfqpt}/*fastqc* ./FastQC/Lecturas_pt
rm -R ${dirmqc}/multiqc_data
mv ${dirmqc}/*multiqc* ./FastQC/Lecturas/multiQC
mv ${dirmqcpt}/postrimm_multiqc* ./FastQC/Lecturas_pt/multiQC
rm -R ${dirmqcpt}/multiqc_data

#-----------------------------------
mkdir -p KRAKEN2
#-----------------------------------
#mv ${dirk2}/*kraken* ./KRAKEN2
mv ${dirbk}/* ./KRAKEN2

#-----------------------------------
mkdir -p KmerFinder
#-----------------------------------
mv ${dirkf}/*results* ./KmerFinder

#-----------------------------------
mkdir -p MLST
#-----------------------------------
mv ${dirsMLST}/*MLST* ./MLST
mv ${dirMLST}/MLST* ./MLST

#-----------------------------------
mkdir -p RAM
#-----------------------------------
mv ${dirRAM}/* ./RAM

#-----------------------------------
mkdir -p Estadisticos
#-----------------------------------
mv ${dirfq}/estadisticos/*stats* ./Estadisticos
mv ${dirfqpt}/estadisticos/*stats_pt* ./Estadisticos
mv ${direns}/estadisticos/*global* ./Estadisticos

#-----------------------------------
mkdir -p Lecturas_crudas
#-----------------------------------
mv ${dirlc}/*fastq.gz ./Lecturas_crudas

rm ${direns}/*fa
rm -R ${dirpt}/*
