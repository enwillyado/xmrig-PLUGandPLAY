#!/bin/sh

##########################################
# xmrig-PLUGandPLAY (enWILLYado version) #
##########################################

##########################################
# Execute 

if [ -f xmrig.exe ]
then
	./xmrig.exe -o 0.0.0.0:443 --tls --cpu-usleep 0
fi
