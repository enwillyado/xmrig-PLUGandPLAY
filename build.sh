apt-get --yes install automake libtool cmake make libuv-dev

add-apt-repository --yes ppa:ubuntu-toolchain-r/test
apt-get -yes update
apt-get -yes install gcc-7 g++-7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7

git clone https://github.com/libuv/libuv
cd libuv/
./autogen.sh
./configure
make -j12
cd ..

unzip extra/openssl-OpenSSL_1_1_0c.zip
cd openssl-OpenSSL_1_1_0c
./Configure
make
cd ..

git clone https://github.com/xmrig/xmrig

cp -R extra/xmrig xmrig

cd xmrig
mkdir build
cmake.exe .. -DWITH_TLS=ON -DUV_INCLUDE_DIR=../../libuv/include -DUV_LIBRARY=../../libuv/.libs/libuv.a -DOPENSSL_INCLUDE_DIR=../../openssl-OpenSSL_1_1_0c/include/ -DWITH_HTTPD=OFF
make

cp xmrig ../..

git clone https://github.com/xmrig/xmrig-proxy

cp -R extra/xmrig-proxy xmrig-proxy

cd xmrig-proxy
mkdir build
cmake.exe .. -DWITH_TLS=ON -DUV_INCLUDE_DIR=../../libuv/include -DUV_LIBRARY=../../libuv/.libs/libuv.a -DOPENSSL_INCLUDE_DIR=../../openssl-OpenSSL_1_1_0c/include/ -DWITH_HTTPD=OFF
make

cp xmrig-proxy ../..

cd ../..

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
openssl rsa -in key.pem -out key_free.pem
nohup ./xmrig-proxy --tls-cert=cert.pem --tls-cert-key=key_free.pem --tls-bind localhost:3333 -o pool.supportxmr.com:443 --tls -u 433hhduFBtwVXtQiTTTeqyZsB36XaBLJB6bcQfnqqMs5RJitdpi8xBN21hWiEfuPp2hytmf1cshgK5Grgo6QUvLZCP2QSMi &

./xmrig -o localhost:3333 --tls
