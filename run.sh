#!/bin/bash

OUTPUT_DIR="./output"
TEMP_DIR="./tmp"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "El directorio $OUTPUT_DIR donde guardamos los mapas no existe. Creando carpeta..."
    mkdir $OUTPUT_DIR
fi

if [ ! -d "$TEMP_DIR" ]; then
    echo "El directorio $TEMP_DIR donde guardamos los .CSV generados por la captura de SDR no existe. Creando carpeta..."
    mkdir $TEMP_DIR
fi

