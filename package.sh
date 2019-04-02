
# iOS Package Script
# Author: BobWong

# Shell终端打包示例：./package.sh 后端环境 Build号，使用示例，./package.sh 0 100，0代表生产环境

# ---------- 参数配置 ----------

path_project=`pwd`  # 工程路径
path_build=${path_project}/build  # build文件夹路径
path_info_plist=${path_project}/BWiOSPackage/Info.plist  # Info.plist路径

tool_plist="/usr/libexec/PlistBuddy"  # plist工具

echo "================工程路径:$path_project================"
echo "================工程build文件夹路径:$path_build================"


# ---------- 获取传入参数 ----------

environment=$1
build_number=$2

if [ ! $environment ]; then
environment=0  # 参数1为空，则默认为0
fi
if [ ! $build_number ]; then
build_number=0  # 参数2为空，则默认为0
fi


# ---------- 修改项目配置和项目代码 ----------

# 修改后端环境
sed -i ".tmp" "/kEnvironment/s/=.*;/= $environment;/" BWiOSPackage/Network/BWNetworkKit.m
rm BWiOSPackage/Network/BWNetworkKit.m.tmp  # 谨慎使用移除暂存文件的操作

# 修改Build号
$tool_plist -c "Set :CFBundleVersion $build_number" ${path_info_plist}


# ---------- 获得参数 ----------

# App Display Name
app_display_name=`$tool_plist -c "Print :CFBundleDisplayName" $path_info_plist`
# App版本号
app_version=`$tool_plist -c "Print :CFBundleShortVersionString" $path_info_plist`
# Build号
build_number_final=`$tool_plist -c "Print :CFBundleVersion" $path_info_plist`


# 其他
date_string=`date +"%Y%m%d_%H%M%S"`
if [ $environment==0 ]; then
environment_name="生产环境"
else
environment_name="测试环境"
fi

ipa_name=${app_display_name}_${date_string}_${environment_name}_${app_version}\(${build_number_final}\).ipa
echo "=============ipa name is $ipa_name============"

# xcodebuild
# clean
xcodebuild clean
#rm -r $path_build  # 不需要移除build目录

# build
xcodebuild


# Package
# Package，包放置到桌面Packages目录
dir_package="ios_package"
mv $path_build ${HOME}/Desktop/Packages

cd ${HOME}/Desktop/Packages
mkdir dir_package
mv build/Release-iphoneos/BWiOSPackage.app dir_package/BWiOSPackage.app
mv build/Release-iphoneos/BWiOSPackage.app.dSYM dir_package/BWiOSPackage.app.dSYM
rm -r build

cd dir_package
mkdir Payload
mv BWiOSPackage.app Payload/BWiOSPackage.app
zip -r BWiOSPackage.ipa Payload
rm -r Payload

mv BWiOSPackage.ipa ${ipa_name}.ipa

echo "=======打包完成======="

# 备注
# Shell脚本的语法中不要在“=”号两边使用空格，会解析不了脚本
# “./文件名”和“文件名”在移动、复制、删除时候的效果是一样的，不过在运行脚本的时候是不同的，同目录名的效果
# Shell定义变量variable=10，读变量的值$variable，修改变量的值variable=30
# Shell字符串拼接，string=${变量名}_${变量名}_字符串\(${变量名}\).file，括号需要用转义字符
# ` `这两种引号里面为Shell的执行命令
