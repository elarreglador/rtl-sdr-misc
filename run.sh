#!/bin/bash



# VARIABLES

# CONTENEDOR
# FECHA_ACTUAL
# FREC_FINAL
# FREC_INICIO
# MINUTOS 
OUTPUT_DIR="./output"
# TAREA
TEMP_DIR="./tmp"




# FUNCIONES

crea_directorios_si_no_existen() {
    if [ ! -d "$OUTPUT_DIR" ]; then
        echo "El directorio $OUTPUT_DIR donde guardamos los mapas no existe. Creando carpeta..."
        mkdir $OUTPUT_DIR
    fi

    if [ ! -d "$TEMP_DIR" ]; then
        echo "El directorio $TEMP_DIR donde guardamos los .CSV generados por la captura de SDR no existe. Creando carpeta..."
        mkdir $TEMP_DIR
    fi
}

crea_heatmap() {
    echo "Creando mapa de frecuencias en $OUTPUT_DIR con heatmap:"

    # python3 heatmap/heatmap.py out.csv heatmap.png
    echo "python3 heatmap/heatmap.py ${TEMP_DIR}/out.csv ${OUTPUT_DIR}/${FECHA_ACTUAL_FORMATEADA}.png"
    python3 heatmap/heatmap.py ${TEMP_DIR}/out.csv ${OUTPUT_DIR}/${FREC_INICIO}-${FREC_FINAL}_${FECHA_ACTUAL_FORMATEADA}.png
}

lanza_captura() {
    FECHA_ACTUAL_FORMATEADA=$(date +"%Y%m%d%H%M")
    FECHA_ACTUAL=`date`
    echo "Inicio de captura el $FECHA_ACTUAL"

    # rtl_power -f 88M:108M:40k -e 5m ./output/out.csv
    echo "Lanzamos rtl_power:"
    echo "rtl_power -f ${FREC_INICIO}M:${FREC_FINAL}M:${CONTENEDOR}k -e ${MINUTOS}m ${TEMP_DIR}/out.csv"
    echo "*************************** rtl_power ********************************"
    rtl_power -f ${FREC_INICIO}M:${FREC_FINAL}M:${CONTENEDOR}k -e ${MINUTOS}m ${TEMP_DIR}/out.csv
    echo "**********************************************************************"

    FECHA_ACTUAL=`date`
    echo "Fin de captura el $FECHA_ACTUAL"
    echo
}

menu_principal() {
    while true; do

        echo "*** MENU ***"
        echo
        echo "0) Salir"
        echo "1) Escanear un rango de frecuencia"
        echo "2) Escanear un rango de frecuencia en bucle"
        echo "3) Escanear varios rangos de frecuencias consecutivos (uno tras otro)"
        echo "4) Escanear varios rangos de frecuencias consecutivos (uno tras otro) en bucle"
        echo
        read -p "Selecciona una opción y pulsa intro: " _OPCION

        case $_OPCION in
            0)
                echo "Cerrando ..."
                exit 0
                ;;
            1)
                return 1
                ;;
            2)
                return 2
                ;;
            3)
                return 3
                ;;
            4)
                return 4
                ;;
            *)
                echo "Opción inválida. Por favor, selecciona una opción del 0 al 4."
                ;;
        esac
    done
    
}

pide_frecuencia_final() {
    while true; do
        echo "Por favor, ingresa el rango final de captura en MHz (ej: 108 para radio comercial):"
        read _FREC_FINAL
        
        # Verifica si la entrada es un número entero
        # Verifica si la entrada es mayor a la frecuencia de inicio
        if [[ $_FREC_FINAL =~ ^[0-9]+$  &&  $_FREC_FINAL -gt $FREC_INICIO ]]; then
            break 
        else
            echo "ERROR: '$_FREC_FINAL' no es un número entero y/o la frecuencia final no es superior a la inicial. Inténtalo de nuevo."
        fi

    done
    echo
    return $_FREC_FINAL
}

pide_frecuencia_inicial() {
    while true; do
        echo "Por favor, ingresa el rango inicial de frecuencia de captura en MHz (ej: 88 para radio comercial):"
        read _FREC_INICIO
        
        # Verifica si la entrada es un número entero
        if [[ $_FREC_INICIO =~ ^[0-9]+$ ]]; then
            break  # Sale del bucle si es un número entero válido
        else
            echo "ERROR: '$_FREC_INICIO' no es un número entero. Inténtalo de nuevo."
        fi
    done
    echo
    return $_FREC_INICIO
}

pide_medida_del_contenedor() {
    while true; do
        echo "Por favor, ingresa el tamaño del contenedor. esto es inversamente proporcional al tamaño de la imagen que obtendremos, cuanto mas grande, menos resolucion tendra la imagen final (recomendado 25-100)"
        read _CONTENEDOR
        
        # Verifica si la entrada es un número entero
        if [[ $_CONTENEDOR =~ ^[0-9]+$ ]]; then
            break  # Sale del bucle si es un número entero válido
        else
            echo "ERROR: '$_CONTENEDOR' no es un número entero. Inténtalo de nuevo."
        fi
    done
    echo
    return $_CONTENEDOR
}

pide_tiempo_de_escaneo() {
    while true; do
        echo "Cuantos minutos vamos a estar capturando informacion?:"
        read _MINUTOS
        
        # Verifica si la entrada es un número entero
        if [[ $_MINUTOS =~ ^[0-9]+$ ]]; then
            break 
        else
            echo "ERROR: '$_MINUTOS' no es un número entero. Inténtalo de nuevo."
        fi
    done
    echo
    return $_MINUTOS
}

tarea1() { # Escanear un rango de frecuencia
    # PEDIMOS AL USUARIO EL RANGO DE FRECUENCIA INICIAL A ESCANEAR
    pide_frecuencia_inicial
    FREC_INICIO=$?
    # PEDIMOS AL USUARIO EL RANGO DE FRECUENCIA FINAL
    pide_frecuencia_final
    FREC_FINAL=$?
    # PEDIMOS AL USUARIO EL TAMAñO DEL CONTENEDOR (PIXEL)
    pide_medida_del_contenedor
    CONTENEDOR=$?
    # PEDIMOS AL USUARIO TIEMPO DE ESCANEO
    pide_tiempo_de_escaneo
    MINUTOS=$?
    # LANZAMOS LA CAPTURA
    lanza_captura
    # CREAMOS EL MAPA DE FRECUENCIAS
    crea_heatmap
}



# --- MAIN ---

# PREPARAMOS EL AREA DE TRABAJO
crea_directorios_si_no_existen

while true; do
    # MENU PRINCIPAL
    menu_principal
    TAREA=$?

    if [ $TAREA == "1" ]; then
        echo "TAREA: Escanear un rango de frecuencia"
        tarea1
    fi
done





