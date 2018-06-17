##compile.sh
##version:1.4
USER=`whoami`
basepath=$(cd `dirname $0`; pwd)
BUILD_ROOT=$basepath/build/
BUILD_ROOT_FINISHED=$BUILD_ROOT/finished/
#编译使用的线程数
THREAD=1
if [ $USER != root ]
then
    echo 需要root权限执行编译
    exit 1
fi
#配置工作目录
mkdir $BUILD_ROOT
mkdir $BUILD_ROOT_FINISHED
#编译expat
echo 开始编译expat
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/expat-2.1.0.tar.gz
tar zxf expat-2.1.0.tar.gz
rm -f expat-2.1.0.tar.gz
cd expat-2.1.0
./configure
make　-j$THREAD
make install
cd $BUILD_ROOT
mv expat-2.1.0 $BUILD_ROOT_FINISHED/expat-2.1.0
#编译XML-Parser
echo 开始编译XML-Parser
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/XML-Parser-2.44.tar.gz
tar zxf XML-Parser-2.44.tar.gz
rm -f XML-Parser-2.44.tar.gz
cd XML-Parser-2.44
perl Makefile.PL
make -j$THREAD
make install
cd $BUILD_ROOT
mv XML-Parser-2.44 $BUILD_ROOT_FINISHED/XML-Parser-2.44
#编译intltool
echo 开始编译intltool
cd $BUILD_ROOT
wget http://down.whsir.com/downloads/intltool-0.51.0.tar.gz
tar zxf intltool-0.51.0.tar.gz
rm -f intltool-0.51.0.tar.gz
cd intltool-0.51.0
./configure
make -j$THREAD
make install
cd $BUILD_ROOT
mv intltool-0.51.0 $BUILD_ROOT_FINISHED/intltool-0.51.0
