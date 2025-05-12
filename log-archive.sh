#!/bin/sh

if [ -d "$1" ]; then
    DIRECTORY="$1"
    DIRECTORY_NEW_LOG="./compresed_logs/"
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    ARCHIVE_LOGS=${DIRECTORY_NEW_LOG}log-archive_${timestamp}.tar.gz

    if [ ! -d "$DIRECTORY" ]; then
        echo "no existe file"
        exit 1
    fi

    # Comprime los logs y almacena en un directorio nuevo
    mkdir -p "${DIRECTORY_NEW_LOG}"
    ls -lh *.txt
    tar -czf $ARCHIVE_LOGS $DIRECTORY
else
    echo "Error: '$1' no es una carpeta valida."
    exit 1
fi


