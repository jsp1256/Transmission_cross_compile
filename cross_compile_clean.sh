##cross_compile_clean.sh
##version:1.1
USER=`whoami`
#配置全局位置变量
#cross_compile.sh使用的哪个用户本次依旧由那个用户调用执行
if [ $USER = root ]
then
　　$USER_ROOT=/$USER
else
　　USER_ROOT=/home/$USER/
fi
BUILD_ROOT=$USER_ROOT/build
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
CROSS_COMPILER_STAGING_DIR=$BUILD_ROOT/PandoraBoxSDK/staging_dir/
CROSS_COMPILER_ROOT=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/bin/
rm -rf $BUILD_ROOT
#清除环境变量
sed -i 's/export PATH=\$PATH:$CROSS_COMPILER_ROOT//g' .bashrc
sed -i 's/export STAGING_DIR=$CROSS_COMPILER_STAGING_DIR//g' .bashrc
echo 脚本执行完毕
