********************************************
RTL-SDR-Misc
********************************************

Software generador de mapas calor de rangos de frecuencia de radio que ayuda a localizar a lo largo del tiempo emisiones de radio ya sea radio comercial, radioaficionados, y otras comunicaciones

********************************************
Como funciona
********************************************
Me baso en un fork de la aplicacion del mismo nombre que he obtenido del usuario de github llamado keenerd, esta app hace un barrido de radio y genera un archivo de tipo csv que indica la potencia de recepcion de cada una de las frecuencas escaneadas, a partir de esos datos, se crea una imagen 'termica' que muestra una cascada que muestra en horizontal la frecuencia escaneada y en vertical el tiempo de captura.

Si durante el escaneo hay una frecuencia en la que se recibe una emision continua, podremos ver en nuestra imagen una linea vertical amarilla en el rango de frecuencia de emision.

Si durante el escaneo hay una frecuencia en la qeu se recibe una emision intermitente, podremos ver una linea vertical amarilla punteada en el rango de frecuencia de emision.