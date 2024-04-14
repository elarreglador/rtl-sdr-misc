#!/bin/bash

# VARIABLES

OUTPUT_DIR="./output"
TEMP_DIR="./tmp"
# FREC_INICIO
# MHZ_FINAL

# PREPARAMOS EL AREA DE TRABAJO

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "El directorio $OUTPUT_DIR donde guardamos los mapas no existe. Creando carpeta..."
    mkdir $OUTPUT_DIR
fi

if [ ! -d "$TEMP_DIR" ]; then
    echo "El directorio $TEMP_DIR donde guardamos los .CSV generados por la captura de SDR no existe. Creando carpeta..."
    mkdir $TEMP_DIR
fi

# PEDIMOS AL USUARIO EL RANGO DE FRECUENCIA INICIAL A ESCANEAR

while true; do
    echo "Por favor, ingresa el rango inicial de frecuencia de captura en Hz (ej: 88000 para radio comercial):"
    read FREC_INICIO
    
    # Verifica si la entrada es un número entero
    if [[ $FREC_INICIO =~ ^[0-9]+$ ]]; then
        break  # Sale del bucle si es un número entero válido
    else
        echo "ERROR: '$FREC_INICIO' no es un número entero. Inténtalo de nuevo."
    fi
done

# PEDIMOS AL USUARIO EL RANGO DE FRECUENCIA FINAL

while true; do
    echo "Por favor, ingresa el rango final de captura en Hz (ej: 108000 para radio comercial):"
    read FREC_FINAL
    
    # Verifica si la entrada es un número entero
    # Verifica si la entrada es mayor a la frecuencia de inicio
    if [[ $FREC_FINAL =~ ^[0-9]+$  &&  $FREC_FINAL -gt $FREC_INICIO ]]; then
        break 
    else
        echo "ERROR: '$FREC_FINAL' no es un número entero y/o la frecuencia final no es superior a la inicial. Inténtalo de nuevo."
    fi

done

echo $FREC_INICIO " - " $FREC_FINAL

