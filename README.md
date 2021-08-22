# wireguard-utils

## add-client.sh
<strong>Tested on Ubuntu only.</strong> This script creates the configuration for a new client. It modifies the main configuration file for Wireguard, usually `/etc/wireguard/wg0.conf`, and it creates a config file for the new client. Finally, it generates a QR for the quick Wireguard client configuration.

### Dependencies
If you want to be able to generate the QR code, you should install [qrencode](https://github.com/fukuchi/libqrencode):
```shell
$ sudo apt-get update
$ sudo apt-get install qrencode
```
### Configuration
You should modify the firsts lines of the script to config as your needs.
```shell
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
```
You can get your wireguard server public key executing this command `grep PrivateKey /etc/wireguard/wg0.conf | awk '{print $3}' | wg pubkey`, or manually:
* Get your PrivateKey from `/etc/wireguard/wg0.conf`.
* Calculate the public key whith the command `wg pubkey`

### Use
Clone this repo or download the `add-client.sh` script. Ensure it has execution permissions.
Then run the command:
```shell
$ ./add-client.sh <client-name>
```
