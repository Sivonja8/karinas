clear
cd /root
echo && echo && echo
sleep 2

if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

if [[ $(lsb_release -rs) != "18.04" ]]; then

      
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
sudo apt-get -y install \
libdb4.8-dev \
libdb4.8++-dev

cd /root

# Edit/Create config file for rxc
echo && echo "Creating your data folder and files..."
sleep 3
sudo mkdir /root/.ruxcrypto

rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
rpcpassword=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
sudo touch /root/.ruxcrypto/ruxcrypto.conf #config
echo '
rpcuser='$rpcuser'
rpcpassword='$rpcpassword'
rpcallowip=127.0.0.1
listen=1
server=1
rpcport=23506
daemon=1
logtimestamps=1
maxconnections=256
externalip='$ip'
masternode=1
masternodeprivkey='$key'
' | sudo -E tee /root/.ruxcrypto/ruxcrypto.conf

mkdir ruxcrypto
cd ruxcrypto
wget https://rxc.crypto.ba/wallets/rxclinux.zip
unzip rxclinux.zip
# Give permissions
chmod +x ruxcryptod
chmod +x ruxcrypto-cli
chmod +x ruxcrypto-tx

# Move binaries do lib folder
sudo mv ruxcrypto-cli /usr/bin/ruxcrypto-cli
sudo mv ruxcrypto-tx /usr/bin/ruxcrypto-tx
sudo mv ruxcryptod /usr/bin/ruxcryptod
ruxcryptod -daemon
sleep 5

ruxcrypto-cli addnode 49.12.8.136 add
ruxcrypto-cli addnode 178.128.172.218 add
ruxcrypto-cli addnode 46.101.165.137 add
ruxcrypto-cli addnode 206.189.135.20 add

sleep 2


# 
echo && echo "Instaliranje Sentinel..."
sleep 3
cd
sudo apt-get -y install python3-pip
sudo pip3 install virtualenv
sudo apt-get install screen
# crypto.ba sentinel made by Rux/Toni.Dev
sudo git clone https://git.crypto.ba/rux/SentinelRXC /root/sentinel-rxc
cd /root/sentinel-rxc
mkdir database
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
export EDITOR=nano
(crontab -l -u root 2>/dev/null; echo '* * * * * cd /root/sentinel-rxc && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1') | sudo crontab -u root -
./venv/bin/py.test ./test
