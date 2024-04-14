#!/bin/bash

# VARIABLES

OUTPUT_DIR="./output"
TEMP_DIR="./tmp"
# FREC_INICIO
# FREC_FINAL
# CONTENEDOR
# MINUTOS 
# FECHA_ACTUAL



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
    echo "Por favor, ingresa el rango inicial de frecuencia de captura en MHz (ej: 88 para radio comercial):"
    read FREC_INICIO
    
    # Verifica si la entrada es un número entero
    if [[ $FREC_INICIO =~ ^[0-9]+$ ]]; then
        break  # Sale del bucle si es un número entero válido
    else
        echo "ERROR: '$FREC_INICIO' no es un número entero. Inténtalo de nuevo."
    fi
done
echo

# PEDIMOS AL USUARIO EL RANGO DE FRECUENCIA FINAL

while true; do
    echo "Por favor, ingresa el rango final de captura en MHz (ej: 108 para radio comercial):"
    read FREC_FINAL
    
    # Verifica si la entrada es un número entero
    # Verifica si la entrada es mayor a la frecuencia de inicio
    if [[ $FREC_FINAL =~ ^[0-9]+$  &&  $FREC_FINAL -gt $FREC_INICIO ]]; then
        break 
    else
        echo "ERROR: '$FREC_FINAL' no es un número entero y/o la frecuencia final no es superior a la inicial. Inténtalo de nuevo."
    fi

done
echo

# PEDIMOS AL USUARIO EL TAMAñO DEL CONTENEDOR (PIXEL)

while true; do
    echo "Por favor, ingresa el tamaño del contenedor. esto es inversamente proporcional al tamaño de la imagen que obtendremos, cuanto mas grande, menos resolucion tendra la imagen final (recomendado 25-100)"
    read CONTENEDOR
    
    # Verifica si la entrada es un número entero
    if [[ $CONTENEDOR =~ ^[0-9]+$ ]]; then
        break  # Sale del bucle si es un número entero válido
    else
        echo "ERROR: '$CONTENEDOR' no es un número entero. Inténtalo de nuevo."
    fi
done
echo

# PEDIMOS AL USUARIO TIEMPO DE ESCANEO

while true; do
    echo "Cuantos minutos vamos a estar capturando informacion?:"
    read MINUTOS
    
    # Verifica si la entrada es un número entero
    if [[ $MINUTOS =~ ^[0-9]+$ ]]; then
        break 
    else
        echo "ERROR: '$MINUTOS' no es un número entero. Inténtalo de nuevo."
    fi
done
echo

# LANZAMOS LA CAPTURA

FECHA_ACTUAL=`date`
echo "Inicio de captura el $FECHA_ACTUAL"

# rtl_power -f 100M:108M:40k -e 5m ./output/out.csv
echo "Lanzamos rtl_power:"
echo "rtl_power -f ${FREC_INICIO}M:${FREC_FINAL}M:${CONTENEDOR}k -e ${MINUTOS}m ${TEMP_DIR}/out.csv"
rtl_power -f ${FREC_INICIO}M:${FREC_FINAL}M:${CONTENEDOR}k -e ${MINUTOS}m ${TEMP_DIR}/out.csv

FECHA_ACTUAL=`date`
echo "Fin de captura el $FECHA_ACTUAL"

# CREAMOS EL MAPA DE FRECUENCIAS

