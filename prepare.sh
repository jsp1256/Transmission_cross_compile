##prepare.sh　　　　
##version：1.2
#检测当前用户
USER=`whoami`
if [ $USER = root ]
then
    USER_ROOT=""/$USER/
else
    USER_ROOT="/home/"$USER
fi
#配置全局位置变量
basepath=$(cd `dirname $0`; pwd)
BUILD_ROOT=$basepath/build/
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
CROSS_COMPILER_STAGING_DIR=$BUILD_ROOT/PandoraBoxSDK/staging_dir/
CROSS_COMPILER_ROOT=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/bin/
#创建编译工作目录
mkdir $BUILD_ROOT
cd $BUILD_ROOT
#下载PandoraBoxSDK，得到交叉编译工具链
wget -O PandoraBoxSDK.tar.xz https://pandorabox.leoslion.top/pandorabox/17.11/PandoraBox-SDK-ralink-mt7620_gcc-5.4.0_uClibc-1.0.x.Linux-x86_64.tar.xz
tar -xf PandoraBoxSDK.tar.xz
mv PandoraBox-SDK-ralink-mt7620_gcc-5.4.0_uClibc-1.0.x.Linux-x86_64 PandoraBoxSDK
#写入交叉编译器环境变量到用户环境变量
echo export PATH=\$PATH:$CROSS_COMPILER_ROOT >> $USER_ROOT/.bashrc
echo export STAGING_DIR=$CROSS_COMPILER_STAGING_DIR >> $USER_ROOT/.bashrc
