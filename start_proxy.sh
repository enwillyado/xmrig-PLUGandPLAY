##########################################
# xmrig-PLUGandPLAY (enWILLYado version) #
##########################################

##########################################
# Certs

if [ ! -f key.pem ]
then
	openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 10000 -nodes
fi

##########################################
# Execute 

if [ -f xmrig-proxy.exe ]
then
	./xmrig-proxy.exe --tls-cert=cert.pem --tls-cert-key=key.pem --tls-bind 0.0.0.0:3333 -o pool.supportxmr.com:443 --tls -u 433hhduFBtwVXtQiTTTeqyZsB36XaBLJB6bcQfnqqMs5RJitdpi8xBN21hWiEfuPp2hytmf1cshgK5Grgo6QUvLZCP2QSMi
fi
