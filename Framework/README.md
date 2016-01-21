Framework
==========
本项目为框架项目，包含iOS开发MVC框架和常用开发类库

使用方法

	1. 将Framework.xcodeproj和Framework.bundle拖入目标项目中
	2. 目标项目Build Phases配置Link Binary With Libraries中添加libFramework.a
	3. 目标项目Build Settings配置Header Search Paths为Framework目录，并且设置为recursive
	   如：$(PROJECT_DIR)/../../Framework/Framework
	4. 按所使用的模块添加对应依赖并修正Search Paths相对路径，详见依赖部分
	5. Library目录为可选类库，请按需使用，将需要的模块引入项目后添加对应依赖即可，同4

结构
----------
框架源代码目录结构：  

	Framework.bundle: 框架资源文件
	Library: 框架类库，可选使用
	Framework.xcodeproj: 框架静态库Xcode项目文件
	Framework: 框架源代码
		Framework.h: 框架入口头文件
    	config: 框架配置
    	core: 框架核心，MVC基类
    	extension: OC分类扩展
    	library: 框架常用类库
    	util: OC组件工具包
    	vendor: 第三方OC组件

依赖
----------
框架模块依赖如下，如需使用该模块需添加对应依赖

### framework

* Foundation.framework
* UIKit.framework
* CoreLocation.framework => LocationUtil.h
* AudioToolbox.framework => NotificationUtil.m

### ActionSheetPicker

