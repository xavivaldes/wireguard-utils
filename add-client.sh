#!/bin/bash

# Address of your wireguard server with port
server_address="1.2.3.4:51820"
# Your wireguard server public key
server_public_key="KCA6IEkgbG92ZSB5b3UgdG9vIG11Y2ggPDM="
# DNS server you want to use (Cloudfare dns: https://1.1.1.1/)
dns="1.1.1.1"
# Prefix and sufix for your client ips (In this example: 10.8.0.x/32)
ip_prefix="10.8.0."
ip_sufix="/32"
# Main wireguard path
wireguard_path="/etc/wireguard/"
# Wiregaurd config
config_file_path=$wireguard_path"wg0.conf"
# The folder that will be created tol store clients configuration
clients_path=$wireguard_path"clients/"

if [ $# -eq 0 ]
then
        echo "Param needed: add-client.sh <client-name>"
else
        client=$1
        echo client name: $client

        mkdir -p $clients_path

        client_path=$clients_path$client"/"
        mkdir -p $client_path

        wg genkey | tee $client_path/$client.priv | wg pubkey > $client_path/$client.pub
        client_public_key=$(cat $client_path/$client.pub)
        echo client public key: $client_public_key
        client_private_key=$(cat $client_path/$client.priv)
        echo client private key: $client_private_key

        wg genpsk > $client_path/$client.psk
        client_preshared_key=$(cat $client_path/$client.psk)
        echo client preshared key: $client_preshared_key

        client_ip=$ip_prefix$(expr $(grep -o -i Peer wg0.conf | wc -l) + 2)$ip_sufix
        echo client ip: $client_ip

        echo $(cat << EOF >> $config_file_path

# Name:         $client
[Peer]
PublicKey = $client_public_key
PresharedKey = $client_preshared_key
AllowedIPs = $client_ip
EOF
)

        echo $(cat << EOF > $client_path$client.conf
[Interface]
PrivateKey = $client_private_key
Address = $client_ip
DNS = $dns

[Peer]
PublicKey = $server_public_key
PresharedKey = $client_preshared_key
AllowedIPs = 0.0.0.0/0
Endpoint = $server_address
PersistentKeepalive = 15
EOF
)

        chmod 600 $client_path -R

        qrencode -t ansiutf8 < $client_path$client.conf
fi

