Provide the log directory as an argument when running the tool.
´´´ log-archive <log-directory> ´´´
The tool should compress the logs in a tar.gz file and store them in a new directory.
The tool should log the date and time of the archive to a file.


# log-archive.sh
´´´
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

´´´

If you are looking to build a more advanced version of this project, you can consider adding functionality to the tool like ** emailing the user updates on the archive **, or sending the archive to a remote server or cloud storage.


# sending the archive to email  
## configurate postfix for send emails from your system with gmail **config-email.sh**
´´´
#!/bin/bash

# check the arguments
if [ $# -lt 1 ]; then
  echo "How to use: $0 <youremail@gmail.com> [password|--ask]"
  exit 1
fi

GMAIL_USER="$1"

# --ask for interactive mode
if [ "$2" = "--ask" ]; then
  echo -n "Enter the password of $GMAIL_USER: "
  read -r -s -p "Enter Gmail password (or app password): " GMAIL_PASS
  echo
else
  GMAIL_PASS="$2"
fi

# clear the line of bash history
history -d $(history 1) 2>/dev/null

echo "Install Postfix and dependencies ..."
echo "===================================="
apt update
DEBIAN_FRONTEND=noninteractive apt install -y postfix mailutils mutt libsasl2-modules

echo "------------------------------------"
echo "Configurando Postfix para usar Gmail como relay..."
echo "=================================================="
tee /etc/postfix/sasl_passwd > /dev/null <<EOF
[smtp.gmail.com]:587 $GMAIL_USER:$GMAIL_PASS
EOF

chmod 600 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

# Add a config file (If this not exist yet)
if ! grep -q "relayhost = \[smtp.gmail.com\]:587" /etc/postfix/main.cf; then
  tee -a /etc/postfix/main.cf > /dev/null <<EOF

# Configuration for Gmail
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
EOF
fi

echo "---------------------------------------------------"
echo "Restart Postfix..."
echo "======================"
service postfix restart

echo "Configuration Complet."
echo "----------------------------"
´´´


Hay que Crear y utilizar contraseñas de aplicación

´´´
bash config-email.sh correoenvio@gmail.com --ask
> contraseñas_de_aplicación
´´´


## Send mail with the file **send-email.sh**

´´´
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
´´´

´´´
bash send-email.sh "Receptor@gmail.com" "Logs Comprimidos" "Adjunto Logs Comprimidos" "./compresed_logs/log-archive_2025-05-10_23-13-14.tar.gz"
´´´

![Comprobación de recepción de email](/imgs/email.png)


If you are looking to build a more advanced version of this project, you can consider adding functionality to the tool like emailing the user updates on the archive, or **sending the archive to a remote server or cloud storage**.


´´´
curl https://rclone.org/install.sh | sudo bash
´´´

´´´
rclone config
´´´

´´´
Enter name for new remote.
name> 
> logsdrive

Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.
20 / Google Drive
   \ (drive)

> 20

Option client_id.
Google Application Client Id
Setting your own is recommended.
See https://rclone.org/drive/#making-your-own-client-id for how to create your own.
If you leave this blank, it will use an internal key which is low performance.
Enter a value. Press Enter to leave empty.
client_id> 
> (Enter)


Option client_secret.
OAuth Client Secret.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_secret>
> (Enter)

Option scope.
Comma separated list of scopes that rclone should use when requesting access from drive.
Choose a number from below, or type in your own value.
Press Enter to leave empty.
 1 / Full access all files, excluding Application Data Folder.
   \ (drive)
> 1

Option service_account_file.
Service Account Credentials JSON file path.
Leave blank normally.
Needed only if you want use SA instead of interactive login.
Leading `~` will be expanded in the file name as will environment variables such as `${RCLONE_CONFIG_DIR}`.
Enter a value. Press Enter to leave empty.
service_account_file> 
> /home/credentials/rclone-access.json

En Cuentas de Servicio en Google Cloud en el ProyectoCreado en IAM y administración/ Cuentas de Servicio /Cuenta de Servicio: Numero de Cuenta / Claves
Agreagamos Clave y nos descargamos el Archivo Json y en mi caso tuve que copiarlo al Contenedor
docker cp /home/user/credentials/calm-segment-2222.json logarchive:/home/credentials/rclone-access1.json



Edit advanced config?
y) Yes
n) No (default)
> y

Option root_folder_id.
ID of the root folder.
Leave blank normally.
Fill in to access "Computers" folders (see docs), or for rclone to use
a non root folder as its starting point.
Enter a value. Press Enter to leave empty.
root_folder_id> 
> Referencia_ID

de la carpeta compartida con cuenta de servicio
Seleccionamos la parte https://drive.google.com/drive/u/1/folders/Referencia_ID
´´´

Podemos enviar todos los archivos comprimidos así:
´´´
rclone copy ./ logsdrive: --include "*.tar.gz"
´´´
![Comprobación de respaldo de archivos de logs](/imgs/GDrive.png)

