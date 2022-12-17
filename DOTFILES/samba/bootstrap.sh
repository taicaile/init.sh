#!/usr/bin/env bash

sudo apt install -y samba
# cat << EOL >> .conf
cat << EOL
[shared]
    path = /home/$USER
    writeable = yes
    browsable = yes
    public = yes
    create mask = 0755
    directory mask = 0755
    read only = no
    guest ok = yes
    force user = $USER
    force group = $USER
EOL

cat << EOL
# please copy above to the config file:
sudo nano /etc/samba/smb.conf

# then restart the service
sudo systemctl restart smbd.service nmbd.service
EOL