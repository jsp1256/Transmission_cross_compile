##start.sh
##version:1.3
echo 准备环境
sh prepare.sh
res=$?
if [ res = 0 ]
then
　　echo 环境准备完成
else
　　echo 环境准备失败
　　exit 1
fi
echo 开始交叉编译
sh cross_compile.sh
res=$?
if[ res = 0 ]
then
　　echo 交叉编译完成
else
　　echo 交叉编译失败
　　exit 1
fi
echo 打包程序到package.tar.gz
sh make_gzip.sh
res=$?
if [ res = 0 ]
then
　　echo 打包完成
else
　　echo 打包失败
　　exit 1
fi
