#！/bin/sh
##交叉编译环境准备脚本
##Prepare_CrossCompile.sh　　　　
##version：1.3
##使用方式：终端运行sh prepare.sh
#SDK下载配置，默认采用OpenWRT的SDK，修改为非1的值将配置PandoraBox的SDK
#1:OpenWRT
#2(其他):PandoraBox
SDKVERSION=1
#检测执行用户
echo 检测执行用户
USER=`whoami`
#配置全局位置变量
echo 配置脚本全局变量
if [ $USER = root ]
then
    $USER_ROOT=/$USER
else
    USER_ROOT=/home/$USER/
fi
BUILD_ROOT=$USER_ROOT/build/
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
CROSS_COMPILER_STAGING_DIR=$BUILD_ROOT/SDK/staging_dir/
#创建编译工作目录
echo 创建编译工作目录$BUILD_ROOT
mkdir $BUILD_ROOT
cd $BUILD_ROOT
echo 根据选择下载SDK
echo 目前根据现有平台提供两种交叉编译工具链，如需选择请在本文件前面的配置处选择
if [ $SDKVERSION = 1 ]
then
    #下载OpenWRTSDK，得到交叉编译工具链
    echo 开始下载OpenWRTSDK
    wget -c -O OpenWRTSDK.tar.xz https://downloads.openwrt.org/releases/18.06.0-rc1/targets/ar71xx/tiny/openwrt-sdk-18.06.0-rc1-ar71xx-tiny_gcc-7.3.0_musl.Linux-x86_64.tar.xz
    tar -xf OpenWRTSDK.tar.xz
    mv openwrt-sdk-18.06.0-rc1-ar71xx-tiny_gcc-7.3.0_musl.Linux-x86_64 SDK
    CROSS_COMPILER_ROOT=$CROSS_COMPILER_STAGING_DIR/toolchain-mips_24kc_gcc-7.3.0_musl/bin/
else
    #下载PandoraBoxSDK，得到交叉编译工具链
    echo 开始下载PandoraBoxSDK
    wget -c -O PandoraBoxSDK.tar.xz https://pandorabox.leoslion.top/pandorabox/17.11/PandoraBox-SDK-ralink-mt7620_gcc-5.4.0_uClibc-1.0.x.Linux-x86_64.tar.xz
    tar -xf PandoraBoxSDK.tar.xz
    mv PandoraBox-SDK-ralink-mt7620_gcc-5.4.0_uClibc-1.0.x.Linux-x86_64 SDK
    CROSS_COMPILER_ROOT=$CROSS_COMPILER_STAGING_DIR/toolchain-mipsel_24kec+dsp_gcc-5.4.0_uClibc-1.0.x/bin/
    #修正libstdc++.la库文件配置
    sed -i s/\/home\/user\/src\/pandorabox/\/home\/xiang\/build\/SDK/g $CROSS_COMPILER_ROOT/../lib/
fi
#写入交叉编译器环境变量到用户环境变量
echo 配置编译器环境变量
echo export PATH=\$PATH:$CROSS_COMPILER_ROOT >> $USER_ROOT/.bashrc
echo export STAGING_DIR=$CROSS_COMPILER_STAGING_DIR >> $USER_ROOT/.bashrc
echo 脚本运行完毕，请自行检查运行结果
echo 检查示例：打开一个新终端，输入编译前缀然后tab回车，能自动补全则环境配置成功