##install.sh
##version:1.1
#获取当前的绝对路径
basepath=$(cd `dirname $0`; pwd)
#package的绝对路径
PACKAGE_DIR=$basepath/package
#默认安装的位置,可自行修改
INSTALL_PATH=/usr
INSTALL_EXECPATH=$INSTALL_PATH/bin/
INSTALL_LIBPATH=$INSTALL_PATH/lib/
INSTALL_SHAREPATH=$INSTALL_PATH/share/
##
tar zxf package.tar.gz
cd package
#创建软连接到程序目录，如果不需要软连接，请去除-s参数
ln -s $PACKAGE_DIR/bin/* $INSTALL_EXECPATH
ln -s $PACKAGE_DIR/lib/* $INSTALL_LIBPATH
ln -s $PACKAGE_DIR/share/* $INSTALL_SHAREPATH
#链接指定版本的库文件
cd $INSTALL_LIBPATH
ln -s -f $INSTALL_LIBPATH/libcurl.so.4.4.0 $INSTALL_LIBPATH/libcurl.so.4
ln -s -f $INSTALL_LIBPATH/libevent-2.1.so.6.0.2 $INSTALL_LIBPATH/libevent-2.1.so.6
ln -s -f $INSTALL_LIBPATH/libevent_core-2.1.so.6.0.2 $INSTALL_LIBPATH/libevent_core-2.1.so.6
ln -s -f $INSTALL_LIBPATH/libevent_extra-2.1.so.6.0.2 $INSTALL_LIBPATH/libevent_extra-2.1.so.6
ln -s -f $INSTALL_LIBPATH/libevent_openssl-2.1.so.6.0.2 $INSTALL_LIBPATH/libevent_openssl-2.1.so.6
ln -s -f $INSTALL_LIBPATH/libevent_pthreads-2.1.so.6.0.2 $INSTALL_LIBPATH/libevent_pthreads-2.1.so.6
#ln -s -f $INSTALL_LIBPATH/libexpat.so.1.6.0 $INSTALL_LIBPATH/libexpat.so.1
ln -s -f $INSTALL_LIBPATH/libssl.so.1.1 $INSTALL_LIBPATH/libssl.so.1
ln -s -f $INSTALL_LIBPATH/libz.so.1.2.11 $INSTALL_LIBPATH/libz.so.1
ln -s -f $INSTALL_LIBPATH/libz.so.1.2.11 $INSTALL_LIBPATH/libz.so
#修改系统内核配置文件，解决UDP转发缓存区设置失败
echo \#transmission add >> /etc/sysctl.conf
echo net.core.rmem_max = 4194304 >> /etc/sysctl.conf
echo net.core.wmem_max = 1048576 >> /etc/sysctl.conf
