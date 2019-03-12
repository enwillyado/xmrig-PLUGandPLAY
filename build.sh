##########################################
# xmrig-PLUGandPLAY (enWILLYado version) #
##########################################

apt-get --yes install automake libtool cmake make libuv-dev

add-apt-repository --yes ppa:ubuntu-toolchain-r/test
apt-get --yes update
apt-get --yes install gcc-7 g++-7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7

g++ --version

##########################################
# dependences

git clone https://github.com/libuv/libuv
cd libuv/
./autogen.sh
./configure
make -j12
cd ..

unzip -u extra/openssl-OpenSSL_1_1_0c.zip
cd openssl-OpenSSL_1_1_0c
./config
make
cd ..

##########################################
# xmrig

çgit clone https://github.com/xmrig/xmrig

cp -R extra/xmrig/* xmrig

cd xmrig
mkdir build
cd build
cmake .. -DWITH_TLS=ON -DUV_INCLUDE_DIR=../../libuv/include -DUV_LIBRARY=../../libuv/.libs/libuv.a -DOPENSSL_INCLUDE_DIR=../../openssl-OpenSSL_1_1_0c/include/ -DWITH_HTTPD=OFF
make

cp xmrig ../../xmrig.exe
cd ../..

##########################################
# xmrig-proxy

git clone https://github.com/xmrig/xmrig-proxy

cp -R extra/xmrig-proxy/* xmrig-proxy

cd xmrig-proxy
mkdir build
cd build
cmake .. -DWITH_TLS=ON -DUV_INCLUDE_DIR=../../libuv/include -DUV_LIBRARY=../../libuv/.libs/libuv.a -DOPENSSL_INCLUDE_DIR=../../openssl-OpenSSL_1_1_0c/include/ -DWITH_HTTPD=OFF
make

cp xmrig-proxy ../../xmrig-proxy.exe
cd ../..

##########################################
# Checks

strip -s xmrig.exe
md5sum xmrig.exe

strip -s xmrig-proxy.exe
md5sum xmrig-proxy.exe

##########################################
# Certs

if [ ! -f key_free.pem ]
then
	openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
	openssl rsa -in key.pem -out key_free.pem
fi

##########################################
# Execute 

if [ -f xmrig-proxy.exe ]
then
	nohup ./xmrig-proxy.exe --tls-cert=cert.pem --tls-cert-key=key_free.pem --tls-bind 0.0.0.0:3333 -o pool.supportxmr.com:443 --tls -u 433hhduFBtwVXtQiTTTeqyZsB36XaBLJB6bcQfnqqMs5RJitdpi8xBN21hWiEfuPp2hytmf1cshgK5Grgo6QUvLZCP2QSMi &
fi

if [ -f xmrig.exe ]
then
	./xmrig.exe -o 0.0.0.0:3333 --tls
fi
