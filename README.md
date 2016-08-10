# BWiOSPackage

iOS Project and Package

## iOS Xcode Project
- Workspace  
简单来说，Workspace就是一个容器，在该容器中可以存放多个你创建的Xcode Project， 以及其他的项目中需要使用到的文件。使用Workspace的好处有，1),扩展项目的可视域，即可以在多个项目之间跳转，重构，一个项目可以使用另一个项目的输出。Workspace会负责各个Project之间提供各种相互依赖的关系;2),多个项目之间共享Build目录。
- Project  
指一个项目，该项目会负责管理生成一个或者多个软件产品的全部文件和配置，一个Project可以包含多个Target。
- Target  
一个Target是指在一个Project中构建的一个产品，它包含了构建该产品的所有文件，以及如何构建该产品的配置。
- Scheme  
一个定义好构建过程的Target成为一个Scheme。可在Scheme中定义的Target的构建过程有：Build/Run/Test/Profile/Analyze/Archive
- Build Setting  
配置产品的Build设置，比方说，使用哪个Architectures？使用哪个版本的SDK？。在Xcode Project中，有Project级别的Build Setting，也有Target级别的Build Setting。Build一个产品时一定是针对某个Target的，因此，XCode中总是优先选择Target的Build Setting，如果Target没有配置，则会使用Project的Build Setting。
- Build Phases  
	- Target Dependencies
	- Compile Sources（编译资源，可设置Compiler Flags）
	- Link Binary With Libraries
	- Copy Bundle Resources（直接拷贝到包里面的资源）
	- Run Script（运行脚本，运行脚本不用拷贝到Bundle
	
## Xcode打包
- 打包机制
	- 流程  
	xcodebuild -> Package；
	- xcodebuild

		- Result  
		.app和.DYSM；
	- Code Signing
- xcodebuild
	- 流程细节  
		预处理 -> Compile -> Link -> Copy Resource、Compile Xib -> Some Intermediate -> Code Signing -> Result；

## 脚本打包

## iOS ipa包
- ipa包的解压  
	修改后缀名，把后缀名修改为Mac OS可解压的，如：ipa -> zip；
- 从优秀App的ipa包中提炼信息
	如微信等知名应用的ipa包；

## 持续化集成

## 自动化构建
- 自动化构建的的首要前提  
Anyone should be able to bring in a virgin machine, check the sources 
out of the repository, issue a single command, and have a running 
system on their machine.
自动化构建的的首要前提是有一个支持自动化构建的命令行工具，可以让开发人员可以通过一个简单的命令运行当前项目。

## 命令行工具
自动化构建的命令行工具比持续集成的概念要诞生得早很多，几十年前，Unix世界就已经有了Make，而Java世界有Ant，Maven，以及当前最流行的Gradle，.Net世界则有Nant和MSBuild。作为以GUI和命令行操作结合的完美性著称的苹果公司来说，当然也不会忘记为自己的封闭的iOS系统提供开发环境下命令行编译工具：xcodebuild