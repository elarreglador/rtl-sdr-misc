#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from datetime import datetime 
import time # pausas
import os # rutas y directorios
import subprocess # lanzar comandos



def menu_opciones():
    """
    Muestra un menú de opciones y ejecuta una acción basada en la selección del usuario.
    El bucle continúa hasta que el usuario ingresa '0' para salir.
    """
    opcion = None # Inicializamos opcion como None para que el bucle se ejecute al menos una vez

    try:
        while opcion != '0':
            # Mostrar las opciones al usuario
            print("\n--- Menú de Opciones ---")
            print("1. Escanear un rango de frecuencia")
            print("2. Escanear un rango de frecuencia en bucle")
            print("3. Escanear varios rangos de frecuencias consecutivos (uno tras otro)")
            print("4. Escanear varios rangos de frecuencias consecutivos (uno tras otro) en bucle")
            print("0. Salir")
            print("------------------------")

            # Pedir al usuario que elija una opción
            opcion = input("Por favor, elige una opción: ")

            # Evaluar la opción elegida
            if opcion == '1':
                print("Seleccionada opcion 1.")
                opcion1()
            elif opcion == '2':
                print("Seleccionada opcion 2.")
                opcion2()
            elif opcion == '3':
                print("Seleccionada opcion 3.")
                opcion3()
            elif opcion == '4':
                print("Seleccionada opcion 4.")
                opcion4()
            elif opcion == '0':
                print("Saliendo del programa.")
            else:
                print("Opción no válida. Por favor, elige una opción entre 0 y 4.")
    except KeyboardInterrupt:
        # Este bloque se ejecuta cuando se presiona Ctrl+C
        print("\n¡Ctrl+C detectado! Saliendo de forma segura...")



def scan(inicio, final, resolucion, minutos):
    #rtl_power -f 88M:108M:40k -e 5m ./output/out.csv
    # python3 heatmap/heatmap.py out.csv heatmap.png

    ahora = datetime.now()
    ahora_format = ahora.strftime("%Y%m%d%H%M")
    print(ahora.strftime("Hora actual: %H:%M"))
    # Rutas de archivo
    output_dir = "./output"
    csv_filename = f"{output_dir}/{ahora_format}.csv"
    png_filename = f"{output_dir}/{inicio}Mhz-{final}Mhz-{minutos}min_{ahora_format}.png"

    # Asegurarse de que el directorio de salida exista
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"Directorio '{output_dir}' creado.")
    
    # ---  Ejecutar rtl_power ---
    rtl_power_command = [
        "rtl_power",
        "-f",
        f"{inicio}M:{final}M:{resolucion}k",
        "-e",
        f"{minutos}m",
        csv_filename
    ]
    print(f"Comando lanzado: {' '.join(rtl_power_command)}")

    try:
        # Usamos timeout para evitar que el comando se quede colgado indefinidamente
        subprocess.run(rtl_power_command, check=True, capture_output=True, text=True, timeout=(minutos * 60) + 30) # Añadimos tiempo extra al timeout
        print("rtl_power finalizado con éxito.")
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar rtl_power (código {e.returncode}):")
        print(f"Salida estándar: {e.stdout}")
        print(f"Salida de error: {e.stderr}")
        return # Salir de la función si rtl_power falla
    except FileNotFoundError:
        print("Error: El comando 'rtl_power' no se encontró. Asegúrate de que está instalado y en tu PATH.")
        return
    except subprocess.TimeoutExpired:
        print(f"Error: El comando rtl_power excedió el tiempo límite de {(minutos * 60) + 10} segundos.")
        return
    except Exception as e:
        print(f"Ocurrió un error inesperado al ejecutar rtl_power: {e}")
        return

    # Da tiempo al sistema de archivos para asegurar que el CSV esté completamente escrito.
    time.sleep(2)

    # --- Ejecutar heatmap ---
    heatmap_command = [
        "python3",
        "heatmap/heatmap.py",
        csv_filename,
        png_filename
    ]
    print(f"Comando lanzado: {' '.join(heatmap_command)}")

    try:
        subprocess.run(heatmap_command, check=True, capture_output=True, text=True)
        print(f"Heatmap '{png_filename}' generado con éxito.")
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar el script de heatmap (código {e.returncode}):")
        print(f"Salida estándar: {e.stdout}")
        print(f"Salida de error: {e.stderr}")
    except FileNotFoundError:
        print("Error: El intérprete 'python3' o el script 'heatmap/heatmap.py' no se encontró.")
        print("Asegúrate de que 'python3' está en tu PATH y que 'heatmap/heatmap.py' existe en la ruta correcta.")
    except Exception as e:
        print(f"Ocurrió un error inesperado al generar el heatmap: {e}")




