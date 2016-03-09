//
//  Framework.h
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef Framework_h
#define Framework_h

//config
#import "FWConfig.h"
#import "FWDefine.h"
#import "FWCompile.h"
#import "FWSingleton.h"
#import "FWProperty.h"

//extension
#import "NSObject+Framework.h"
#import "NSString+Framework.h"
#import "NSDate+Framework.h"
#import "UIColor+Framework.h"
#import "UIImage+Framework.h"
#import "UIView+Framework.h"
#import "UIImageView+Framework.h"
#import "UITextView+Framework.h"
#import "UIScrollView+Framework.h"
#import "UIViewController+Framework.h"
#import "UINavigationController+Framework.h"

//core
#import "FWContext.h"
#import "FWLog.h"
#import "FWDebug.h"
#import "FWTest.h"
#import "FWScreen.h"
#import "FWLocale.h"
#import "FWRegistry.h"
#import "FWStorage.h"
#import "FWDatabase.h"
#import "FWHandler.h"
#import "FWNotification.h"
#import "FWSignal.h"
#import "FWRuntime.h"
#import "FWCache.h"
#import "FWCacheFile.h"
#import "FWTheme.h"
#import "FWEntity.h"
#import "FWPresenter.h"
#import "FWRouter.h"
#import "FWService.h"
#import "FWTask.h"
#import "FWPlugin.h"

#import "FWRequest.h"
#import "FWResponse.h"

#import "FWModel.h"
#import "FWViewModel.h"

#import "FWWidget.h"
#import "FWView.h"
#import "FWXmlView.h"

#import "FWViewController.h"
#import "FWXmlViewController.h"

//library
#import "FWPluginDialog.h"
#import "FWPluginDialogImpl.h"
#import "FWPluginLoading.h"
#import "FWPluginLoadingImpl.h"

#import "FWHelperAspect.h"
#import "FWHelperDevice.h"
#import "FWHelperNetwork.h"
#import "FWHelperSystem.h"
#import "FWHelperPath.h"
#import "FWHelperTimer.h"
#import "FWHelperLocation.h"
#import "FWHelperEncoder.h"
#import "FWHelperHttp.h"

#endif
