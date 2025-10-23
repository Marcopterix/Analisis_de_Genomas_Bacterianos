#!/bin/bash

archivo_tsv="/home/user/Analisis_corridas/Corrida_virus/ID_muestras.tsv"
echo -e ${archivo_tsv}

# Leer el archivo CSV línea por línea
while IFS=$'\t' read -r ID Sinalab; do
    # Ignorar la primera línea (encabezados)
    if [[ "$idlab" != "ID" ]]; then
        # Renombrar los archivos .gz
        for archivo in *gz; do
            muestra=$(basename ${archivo} | cut -d '_' -f '1')
            exam=$(basename ${archivo} | cut -d '_' -f '2,3,4,5')
#echo -e ${muestra} ${exam}
##for archivo in *"$id"*.fastq.gz; do
            if [[ -e "$archivo" ]]; then
	if [[ ${muestra} == ${idlab} ]]; then
#echo -e ${ID} ${Sinalab}
                # Crear el nuevo nombre usando el ID de Sinalab
                nuevo_nombre="${ID}_${exam}"
#nuevo_nombre="${archivo//$id/$ID}"
                mv ${archivo} ${nuevo_nombre}
                echo "Renombrado: $archivo a $nuevo_nombre"
            else
                echo "Archivo no encontrado para ID: $idlab"
            fi
	fi
        done
    fi
done < ${archivo_tsv}