def opcion1():
    # 1. Escanear un rango de frecuencia
    inicio_str = input("Punto inicial de captura en MHz (ej: 88 para radio comercial): ")
    final_str = input("Punto final de captura en MHz (ej: 108 para radio comercial): ")
    resolucion_str = input("tamaño del contenedor. Inversamente proporcional al tamaño de imagen que obtendremos (recomendado 25-100): ")
    minutos_str = input("Minutos de escaneo: ")

    inicio = int(inicio_str)
    final = int(final_str)
    resolucion = int(resolucion_str)
    minutos = int(minutos_str)

    scan(inicio,final,resolucion,minutos)



def opcion2():
    # 2. Escanear un rango de frecuencia en bucle
    inicio_str = input("Punto inicial de captura en MHz (ej: 88 para radio comercial): ")
    final_str = input("Punto final de captura en MHz (ej: 108 para radio comercial): ")
    resolucion_str = input("tamaño del contenedor. Inversamente proporcional al tamaño de imagen que obtendremos (recomendado 25-100): ")
    minutos_str = input("Minutos de escaneo: ")

    inicio = int(inicio_str)
    final = int(final_str)
    resolucion = int(resolucion_str)
    minutos = int(minutos_str)

    try:
        while True:
            scan(inicio,final,resolucion,minutos)
    except KeyboardInterrupt:
        # Este bloque se ejecuta cuando se presiona Ctrl+C
        print("\n¡Ctrl+C detectado! Saliendo del bucle de forma segura...")



def opcion3():
    # 3. Escanear varios rangos de frecuencias consecutivos (uno tras otro)
    inicio_str = input("Punto inicial de captura en MHz (ej: 88 para radio comercial): ")
    amplitud_str = input("Amplitud en MHz de cada captura: ")
    repeticiones_str = input("Numero de capturas consecutivas: ")
    resolucion_str = input("tamaño del contenedor. Inversamente proporcional al tamaño de imagen que obtendremos (recomendado 25-100): ")
    minutos_str = input("Minutos de escaneo por captura: ")

    inicio = int(inicio_str)
    amplitud = int(amplitud_str)
    repeticiones = int(repeticiones_str)
    resolucion = int(resolucion_str)
    minutos = int(minutos_str)

    for i in range(repeticiones):
        print(f"Captura Num {i + 1}")
        final = inicio + amplitud
        scan(inicio,final,resolucion,minutos)
        inicio = inicio + amplitud
        


def opcion4():
    # 4. Escanear varios rangos de frecuencias consecutivos (uno tras otro) en bucle
    inicio_str = input("Punto inicial de captura en MHz (ej: 88 para radio comercial): ")
    amplitud_str = input("Amplitud en MHz de cada captura: ")
    repeticiones_str = input("Numero de capturas consecutivas: ")
    resolucion_str = input("tamaño del contenedor. Inversamente proporcional al tamaño de imagen que obtendremos (recomendado 25-100): ")
    minutos_str = input("Minutos de escaneo por captura: ")

    inicio_orig = int(inicio_str)
    inicio = inicio_orig
    amplitud = int(amplitud_str)
    final_orig = inicio_orig + amplitud
    repeticiones = int(repeticiones_str)
    resolucion = int(resolucion_str)
    minutos = int(minutos_str)

    try:
        while True:
            for i in range(repeticiones):
                print(f"Captura Num {i + 1}")
                final = inicio + amplitud
                scan(inicio,final,resolucion,minutos)
                inicio = inicio + amplitud
            # Reiniciamos valores para comenzar de nuevo
            inicio = inicio_orig
            final = final_orig
    except KeyboardInterrupt:
        # Este bloque se ejecuta cuando se presiona Ctrl+C
        print("\n¡Ctrl+C detectado! Saliendo del bucle de forma segura...")



# Llamar a la función para ejecutar el menú
menu_opciones()