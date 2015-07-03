//
//  AddressDetailViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "AddressDetailView.h"
#import "AddressFormViewController.h"
#import "UserHandler.h"

@interface AddressDetailViewController () <AddressDetailViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@end

@implementation AddressDetailViewController
{
    AddressDetailView *addressDetailView;
}

@synthesize address;

- (void)loadView
{
    addressDetailView = [[AddressDetailView alloc] init];
    addressDetailView.delegate = self;
    self.view = addressDetailView;
}

- (void)viewDidLoad {
    hasNavBack = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的地址";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonSystemItem:UIBarButtonSystemItemEdit];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionEdit);
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //加载地址数据
    AddressEntity *requestAddress = [[AddressEntity alloc] init];
    requestAddress.id = self.address.id;
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler queryAddress:requestAddress success:^(NSArray *result){
        AddressEntity *resultAddress = [result firstObject];
        self.address = resultAddress;
        
        [addressDetailView setData:@"address" value:self.address];
        [addressDetailView renderData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

#pragma mark - Sheet
//弹出sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        //删除
        case 1:
        {
            if (buttonIndex == 1) return;
            
            UserHandler *userHandler = [[UserHandler alloc] init];
            [userHandler deleteAddress:[address copy] success:^(NSArray *result){
                //回调父级
                if (self.deleteBlock) {
                    self.deleteBlock(self.address);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(ErrorEntity *error){
                [self showError:error.message];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action
//删除地址
- (void) actionDelete
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    sheet = [sheet initWithTitle:@"确定删除吗" delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    
    sheet.tag = 1;
    [sheet showInView:self.view];
}

//设为默认地址
- (void) actionDefault
{
    AddressEntity *requestAddress = [address copy];
    requestAddress.isDefault = @1;
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler setDefaultAddress:requestAddress success:^(NSArray *result){
        //回调父级
        self.address.isDefault = @1;
        if (self.defaultBlock) {
            self.defaultBlock(self.address);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//编辑页面
- (void) actionEdit
{
    AddressFormViewController *viewController = [[AddressFormViewController alloc] init];
    
    //拷贝对象
    viewController.address = [address copy];
    //添加回调
    viewController.callbackBlock = ^(id object){
        self.address = (AddressEntity *) object;
        
        [addressDetailView setData:@"address" value:self.address];
        [addressDetailView renderData];
        
        //更新父级视图
        if (self.callbackBlock) {
            self.callbackBlock(self.address);
        }
    };
    
    [self pushViewController:viewController animated:YES];
}

@end
