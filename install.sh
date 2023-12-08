#!/bin/bash

# Script for installing necessary dependencies for building RocksDB, Speicher, Tweezer
# NOTE: before running this script, you will need to:
#  1) have tweezer repo cloned locally
#  2) register for Scone to pull cross compilers
#  3) have Docker installed 
# Please refer to the Tweezer repo README for 2 and 3

# cd into Tweezer base directory
cd tweezer

# From Tweezer base directory 
cd fortanix-linux-sgx-driver
# Install matching header
sudo apt-get install linux-headers-$(uname -r)
make
sudo mkdir -p "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"    
sudo cp isgx.ko "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"    
sudo sh -c "cat /etc/modules | grep -Fxq isgx || echo isgx >> /etc/modules"    
sudo /sbin/depmod
sudo /sbin/modprobe isgx\

# cd back into Tweezer base directory 
cd ..
# Install sgxtop
cd sgxtop
./maintainer.sh

# cd back into Tweezer base directory 
cd ..
# In project root directory
docker build -t tweezer:0.0 ./
