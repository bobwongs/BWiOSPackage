
# iOS Package Research Script
# Author: BobWong

# 基本参数配置
path_info_plist='BWiOSPackage/Info.plist'  # plist路径
tool_plist='/usr/libexec/PlistBuddy'  # plist工具

# 修改版本号
app_version=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" $path_info_plist`
echo 'App version is '$app_version

# 修改Build号
$tool_plist -c "Set :CFBundleVersion 204" ${path_info_plist}

# 判断授权文件类型

# 获得git数量，作为版本号
