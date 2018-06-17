##make_gzip.sh
##version:1.1
#Transmission Webui设置
#写1表示使用ronggang的webui，写0表示使用原版UI
Webui=1
#curl,openssl复制设置
need_curl_openssl=0
#执行用户检测
basepath=$(cd `dirname $0`; pwd)
BUILD_ROOT=$basepath/build/
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
CROSS_COMPILER_STAGING_DIR=$BUILD_ROOT/PandoraBoxSDK/staging_dir/
CROSS_COMPILER_ROOT=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/bin/
#编译安装位置相关位置，如前面有修改，请修改下文部分
PREFIX=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/usr/
PREFIX_EXEC=$PREFIX/bin/
PREFIX_LIB=$PREFIX/lib/
PREFIX_SHARE=$PREFIX/share/
#打包目录位置
PACKAGE_DIR=$BUILD_ROOT/package
PACKAGE_DIR_BIN=$BUILD_ROOT/package/bin
PACKAGE_DIR_LIB=$BUILD_ROOT/package/lib
PACKAGE_DIR_SHARE=$BUILD_ROOT/package/share
#创建打包目录
mkdir $PACKAGE_DIR
cd $PACKAGE_DIR
#复制可执行二进制文件
mkdir $PACKAGE_DIR_BIN
cd $PACKAGE_DIR_BIN
cp $PREFIX_EXEC/transmission-create .
cp $PREFIX_EXEC/transmission-edit .
cp $PREFIX_EXEC/transmission-show.
cp $PREFIX_EXEC/transmission-daemon .
cp $PREFIX_EXEC/transmission-remote .
if [ need_curl_openssl = 1 ]
then
    cp $PREFIX_EXEC/curl
    cp $PREFIX_EXEC/curl-config
    cp $PREFIX_EXEC/openssl
fi
#复制相关依赖库
mkdir $PACKAGE_DIR_LIB
cd $PACKAGE_DIR_LIB
cp $PREFIX_LIB/libcrypto.so.1.1 .
cp $PREFIX_LIB/libcurl.so.4.4.0 .
cp $PREFIX_LIB/libevent-2.1.so.6.0.2 .
cp $PREFIX_LIB/libevent_core-2.1.so.6.0.2 .
cp $PREFIX_LIB/libevent_extra-2.1.so.6.0.2 .
cp $PREFIX_LIB/libevent_openssl-2.1.so.6.0.2 .
cp $PREFIX_LIB/libevent_openssl-2.1.so.6.0.2 .
cp $PREFIX_LIB/libevent_pthreads-2.1.so.6.0.2 .
#cp $PREFIX_LIB/libexpat.so.1.6.0 .
cp $PREFIX_LIB/libssl.so.1.1 .
cp $PREFIX_LIB/libz.so.1.2.11 .
#复制share
mkdir $PACKAGE_DIR_SHARE
cd $PACKAGE_DIR_SHARE
mkdir man
cd man
cp -R $PREFIX_SHARE/man/man1 .
cd ..
mkdir transmission
cd transmission
echo 检查是否使用新版UI，默认开启
if [ $Webui = 1 ]
then
    echo 使用新版UI
    wget https://github.com/ronggang/transmission-web-control/archive/v1.6.0-alpha.zip
    unzip  v1.6.0-alpha.zip
    mv transmission-web-control-1.6.0-alpha/src/ web
    rm -f v1.6.0-alpha.zip
    rm -rf transmission-web-control-1.6.0-alpha/
else
    echo 使用原版UI
    cp -R $PREFIX_SHARE/transmission/web/ .
fi
#执行打包操作
cd $BUILD_ROOT
tar -cvzpf package.tar.gz package
