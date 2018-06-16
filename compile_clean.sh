##compile_clean.sh
##version:1.2
USER=`whoami`
USER_ROOT=/$USER
BUILD_ROOT=$USER_ROOT/build
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
#是否执行反安装操作,默认不执行，写1执行
isuninstall=0
 
if [ $USER != root ]
then
　　echo 需要root权限执行清理操作
　　exit 1
fi
if [ isuninstall = 1 ]
then
　　echo 执行反安装操作
　　cd $BUILD_ROOT_FINISHED/expat-2.1.0
　　make uninstall
　　cd $BUILD_ROOT_FINISHED/XML-Parser-2.44
　　make uninstall
　　cd $BUILD_ROOT_FINISHED/intltool-0.51.0
　　make uninstall
fi
rm -rf $BUILD_ROOT
