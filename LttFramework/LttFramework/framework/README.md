## 说明
本项目为框架项目    

* framework为框架源代码，其它项目导入该目录，添加如下Cocoa Touch依赖，即可正常使用  
* demo项目仅为测试框架用，并无实际意义  
* 使用CocoaLumberjack需要安装XcodeColors插件  
* 其它项目使用RestKit需要在编译选项Other Linker Flags增加-ObjC选项  

## 依赖
QuartzCore.framework (Toast)  

CoreGraphics.framework (MBProgressHUD)  

SystemConfiguration.framework (Reachability)  

Accelerate.framework (REFrostedViewController)  

ImageIO.framework (SDWebImage)  

AVFoundation.framework (ZBarSDK)  
CoreMedia.framework (ZBarSDK)  
CoreVideo.framework (ZBarSDK)  
QuartzCore.framework (ZBarSDK)  
libiconv.dylib (ZBarSDK)  

CFNetwork.framework (RestKit)  
SystemConfiguration.framework (RestKit)  
MobileCoreServices.framework (RestKit)  
CoreData.framework (RestKit)  
Security.framework (RestKit)  
QuartzCore.framework (RestKit)  
libxml2.dylib (RestKit)  
