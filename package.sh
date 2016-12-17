
# iOS Package Script
# Author: BobWong

# Shell终端打包示例：./package.sh 0

# 参数获取
project_path=$(pwd)  # 工程路径
echo "================工程路径:$projectpath================"
# build文件夹路径
build_path=${project_path}/build
echo "================工程build文件夹路径:$buildpath================"

# 获取传入参数
environment=$1

if [ ! $environment ]; then
environment=0  # 参数1为空，则默认为0
fi

# 修改项目配置和项目代码
sed -i ".tmp" "/kEnvironment/s/=.*;/= $environment;/" ./BWiOSPackage/Network/BWNetworkKit.m
rm ./BWiOSPackage/Network/BWNetworkKit.m.tmp

# clean
xcodebuild clean
rm -r build

# build
xcodebuild

# Package，包放置到桌面Packages目录
dir_package=ios_package
mv build ${HOME}/Desktop/Packages

cd ${HOME}/Desktop/Packages
mkdir dir_package
mv ./build/Release-iphoneos/BWiOSPackage.app ./dir_package/BWiOSPackage.app
mv ./build/Release-iphoneos/BWiOSPackage.app.dSYM ./dir_package/BWiOSPackage.app.dSYM
rm -r build

cd dir_package
mkdir Payload
mv ./BWiOSPackage.app Payload/BWiOSPackage.app
zip -r BWiOSPackage.ipa Payload
rm -r Payload

echo "=======打包完成======="

# 备注
# Shell脚本的语法中不要在“=”号两边使用空格，会解析不了脚本
