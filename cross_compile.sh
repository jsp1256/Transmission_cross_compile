##cross_compile.sh
##version:1.5
#配置工作目录变量
basepath=$(cd `dirname $0`; pwd)
BUILD_ROOT=$basepath/build/
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
#SSL编译配置，互斥：
openssl=1
wolfssl=0
#可选编译配置
#写0关闭，默认开启
libssh2=1
nghttp2=1
#配置工作目录
mkdir $BUILD_ROOT
mkdir $BUILD_ROOT_FINISHED
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
#复制相关头文件至编译器目录
cp zlib.h $CROSS_COMPILER_ROOT/../include
cp zconf.h $CROSS_COMPILER_ROOT/../include
cd $BUILD_ROOT
mv zlib-1.2.11 $BUILD_ROOT_FINISHED/zlib-1.2.11
if [ $openssl = 1 ]
then
   #编译openssl
   echo 开始编译openssl
   cd $BUILD_ROOT
   wget https://www.openssl.org/source/openssl-1.1.0h.tar.gz
   tar zxf openssl-1.1.0h.tar.gz
   rm -f openssl-1.1.0h.tar.gz
   cd openssl-1.1.0h
   ./config no-asm zlib-dynamic --prefix=$PREFIX
   #因为原配置文件不能自动配置交叉编译环境，针对交叉编译器修正一些配置
   echo 修正Makefile文件
   sed -i  's/-m64//g' Makefile
   sed -i  's/CROSS_COMPILE=/CROSS_COMPILE=mipsel-openwrt-linux-/g' Makefile
   make -j$THREAD
   make install
   #复制相关头文件至编译器目录
   cp -r install/openssl $CROSS_COMPILER_ROOT/../include/
   cd $BUILD_ROOT
   mv openssl-1.1.0h $BUILD_ROOT_FINISHED/openssl-1.1.0h
elif [ $wolfssl = 1 ]
then
   #编译wolfssl
   echo 开始编译wolfssl
   cd $BUILD_ROOT
   wget https://github.com/jsp1256/Transmission_cross_compile/raw/master/package/wolfssl-3.15.0.zip
   unzip wolfssl-3.15.0.zip
   rm wolfssl-3.15.0.zip
   cd wolfssl-3.15.0
   ./configure --host=mipsel-openwrt-linux --enable-all --enable-ipv6 --with-libz=$PREFIX --prefix=$PREFIX
   make
   make install
   #复制相关头文件至编译器目录
   cp -r wolfssl/ $CROSS_COMPILER_ROOT/../include/
   cp -r cyassl/ $CROSS_COMPILER_ROOT/../include/
   cd $BUILD_ROOT
   mv wolfssl-3.15.0 $BUILD_ROOT_FINISHED/wolfssl-3.15.0
fi
#编译libevent
echo 开始编译libevent
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/libevent-2.1.8-stable.tar.gz
tar zxf libevent-2.1.8-stable.tar.gz
rm-f libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
if [ $openssl = 1]
   ./configure --host=mipsel-openwrt-linux -disable-samples --prefix=$PREFIX
elif [ $wolfssl = 1 ]
   ./configure --host=mipsel-openwrt-linux -disable-samples --prefix=$PREFIX --disable-openssl
else
   echo 没有配置openssl库，取消编译
   exit 1
fi
make -j$THREAD
make install
#复制相关头文件至编译器目录
cp -r include/event2/ $CROSS_COMPILER_ROOT/../include/
cd $BUILD_ROOT
mv libevent-2.1.8-stable $BUILD_ROOT_FINISHED/libevent-2.1.8-stable
 
#可选：编译libssh2
#如果使用wolfssl，貌似不能通过libssh2的配置文件
echo "检查是否编译libssh2"
if [ $libssh2 = 1 ]
then
   echo "libssh2编译被激活，开始编译libssh2"
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
   echo "libssh2未配置编译，跳过"
fi
#可选：编译nghttp2
echo "检查是否编译nghttp2"
if [ $nghttp2 = 1 ]
then
   echo "nghttp2编译被激活，开始编译nghttp2"
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
   echo "nghttp2未配置编译，跳过"
fi
#编译libcurl
echo 开始编译libcurl
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/curl-7.54.0.tar.gz
tar zxf curl-7.54.0.tar.gz
rm -f curl-7.54.0.tar.gz
cd curl-7.54.0
#根据上面可选编译执行的情况，如果选择了libcurl会自动加入libssh2和http2库文件支持
if [ $openssl = 1]
   ./configure --host=mipsel-openwrt-linux --prefix=$PREFIX
elif [ $wolfssl = 1 ]
   #hostip6.c:218:11: error: implicit declaration of function 'Curl_getaddrinfo_ex' [-Werror=implicit-function-declaration]
   #hostip6.c:225:5: error: implicit declaration of function 'Curl_addrinfo_set_por ' [-Werror=implicit-function-declaration]
   #./configure --host=mipsel-openwrt-linux --prefix=$PREFIX --with-cyassl
   #因为以上原因放弃curl集成libwolfssl，待找到修复方式后恢复
   ./configure --host=mipsel-openwrt-linux --prefix=$PREFIX
else
   echo 没有配置openssl库，取消编译
   exit 1
fi
make -j$THREAD
make install
cd $BUILD_ROOT
mv curl-7.54.0 $BUILD_ROOT_FINISHED/curl-7.54.0
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
if [ $openssl = 1]
   ./configure --host=mipsel-openwrt-linux --prefix=$PREFIX --enable-nls
elif [ $wolfssl = 1 ]
   ./configure --host=mipsel-openwrt-linux --prefix=$PREFIX --enable-nls --with-crypto=cyassl
else
   echo 没有配置openssl库，取消编译
   exit 1
fi
make -j$THREAD
make install
cd $BUILD_ROOT
mv transmission-2.94 $BUILD_ROOT_FINISHED/transmission-2.94
echo 本脚本执行完成