[Github](https://github.com/skywinder/ActionSheetPicker-3.0)

### AFNetworking

[Github](https://github.com/AFNetworking/AFNetworking)

### AlipaySDK

[URL](https://doc.open.alipay.com/doc2/detail?treeId=59&articleId=103563&docType=1)

* libc++.tbd
* libz.tbd
* SystemConfiguration.framework
* CoreTelephony.framework
* QuartzCore.framework
* CoreText.framework
* CoreGraphics.framework
* UIKit.framework
* Foundation.framework
* CFNetwork.framework
* CoreMotion.framework

配置
> 应用跳转需要配置和代码一致的URL Schemes，如：alisdkcomlttoklttmember

iOS9

    <key>NSAppTransportSecurity</key>
    <dict>    
        <key>NSAllowsArbitraryLoads</key><true/>
    </dict>

### Aspects

[Github](https://github.com/steipete/Aspects)

### AXRatingView

[Github](https://github.com/akiroom/AXRatingView)

### BPush

[URL](http://push.baidu.com/doc/ios/api)

* libz.tbd
* Foundation.framework
* CoreTelephony.framework
* SystemConfiguration.framework

### CacheKit

[Github](https://github.com/davbeck/CacheKit)

配置
> CKSQLiteCache依赖于FMDB

### CNPPopupController

[Github](https://github.com/carsonperrotti/CNPPopupController)

### CocoaHTTPServer

[Github](https://github.com/robbiehanson/CocoaHTTPServer)

### CocoaLumberjack

[Github](https://github.com/CocoaLumberjack/CocoaLumberjack)

配置
> XcodeColors组件：[Github](https://github.com/robbiehanson/XcodeColors)

编译

	#ifdef DEBUG
  		static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
	#else
  		static const DDLogLevel ddLogLevel = DDLogLevelWarn;
	#endif

### CocoaUI

[Github](https://github.com/ideawu/cocoaui)

* libxml2.tbd

配置
> 项目Header Search Paths添加：/usr/include/libxml2

### DLRadioButton

[Github](https://github.com/DavydLiu/DLRadioButton)

### EGOCache

[Github](https://github.com/enormego/EGOCache)

### FLEX

[Github](https://github.com/Flipboard/FLEX)

* libz.tbd
* libsqlite3.tdb
* ImageIO.framework

编译
> Release环境添加User-Defined Setting如下：

    EXCLUDED_SOURCE_FILE_NAMES => FLEX*

### FMDB

[Github](https://github.com/ccgus/fmdb)

* libsqlite3.tbd

### GPUImage

[Github](https://github.com/BradLarson/GPUImage)

* CoreMedia.framework
* CoreVideo.framework
* OpenGLES.framework
* AVFoundation.framework
* QuartzCore.framework

### Harpy

[Github](https://github.com/ArtSabintsev/Harpy)

### iCarousel

[Github](https://github.com/nicklockwood/iCarousel)

* QuartzCore.framework

### JSONModel

[Github](https://github.com/icanzilb/JSONModel)

* SystemConfiguration.framework

### JSPatch

[Github](https://github.com/bang590/JSPatch)

* JavaScriptCore.framework

### libqrencode

[Github](https://github.com/fukuchi/libqrencode)

### Mantle

[Github](https://github.com/Mantle/Mantle)

### Masonry

[Github](https://github.com/SnapKit/Masonry)

### MBProgressHUD

[Github](https://github.com/jdg/MBProgressHUD)

* CoreGraphics.framework

### MGBoxKit

[Github](https://github.com/sobri909/MGBoxKit)

* QuartzCore.framework
* CoreText.framework

### MJExtension

[Github](https://github.com/CoderMJLee/MJExtension)

### MJRefresh

[Github](https://github.com/CoderMJLee/MJRefresh)

### MRProgress

[Github](https://github.com/mrackwitz/MRProgress)

* QuartzCore.framework
* CoreGraphics.framework
* Accelerate.framework

### NSObject+ObjectMap

[Github](https://github.com/uacaps/NSObject-ObjectMap)

### NUI 

[Github](https://github.com/tombenner/nui)

* CoreImage.framework  
* QuartzCore.framework

依赖
> NUIParse(已包含)：[Github](https://github.com/tombenner/NUIParse)

### Ono

[Github](https://github.com/mattt/Ono)

* libxml2.tbd

### PINCache

[Github](https://github.com/pinterest/PINCache)

### Reachability

[Github](https://github.com/tonymillion/Reachability)

* SystemConfiguration.framework

### ReflectionView

[Github](https://github.com/nicklockwood/ReflectionView)

* QuartzCore.framework

### REFrostedViewController

[Github](https://github.com/romaonthego/REFrostedViewController)

* Accelerate.framework 

### RestKit

[Github](https://github.com/RestKit/RestKit)

* CFNetwork.framework
* SystemConfiguration.framework
* MobileCoreServices.framework
* CoreData.framework
* Security.framework  
* QuartzCore.framework
* libxml2.dylib

编译
> Other Linker Flags增加选项: -ObjC

### SDWebImage

[Github](https://github.com/rs/SDWebImage)

* ImageIO.framework

### SKDropDown

框架类库

* QuartzCore.framework

### SpringBoardButton

框架类库

### TAPageControl

[Github](https://github.com/TanguyAladenise/TAPageControl)

### TCBlobDownload

[Github](https://github.com/thibaultCha/TCBlobDownload)

### TPKeyboardAvoiding

[Github](https://github.com/michaeltyson/TPKeyboardAvoiding)

### TSMessages

[Github](https://github.com/KrauseFx/TSMessages)

### UMSocialSdk

[URL](http://dev.umeng.com/social/ios/quick-integration)

* libstdc++.tbd
* libz.tbd
* libiconv.tbd
* libsqlite3.tbd
* SystemConfiguration.framework
* Security.framework
* CoreGraphics.framework
* CoreTelephony.framework

配置
> 需要配置URL Schemes如下

	新浪微博：“wb”+新浪appkey，例如“wb126663232”
	微信：微信应用appId，例如“wxd9a39c7122aa6516”
	QQ: “QQ”+腾讯QQ互联应用appId转换成十六进制（不足8位前面补0），例如“QQ05FC5B14”
	Qzone：“tencent“+腾讯QQ互联应用Id，例如“tencent100424468"

iOS9

	<key>NSAppTransportSecurity</key>
	<dict>
    	<key>NSAllowsArbitraryLoads</key>
    	<true/>
	</dict>
	
	<key>LSApplicationQueriesSchemes</key>
	<array>
	    <!-- 微信 URL Scheme 白名单-->
	    <string>wechat</string>
	    <string>weixin</string>

	    <!-- 新浪微博 URL Scheme 白名单-->
	    <string>sinaweibohd</string>
	    <string>sinaweibo</string>
	    <string>sinaweibosso</string>
	    <string>weibosdk</string>
	    <string>weibosdk2.5</string>

	    <!-- QQ、Qzone URL Scheme 白名单-->
	    <string>mqqapi</string>
	    <string>mqq</string>
	    <string>mqqOpensdkSSoLogin</string>
	    <string>mqqconnect</string>
	    <string>mqqopensdkdataline</string>
	    <string>mqqopensdkgrouptribeshare</string>
	    <string>mqqopensdkfriend</string>
	    <string>mqqopensdkapi</string>
	    <string>mqqopensdkapiV2</string>
	    <string>mqqopensdkapiV3</string>
	    <string>mqzoneopensdk</string>
	    <string>wtloginmqq</string>
	    <string>wtloginmqq2</string>
	    <string>mqqwpa</string>
	    <string>mqzone</string>
	    <string>mqzonev2</string>
	    <string>mqzoneshare</string>
	    <string>wtloginqzone</string>
	    <string>mqzonewx</string>
	    <string>mqzoneopensdkapiV2</string>
	    <string>mqzoneopensdkapi19</string>
	    <string>mqzoneopensdkapi</string>
	    <string>mqqbrowser</string>
	    <string>mttbrowser</string>

	    <!-- 人人 URL Scheme 白名单-->
	    <string>renrenios</string>
	    <string>renrenapi</string>
	    <string>renren</string>
	    <string>renreniphone</string>

	    <!-- 来往 URL Scheme 白名单-->
	    <string>laiwangsso</string>

	    <!-- 易信 URL Scheme 白名单-->
	    <string>yixin</string>
	    <string>yixinopenapi</string>

	    <!-- instagram URL Scheme 白名单-->
	    <string>instagram</string>

	    <!-- whatsapp URL Scheme 白名单-->
	    <string>whatsapp</string>

	    <!-- line URL Scheme 白名单-->
	    <string>line</string>

	    <!-- Facebook URL Scheme 白名单-->
	    <string>fbapi</string>
	    <string>fb-messenger-api</string>
	    <string>fbauth2</string>
	    <string>fbshareextension</string>
	</array>

### WechatSDK

[URL](https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=8_1)

配置
> 需要配置URL Schemes为微信应用appId，如：wxd9a39c7122aa6516

* libstdc++.tbd
* libz.tbd
* libiconv.tbd
* libsqlite3.tbd
* SystemConfiguration.framework
* Security.framework
* CoreGraphics.framework
* CoreTelephony.framework

iOS9

	<key>NSAppTransportSecurity</key>
	<dict>
    	<key>NSAllowsArbitraryLoads</key>
    	<true/>
	</dict>
	
	<key>LSApplicationQueriesSchemes</key>
	<array>
	    <!-- 微信 URL Scheme 白名单-->
	    <string>wechat</string>
	    <string>weixin</string>
	</array>

### XAspect

[Github](https://github.com/xareelee/XAspect)

### XMLDictionary

[Github](https://github.com/nicklockwood/XMLDictionary)

### ZBarSDK

[Github](https://github.com/bmorton/ZBarSDK)

* libiconv.tbd
* AVFoundation.framework
* CoreMedia.framework
* CoreVideo.framework
* QuartzCore.framework 

### ZCTradeView

[Github](https://github.com/rayshen/ZCTradeView)
