##cross_compile_clean.sh
##version:1.2
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
rm -rf $BUILD_ROOT
#清除环境变量
sed -i 's/export PATH=\$PATH:$CROSS_COMPILER_ROOT//g' $USER_ROOT/.bashrc
sed -i 's/export STAGING_DIR=$CROSS_COMPILER_STAGING_DIR//g' $USER_ROOT/.bashrc
echo 脚本执行完毕
