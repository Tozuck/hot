#!/bin/bash

echo_info() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}
echo_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}

apt-get update; apt-get install curl socat git nload speedtest-cli -y

if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sh || echo_error "Docker installation failed."
else
  echo_info "Docker is already installed."
fi

rm -r Marzban-node

git clone https://github.com/Gozargah/Marzban-node

rm -r /var/lib/marzban-node

mkdir /var/lib/marzban-node

rm ~/Marzban-node/docker-compose.yml

cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host
    environment:
      SSL_CERT_FILE: "/var/lib/marzban-node/ssl_cert.pem"
      SSL_KEY_FILE: "/var/lib/marzban-node/ssl_key.pem"
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"
      SERVICE_PROTOCOL: "rest"
    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL
curl -sSL https://raw.githubusercontent.com/Tozuck/Node_monitoring/main/node_monitor.sh | bash
rm /var/lib/marzban-node/ssl_client_cert.pem

cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjUwNjA3MjA0NjQ3WhgPMjEyNTA1MTQyMDQ2NDdaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyQZKzwZSpjT7
HsQZXHVTSzN8KSKbg2pRZ5IG18P+VQqUUnlxgGTby/iLc8Xi3K1sRB+UG7c+NBYE
kKqgd9YnimXw/F4IsXm3NfCnwY/XvTOIpSMkfpiF4ekHfn5NPC1fVqWMqBrSWDWg
bW+cq3uEjoe40YV2J3GaQS4pC16YpYbbiuU6xNCN/6NvAwZipcY0a/KeGLWj+/3R
JKmCN9oFePwEQpB2NwyZNqQynlqv5NcSh2PpMSf3mbD74jgUNZ29KnJxswaLmDRx
omd+XOEVaDmwF8n2FkFoUVOcZd4ADD6DdTun1QcHjM2nB6Nage6wV8kx0VKljqpY
7OkMbZEl7PPoTBGf847M7kBFzA6zOGfAvaFQp3Zd6EXyi1fw7MUfARCGyDXCHnXV
xvUvD9sIGsn+M7aBwWPcdb+APcKOO2MgM9m7k+DUh9P44e3e38bEJ9ei/6H2ERdZ
FxQVPETUmhsbLnyG6erkrnI5rx7wmsJQ5MKFEJ+1onr1NQN006yUEZfpoICglJGN
21NhdkCzSXfaEi/OjBHFF5pyKaUD84DiiloCN0Chd6qINzJBy5FfYXPKDHbsKuFU
OT7ZUkU/ei4ri76hXtFkrp/mVELQIbw808UBsqNuYadPR+b7EePnAn6DN88tBRur
CGnt7C8cZMqKa4ceRyKmhGYqG6jwjFcCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
VqqnaFSb3cKKK/26UE+GrIHXlwHrjxs3E3y+rI3me/der7ZWqsi948Tep32d/Kft
xFHtcJsfh5Ktk/+ge2ZBtjyrCY4KLRckFWIDpIZbuP3rvdczscg2mCX9JsOsjSjI
oEiB7vG/2fOXSKoED7/lwZ55h/LCE90Mv3Bl3/hMSiINaRmtfnzuhSEYWANyfWOe
9rjJD7d3ggDxy/7+Dvdd2nAndinSxVJ6YI8FfsS69nm6O7eUskhrZxDR/JGbPrZH
CR6hgQ3DonVIUxbKgYHwrZd1WJhUxjK4n0tvYlJ49bEfB3Dhtp9MI0PvQTHVA1+7
gVKFM+koqC4UlVCNBSGrDoFmmooPEIwrcFgKQkROwCMtVh5M/LSoHSwxnAxvd5Hz
C++86OMN5AFbLRAf9xG/X8ElGmtn+e6IUo1LnAtKQp0k7Q+f8eA0rFjYGBbgFJ0z
9a0wvTcC1H5b0HM8jy5QImBytWUS+CwCKYg/o6nVXdvXV+JHp2sO7zFvf3oyjO2T
CFYhv3DqE9UEySepSdWEHwUT52DcD9qCpZfpI///lCR4ZW9FGE1FHgufoqhhzw4M
bp5VxuIYhG2cxKcqecDsJRgvI+SSRmHwMH7TSrL5tg+FkrOoxwdfc1QqPLf53qgR
p7o+z8MtTOdUKa04e2OqEyhZH7VnBTZZBYIcS7n3Pzw=
-----END CERTIFICATE-----

EOL

cd ~/Marzban-node
docker compose up -d
