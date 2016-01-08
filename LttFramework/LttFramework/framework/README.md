说明
==========
本项目为框架项目    

* framework为框架源代码，其它项目导入该目录，添加如下Cocoa Touch依赖，即可正常使用  
* demo项目仅为测试框架用，并无实际意义  
* 使用CocoaLumberjack需要安装XcodeColors插件  
* 其它项目使用RestKit需要在编译选项Other Linker Flags增加-ObjC选项  

依赖
----------
框架项目依赖如下，如需使用该模块需添加对应依赖

### NUI 
* CoreImage.framework  
* QuartzCore.framework

### MBProgressHUD
* CoreGraphics.framework

### Reachability
* SystemConfiguration.framework

### REFrostedViewController
* Accelerate.framework 

### SDWebImage
* ImageIO.framework

### ZBarSDK
* AVFoundation.framework
* CoreMedia.framework
* CoreVideo.framework
* QuartzCore.framework  
* libiconv.dylib 

### RestKit
* CFNetwork.framework
* SystemConfiguration.framework
* MobileCoreServices.framework
* CoreData.framework
* Security.framework  
* QuartzCore.framework
* libxml2.dylib
