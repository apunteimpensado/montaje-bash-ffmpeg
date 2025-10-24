# Editar videos de forma automática con Bash y Ffmpeg

Este es un pequeño Bash script que utilza Ffmpeg para ayudarnos a editar un video de forma rápida.

## Paso 1: Crear el archivo timecode.txt

En este archivo tenemos los timecodes en los que queremos ahcer cada corte en cada video.

Se puede hacer la lista por fuera del programa, pero por una cuestión de practicidad en este ejemplo lo tenemos dentro del código:

cat > timecode.txt << 'EOF'
video_001.mp4, 00:00:10.0, 00:00:20.0, corte01.mp4
video_002.mp4, 00:00:08.0, 00:00:11.0, corte02.mp4
video_003.mp4, 00:00:02.0, 00:00:05.0, corte03.mp4
video_004.mp4, 00:01:03.0, 00:01:25.0, corte04.mp4
EOF

Este comando crea un archivo llamado "timecode.txt" que contiene la información de los cortes.
Cada línea tiene: archivo_original, tiempo_inicio, tiempo_fin, nombre_del_corte

## Paso 2: Cortar los videos usando ffmpeg

Luego tenemos este comando:

gawk -F, '{cmd="ffmpeg -ss " $2 " -to " $3 " -i " $1 " -c copy " $4 ""; print "Processing: " $1; system(cmd)}' timecode.txt

gawk lee el archivo timecode.txt línea por línea, separando los campos por comas.

- $1 = nombre del archivo original (video_001.mp4)
- $2 = tiempo de inicio (00:00:10.0)
- $3 = tiempo final (00:00:20.0)
- $4 = nombre del archivo resultante (corte01.mp4)

Luego construye y ejecuta el comando ffmpeg para cada video.

## Paso 3: Crear la lista para el montaje

ls -1 corte\*.mp4 | sed 's/^/file /' > montaje.txt

Este comando lista todos los archivos cortados (corte01.mp4, corte02.mp4, etc.)
y usa sed para agregar la palabra "file" al inicio de cada línea, creando el archivo montaje.txt

## Paso 4: Concatenar todos los videos

ffmpeg -f concat -safe 0 -i montaje.txt -c copy terminado.mp4

ffmpeg toma la lista de archivos en montaje.txt y los concatena en un solo video
llamado "terminado.mp4", sin re-codificar los videos (por eso usa -c copy)

El resultado final es un video que contiene todos los cortes en secuencia.
