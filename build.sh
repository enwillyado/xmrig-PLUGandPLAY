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

if [ ! -f libuv ]
then
	git clone https://github.com/libuv/libuv
	cd libuv/
	./autogen.sh
	./configure
	make -j12
	cd ..
fi

if [ ! -f openssl-OpenSSL_1_1_0c ]
then
	unzip -u extra/openssl-OpenSSL_1_1_0c.zip
	cd openssl-OpenSSL_1_1_0c
	./config
	make
	cd ..
fi
	
##########################################
# xmrig

git clone https://github.com/xmrig/xmrig

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

