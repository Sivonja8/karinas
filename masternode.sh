clear
cd /root
echo && echo && echo
sleep 2

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

if [[ $(lsb_release -rs) == "18.04" ]];

       echo "Compatible version"
       #Copy your files here
else
       echo "Non-compatible version"
	   exit -1
fi

echo "Unesi svoj Masternode Private Key"
read -e -p "e.g. (8tagsuahsAHAJshjvhs88asadijsuyas98aqsaziucdplmkh75sb) : " key
if [[ "$key" == "" ]]; then
    echo "WARNING: No private key entered, exiting!!!"
    echo && exit
fi
read -e -p "VPS Server IP Address and Masternode Port like IP:11010 : " ip
echo && echo "Pressing ENTER will use the default value for the next prompts."
echo && sleep 3


echo && echo "Upgrading system and install initial dependencies"
sleep 3
sudo apt-get -y update
sudo apt-get -y upgrade


echo && echo "Installing base packages..."
sleep 3

sudo apt-get -y install \
build-essential \
libtool \
autotools-dev \
automake \
pkg-config \
libssl-dev \
libevent-dev \
bsdmainutils \
python3 \
libboost-system-dev \
libboost-filesystem-dev \
libboost-chrono-dev \
libboost-test-dev \
libboost-thread-dev \
libboost-all-dev \
libboost-program-options-dev \
libminiupnpc-dev \
libzmq3-dev \
libprotobuf-dev \
protobuf-compiler \
unzip \
software-properties-common

echo | sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install 
libdb4.8-dev \
libdb4.8++-dev

cd /root

adduser rxc
adduser rxc sudo
su rxc
cd

mkdir .ruxcrypto
sudo touch /root/.ruxcrypto/ruxcrypto.conf

rpcuser=rpc_ruxcrypto
rpcpassword=kuw05sqio7bcm8z96o7redv17xws1lw6xpd1qf33
rpcallowip=127.0.0.1

listen=1
server=1
daemon=1
maxconnections=64

masternode=1
externalip='$ip'
masternodeprivkey='$key'
' | sudo -E tee /root/.ruxcrypto/ruxcrypto.conf


wget https://rxc.crypto.ba/wallets/rxclinux.zip
unzip rxc*
sudo mv ruxcr* /usr/bin
ruxcryptod -daemon
sleep 5

ruxcrypto-cli addnode 49.12.8.136 add
ruxcrypto-cli addnode 178.128.172.218 add
ruxcrypto-cli addnode 46.101.165.137 add
ruxcrypto-cli addnode 206.189.135.20 add

sleep 2
echo && echo "Instaliranje Sentinel..."
sleep 3

sudo apt-get -y update
sudo apt-get -y install python-virtualenv
git clone https://git.crypto.ba/rux/SentinelRXC.git && cd SentinelRXC
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
export EDITOR=nano
(crontab -l -u root 2>/dev/null; echo '* * * * * cd /root/sentinel-rxc && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1') | sudo crontab -u root -
./venv/bin/py.test ./test