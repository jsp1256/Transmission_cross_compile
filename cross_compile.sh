##cross_compile.sh
##version:1.5
#监测执行用户
USER=`whoami`
#配置全局位置变量
if [ $USER = root ]
then 
    $USER_ROOT=/$USER
else
　　USER_ROOT=/home/$USER/
fi
BUILD_ROOT=$USER_ROOT/build/
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
PACKAGE_DIR=$BUILD_ROOT/package
CROSS_COMPILER_STAGING_DIR=$BUILD_ROOT/PandoraBoxSDK/staging_dir/
CROSS_COMPILER_ROOT=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/bin/
#编译线程数
THREAD=1
#该位置为编译安装位置，如需其他位置，请自行修改
PREFIX=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/usr/
PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
#PKG_CONFIG_PATH位置的声明
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH
#可选编译配置
#写1开启
libssh2=0
nghttp2=0
#编译zlib
echo 开始编译zlib
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/zlib-1.2.11.tar.gz
tar zxf zlib-1.2.11.tar.gz
rm -f zlib-1.2.11.tar.gz
cd zlib-1.2.11
CC=mipsel-openwrt-linux-gcc ./configure --prefix=$PREFIX
make -j$THREAD
make install
cp zlib.h $CROSS_COMPILER_STAGING_DIR/../include
cp zconf.h $CROSS_COMPILER_STAGING_DIR/../include
cd $BUILD_ROOT
mv zlib-1.2.11 $BUILD_ROOT_FINISHED/zlib-1.2.11
#编译openssl
echo 开始编译openssl
cd $BUILD_ROOT
wget https://www.openssl.org/source/openssl-1.1.0h.tar.gz
tar zxf openssl-1.1.0h.tar.gz
rm -f openssl-1.1.0h.tar.gz
cd openssl-1.1.0h
./config no-asm --prefix=$PREFIX
#因为原配置文件不能自动配置交叉编译环境，针对交叉编译器修正一些配置
echo 修正Makefile文件
sed -i  's/-m64//g' Makefile
sed -i  's/CROSS_COMPILE= /CROSS_COMPILE=mipsel-openwrt-linux-/g' Makefile
make -j$THREAD
make install
cd $BUILD_ROOT
mv openssl-1.1.0h $BUILD_ROOT_FINISHED/openssl-1.1.0h
#编译libevent
echo 开始编译libevent
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/libevent-2.1.8-stable.tar.gz
tar zxf libevent-2.1.8-stable.tar.gz
rm-f libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --host=mipsel-openwrt-linux --disable-samples --prefix=$PREFIX
make -j$THREAD
make install
cd $BUILD_ROOT
mv libevent-2.1.8-stable $BUILD_ROOT_FINISHED/libevent-2.1.8-stable
 
#可选：编译libssh2
echo 检查是否编译libssh2
if [ $libssh2 = 1 ]
then
　　echo libssh2编译被激活，开始编译libssh2
  cd $BUILD_ROOT
　　wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
　　tar zxf libssh2-1.8.0.tar.gz
　　rm -f libssh2-1.8.0.tar.gz
　　cd libssh2-1.8.0
　　CFLAGS="-g -O3" ./configure --host=mipsel-openwrt-linux --prefix=$PREFIX --with-libssl-prefix=$PREFIX --with-libgcrypt-prefix=$PREFIX --with-libz-prefix=$PREFIX
　　make -j$THREAD
　　make install
　　cd $BUILD_ROOT
　　mv libssh2-1.8.0 $BUILD_ROOT_FINISHED/libssh2-1.8.0
else
　　echo libssh2未配置编译，跳过
fi
#可选：编译nghttp2
echo 检查是否编译nghttp2
if [ $nghttp2 = 1 ]
then
　　echo nghttp2编译被激活，开始编译nghttp2
　　cd $BUILD_ROOT
　　wget https://github.com/nghttp2/nghttp2/releases/download/v1.32.0/nghttp2-1.32.0.tar.gz
　　tar zxf nghttp2-1.32.0.tar.gz
　　rm -f nghttp2-1.32.0.tar.gz
　　cd nghttp2-1.32.0
　　CFLAGS="-g -O3" CXXFLAGS="-g -O3" ./configure --host=mipsel-openwrt-linux --prefix=$PREFIX --enable-lib-only
　　make -j$THREAD
　　make install
　　cd $BUILD_ROOT
　　mv nghttp2-1.32.0 $BUILD_ROOT_FINISHED/nghttp2-1.32.0
else
　　echo nghttp2未配置编译，跳过
fi
#编译libcurl
echo 开始编译libcurl
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/curl-7.54.0.tar.gz
tar zxf curl-7.54.0.tar.gz
rm -f curl-7.54.0.tar.gz
cd curl-7.54.0<br>#根据上面可选编译执行的情况，如果选择了libcurl会自动加入libssh2和http2库文件支持
./configure --host=mipsel-openwrt-linux --prefix=$PREFIX
make -j$THREAD
make install
cd $BUILD_ROOT
mv expat-2.1.0 $BUILD_ROOT_FINISHED/expat-2.1.0
#编译Transmission（本次的主角）
echo 开始编译Transmission
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/transmission-2.94.tar.xz
tar xf transmission-2.94.tar.xz
rm -f transmission-2.94.tar.xz
cd transmission-2.94/libtransmission
#修正原文件错误的定义，参考<sys/quota.h>修正
echo 依平台修正libtransmission下的platform-quota.c
sed -i  's/spaceused = (int64_t) btodb(dq.dqb_curblocks);/spaceused = (int64_t) btodb(dq.dqb_curspace);/g' platform-quota.c
cd ..
#如果你编译的目标机处理能力不强，请加上--enable-lightweight参数
./configure --host=mipsel-openwrt-linux --prefix=$PREFIX --enable-nls
make -j$THREAD
make install
cd $BUILD_ROOT
mv transmission-2.94 $BUILD_ROOT_FINISHED/transmission-2.94
echo 本脚本执行完成
