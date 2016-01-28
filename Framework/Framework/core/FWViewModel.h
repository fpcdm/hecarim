//
//  FWViewModel.h
//  Framework
//
//  Created by wuyong on 16/1/28.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//ViewController作为View层，View和Model无联系
@interface FWViewModel : NSObject

//View持有ViewModel，ViewModel不知道View的任何事情
//ViewModel持有并更新Model，不知道View的任何事情
//ViewModel是UI控件及控件的状态

//ViewModel.model
//ViewController.viewModel
//ViewModel.testVar
//ViewModel.testVarDidChange
//ViewModel.showVar()

//视图中调用ViewModel.showVar
//ViewController设置ViewModel.testVarDidChange为更新视图

@end
