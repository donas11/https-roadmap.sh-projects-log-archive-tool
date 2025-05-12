#!/bin/bash

DESTINATARIO="$1"
ASUNTO="$2"
CUERPO="$3"
ADJUNTO="$4"

# Verificar existencia del archivo
if [ ! -f "$ADJUNTO" ]; then
    echo "El archivo '$ADJUNTO' no existe."
    exit 1
fi

# Enviar correo con adjunto
echo "$CUERPO" | mutt -s "$ASUNTO" -a "$ADJUNTO" -- "$DESTINATARIO"