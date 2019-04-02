# iOS自动化构建-Fastlane

iOS自动化构建工具Fastlane，在现有项目中的使用总结。

从结合Fastlane的技术方案设计，到最后设计想法的落地实现，能够稳定的运用在日常Xcode项目的构建上。

其中，也踩了很多坑，随着Xcode的不断升级，会出现现有的Fastlane命令不兼容的现象，达不到文档中描述的原有功能的效果，因此在这也把这些坑给总结了。



## Contents

- 痛点
- 方案设计
- 经验总结
- Fastlane的实用操作
- 源码
- Reference



## 痛点

使用Xcode应用界面打包流程繁琐，耗费时间长，难以增配更加灵活的自定制构建。

手动管理苹果证书网站上的证书和授权文件的麻烦。

使用xcodebuild脚本做项目构建，可读性差，难以维护。

Xcode升级，又有需要维护和更新新脚本的可能，费心费力。

**因此，运用Fastlane来解决iOS Xcode项目构建中的痛点。**

## 

## 方案设计

##### 全流程设计

全流程控制：Shell脚本，在Xcode项目根目录下执行

流程

> 执行入口，带参传入（接受参数：接口环境、构建的ipa包类型、Target，等等，后续可继续扩展）
>
> 替换接口配置文件
>
> 触发Fastlane中的lane进行核心的构建环节



##### 构建的核心技术

Fastlane

>证书文件和授权文件的管理：match命令
>
>打包：对xcodebuild封装的gym
>
>跨项目使用公共Lane：Git私有仓库管理的Fastfile



##### 开发语言

Shell

Ruby



##### 持续集成平台

Jenkins



## 经验总结

针对打包，Xcode中也需要做相应的配置，让脚本顺利运行，如：

> 修改Xcode工程的build号，需要在versioning上做配置。

使用exec bundle update，进行ruby依赖的安装和升级，让本地的依赖库为最新。



## Fastlane的实用操作

##### 命令

**match**

描述

>证书和授权文件的管理，在证书网站自动创建和管理授权文件，下载到本地和安装，并且把文件备份到指定的git地址上，供项目成员间使用。

经验

>管理好match相关的密码，供项目成员间使用，忘记密码也可进行重置。
>
>给match的初始git，需要为全空的git仓库。
>
>使用ssh登录远程机子时，需要改变钥匙串的访问权限，以让match能够正常运作。
>
>match生成的授权文件名称格式：match #{to_sign_profile_tag_name} #{app_id}，其中to_sign_profile_tag_name的名称为AppStore, AdHoc, Enterprise, Development。
>
>使用match命令时，需要在命令行输入证书网站的密码，让Fastlane能够跟证书网站交互。

示例（为Fastfile上的自定义lane，也可在命令行直接使用match）

```ruby
lane :bm_match_indivisual do |options|
    app_id = CredentialsManager::AppfileConfig.try_fetch_value(:app_identifier)
    package_type = options[:type]
    match(
        username: "[[your email address]]",
        app_identifier: app_id,
        type: package_type,
        readonly: false,
        git_url: "[[your private git repo url]]"
    )
    # type（类型字段）：appstore, adhoc, development, enterprise
end
```



**gym**

描述

> 构建Xcode项目，基于xcodebuild

经验

> 有些Xcode版本或者新版，使用match方法后执行gym不会自动匹配match方法指定的构建包类型，需要在xcargs参数中手动指定，导出配置export_options中也要做设置。
>
> 新版Xcode可能需要允许授权文件更新，export_xcargs: "-allowProvisioningUpdates”。（待验证，有无设值似乎没差别）
>
> 使用不带sudo的命令执行，sudo会报找不到证书匹配的授权文件的错误。

示例（Fastfile中使用）

```ruby
gym(
    scheme: package_scheme,
    xcargs: {
        :BUNDLE_IDENTIFIER => app_id,
        :PROVISIONING_PROFILE_SPECIFIER => to_sign_profile_name
    },
    export_method: export_ipa_method, # app-store, ad-hoc, package, enterprise, development, developer-id
    export_xcargs: "-allowProvisioningUpdates",
    export_options: {
    provisioningProfiles: {
        app_id => to_sign_profile_name
        },
        compileBitcode: false
    },
    clean: true,
    output_directory: custom_output_directory,
    output_name: custom_output_ipa_name,
    silent: true
)
```



**文件配置**

“项目根目录/fastlane”目录：

Fastfile

> 自定义lane
>
> 引用git仓库中的lane，可运用于跨项目公用的lane
>
> ```ruby
> import_from_git(url: 'git_url', path: 'fastlane/Fastfile')
> ```

Appfile

> App信息的配置，配置App ID，供脚本中获取

Matchfile

> match命令的默认参数配置



**“项目根目录/Gemfile”目录：**

> ruby依赖库的配置
>
> gym命令的默认参数配置



**技术原理**

xcodebuild

ruby

OpenSSL：证书管理



## 源码

团队Gitlab私有仓库：http://gitlab.admin.bluemoon.com.cn/wangbo/tool.git



## Reference

**Fastlane**

[https://docs.fastlane.tools](https://docs.fastlane.tools/)

参数配置：<https://github.com/fastlane/fastlane/issues/12849>

