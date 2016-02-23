//
//  LttFramework.m
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "LttFramework.h"

/**************************/
@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHex:color];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    return [self colorWithHex:color alpha:alpha];
}

@end

/**************************/
@implementation NSString (Trim)

+ (NSString *)trim:(NSString *)str
{
    return str ? [str trim] : str;
}

@end

/**************************/
static StorageUtil *sharedStorage = nil;

@implementation StorageUtil
{
    NSUserDefaults *storage;
}

+ (StorageUtil *) sharedStorage
{
    //多线程唯一
    @synchronized(self){
        if (!sharedStorage) {
            sharedStorage = [[self alloc] init];
        }
    }
    return sharedStorage;
}

- (id) init
{
    self = [super init];
    if (self) {
        storage = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (NSUserDefaults *) storage
{
    return storage;
}

//整理字典数据，去掉NSNull和nil，使其可以保存至NSUserDefaults
- (NSDictionary *) prepareDictionary: (NSDictionary *) dictionary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    
    if (dictionary) {
        for (id key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (value != nil && value != [NSNull null]) {
                [mutableDictionary setObject:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

- (void) setUser: (UserEntity *) user
{
    if (user) {
        //解决NSUserDefaults不能存储nsnull和nil的问题
        NSDictionary *userDict = [user toDictionary];
        userDict = [self prepareDictionary:userDict];
        
        [storage setObject:userDict forKey:@"user"];
        [storage synchronize];
        
        NSLog(@"set user: %@", userDict);
    } else {
        [storage removeObjectForKey:@"user"];
        [storage synchronize];
        
        NSLog(@"delete user: %@", user);
    }
}

- (UserEntity *) getUser
{
    NSDictionary *userDict = (NSDictionary *) [storage objectForKey:@"user"];
    if (!userDict) {
        return nil;
    }
    
    UserEntity *user = [[UserEntity alloc] init];
    [user fromDictionary:userDict];
    
    NSLog(@"get user: %@", [user toDictionary]);
    return user;
}

- (void) setRemoteNotification:(NSDictionary *)notification
{
    if (notification) {
        [self.storage setObject:notification forKey:@"remote_notification"];
        [self.storage synchronize];
        
        NSLog(@"set remote notification: %@", notification);
    } else {
        [self.storage removeObjectForKey:@"remote_notification"];
        [self.storage synchronize];
        
        NSLog(@"delete remote notification");
    }
}

- (NSDictionary *) getRemoteNotification
{
    NSDictionary *notification = (NSDictionary *) [self.storage objectForKey:@"remote_notification"];
    if (!notification) {
        return nil;
    }
    
    NSLog(@"get remote notification: %@", notification);
    return notification;
}

- (void) setDeviceId:(NSString *)deviceId
{
    if (deviceId) {
        [self.storage setObject:deviceId forKey:@"device_id"];
        [self.storage synchronize];
        
        NSLog(@"set device_id: %@", deviceId);
    } else {
        [self.storage removeObjectForKey:@"device_id"];
        [self.storage synchronize];
        
        NSLog(@"delete device_id");
    }
}

- (NSString *) getDeviceId
{
    NSString *deviceId = (NSString *) [self.storage objectForKey:@"device_id"];
    if (!deviceId) {
        return nil;
    }
    
    NSLog(@"get device_id: %@", deviceId);
    return deviceId;
}

- (void)setData:(NSString *)key object:(id)object
{
    if (object) {
        [self.storage setObject:object forKey:key];
        [self.storage synchronize];
        
        NSLog(@"set %@: %@", key, object);
    } else {
        [self.storage removeObjectForKey:key];
        [self.storage synchronize];
        
        NSLog(@"delete %@", key);
    }
}

- (id)getData:(NSString *)key
{
    id object = [self.storage objectForKey:key];
    if (!object) {
        return nil;
    }
    
    NSLog(@"get %@: %@", key, object);
    return object;
}

@end

/*******************************/
@implementation UIViewController (Dialog)

- (void) showError: (NSString *) message
{
    [self showError:message callback:nil];
}

- (void) showWarning:(NSString *) message
{
    [self showWarning:message callback:nil];
}

- (void) showMessage:(NSString *) message
{
    [self showMessage:message callback:nil];
}

- (void) showSuccess: (NSString *) message
{
    [self showSuccess:message callback:nil];
}

- (void) showNotification:(NSString *)message callback:(void (^)())callback
{
    [self showButton:message title:@" 查 看 " callback:callback];
}

- (void) loadingSuccess: (NSString *) message
{
    [self finishLoading:message callback:nil];
}

- (void) loadingSuccess:(NSString *)message callback:(void (^)())callback
{
    [self finishLoading:message callback:callback];
}

@end

/*************************************/
@implementation UIViewController (BackButtonHandler)

- (BOOL)shouldNavigationBarPopItem
{
    BOOL shouldPop = YES;
    if([self respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [self navigationShouldPopOnBackButton];
    }
    return shouldPop;
}

@end

/*************************************/
@implementation ValidateUtil

+ (BOOL) isRequired: (NSString *) value
{
    return value != nil && [[value trim] length] > 0;
}

+ (BOOL) isLength: (NSString *) value length: (NSInteger) length;
{
    NSInteger len = (value == nil) ? 0 : [value length];
    return len == length;
}

+ (BOOL) isMobile: (NSString *) value
{
    return [value isFormatMobile];
}

+ (BOOL) isLengthBetween: (NSString *) value from: (NSInteger) from to: (NSInteger) to;
{
    NSInteger len = (value == nil) ? 0 : [value length];
    return len >= from && len <= to;
}

+ (BOOL) isPositiveInteger:(NSString *)value
{
    return [value isFormatInteger] && [value integerValue] > 0;
}

+ (BOOL) isPositiveNumber:(NSString *)value
{
    return [value isFormatNumber] && [value floatValue] > 0;
}

@end

/********************************/
@implementation FWHelperTimer (Interval)

+ (NSTimeInterval) timeInterval: (NSDate *) time
{
    return time ? [[NSDate date] timeIntervalSinceDate:time] : 0;
}

+ (void) test
{
    //声明静态，防止ARC自动释放，也可以放在类变量
    //不声明静态只会执行一次
    static TimerUtil *timer;
    __block int n = 0;
    timer = [TimerUtil repeatTimer:5 block:^(void){
        n++;
        NSLog(@"Hello");
        if (n == 5) {
            NSLog(@"Finish");
            [timer invalidate];
        }
    }];
}

@end

/*********************************/
static LocationUtil *sharedInstance = nil;

@interface LocationUtil () <CLLocationManagerDelegate>

@end

@implementation LocationUtil
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D position;
}

+ (double)getDistance:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to
{
    //比[clLocation1 distanceFromLocation:clLocation2]精确
    double radLat1 = from.latitude * M_PI / 180.0;
    double radLat2 = to.latitude * M_PI / 180.0;
    double a = radLat1 - radLat2;
    double b = from.longitude * M_PI / 180.0 - to.longitude * M_PI / 180.0;
    
    double s = 2 * sin(sqrt(pow(sin(a / 2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    s = s * 6378137;
    s = round(s * 100) / 100;
    return s;
}

+ (LocationUtil *) sharedInstance
{
    //多线程唯一
    @synchronized(self){
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self) {
        //初始化坐标为0
        position = CLLocationCoordinate2DMake(0, 0);
        
        //初始化GPS
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10;
        locationManager.delegate = self;
        if (IS_IOS8_PLUS) {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (CLLocationManager *) locationManager
{
    return locationManager;
}

- (CLLocationCoordinate2D) position
{
    return position;
}

- (void) startUpdate
{
    [locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

- (void) stopUpdate
{
    [locationManager stopUpdatingLocation];
    NSLog(@"stop gps");
}

- (void) restartUpdate
{
    [locationManager stopUpdatingLocation];
    [locationManager startUpdatingLocation];
    NSLog(@"restart gps");
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //更新位置
    position = [newLocation coordinate];
    
    NSLog(@"gps success: 经度: %lf 纬度: %lf", position.longitude, position.latitude);
    
    //调用代理
    if (self.delegate) {
        [self.delegate updateLocationSuccess:position];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSString *errorMsg = ([error code] == kCLErrorDenied) ? @"访问被拒绝" : @"获取地理位置失败";
    NSLog(@"gps error:%@", errorMsg);
    
    //调用代理
    if (self.delegate) {
        [self.delegate updateLocationError:error];
    }
}

@end

/**************************************/
#import <AudioToolbox/AudioToolbox.h>

@implementation NotificationUtil

// 注册通知
+ (void) registerLocalNotification:(NSString *)userInfoKey alertBody:(NSString *)alertBody time:(NSInteger)time
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //设置通知时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
    notification.fireDate = fireDate;
    
    //时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    //重复间隔
    notification.repeatInterval = 0;
    
    //通知内容
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber += 1;
    
    //声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    //通知参数
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:alertBody forKey:userInfoKey];
    notification.userInfo = userInfo;
    
    //兼容iOS8，需要添加此注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    //执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 本地通知回调函数，应用程序在前台时调用
+ (void) receiveLocalNotification: (UILocalNotification *) notification
{
    //取消本地通知
    [self cancelLocalNotifications];
}

// 取消所有本地通知
+ (void) cancelLocalNotifications
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// 收到远程消息
+ (void) receiveRemoteNotification:(NSDictionary *)userInfo
{
    // 整理并保存数据
    userInfo = [[StorageUtil sharedStorage] prepareDictionary:userInfo];
    [[StorageUtil sharedStorage] setRemoteNotification:userInfo];
    
    // 检测声音文件
    NSString *soundName = nil;
    if (userInfo) {
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        if (aps) soundName = [aps objectForKey:@"sound"];
    }
    
    // 文件是否存在
    NSString *soundFile = nil;
    if (soundName && ![@"default" isEqualToString:soundName]) {
        soundFile = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
        if (soundFile && ![[NSFileManager defaultManager] fileExistsAtPath:soundFile]) {
            soundFile = nil;
        }
    }
    
    // 播放内置声音
    if (soundFile) {
        NSURL *soundUrl = [NSURL fileURLWithPath:soundFile];
        SystemSoundID soundId = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundId);
        AudioServicesPlaySystemSound(soundId);
        // 播放系统声音
    } else {
        AudioServicesPlaySystemSound(1007);
    }
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

// 取消所有远程消息
+ (void) cancelRemoteNotifications
{
    // 清除数据
    [[StorageUtil sharedStorage] setRemoteNotification:nil];
    
    // 清空计数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


@end

/**************************************/
@implementation PickerUtilRow

@synthesize name;
@synthesize value;

+ (instancetype) rowWithName:(NSString *)name value:(id)value
{
    return [[self alloc] initWithName:name value:value];
}

- (instancetype) initWithName:(NSString *)initName value:(id)initValue
{
    self = [super init];
    
    if (self) {
        self.name = initName;
        self.value = initValue;
    }
    
    return self;
}

@end

@implementation PickerUtil
{
    NSArray *firstRows;
    NSArray *secondRows;
    NSArray *thirdRows;
    
    NSArray *selectedRows;
}

- (instancetype) init
{
    return [self initWithTitle:nil grade:1 origin:nil];
}

- (instancetype) initWithTitle:(NSString *)title grade:(NSUInteger)grade origin:(id)origin
{
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.grade = grade;
    self.origin = origin;
    
    firstRows = @[];
    secondRows = @[];
    thirdRows = @[];
    
    selectedRows = @[];
    
    return self;
}

- (void) show
{
    [self loadFirst:^{
        [ActionSheetCustomPicker showPickerWithTitle:self.title delegate:self showCancelButton:YES origin:self.origin];
    }];
}

- (void) loadFirst: (void (^)()) callback
{
    self.firstLoadBlock(@[], ^(NSArray *rows){
        firstRows = rows ? rows : @[];
        
        if ([firstRows count] > 0) {
            selectedRows = @[
                             [firstRows objectAtIndex:0]
                             ];
        }
        
        if (self.grade > 1 && [firstRows count] > 0) {
            [self loadSecond:callback];
        } else {
            callback();
        }
    });
}

- (void) loadSecond: (void (^)()) callback;
{
    self.secondLoadBlock(selectedRows, ^(NSArray *rows){
        secondRows = rows ? rows : @[];
        
        if ([secondRows count] > 0) {
            selectedRows = @[
                             [selectedRows objectAtIndex:0],
                             [secondRows objectAtIndex:0]
                             ];
        }
        
        if (self.grade > 2 && [secondRows count] > 0) {
            [self loadThird:callback];
        } else {
            callback();
        }
    });
    
}

- (void) loadThird: (void (^)()) callback
{
    self.thirdLoadBlock(selectedRows, ^(NSArray *rows){
        thirdRows = rows ? rows : @[];
        
        if ([thirdRows count] > 0) {
            selectedRows = @[
                             [selectedRows objectAtIndex:0],
                             [selectedRows objectAtIndex:1],
                             [thirdRows objectAtIndex:0]
                             ];
        }
        
        callback();
    });
}

#pragma mark - ActionSheetCustomPickerDelegate
- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    //全部选择完成才回调
    if (selectedRows && [selectedRows count] == self.grade) {
        self.resultBlock(selectedRows);
    }
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.grade;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0: return [firstRows count];
        case 1: return [secondRows count];
        case 2: return [thirdRows count];
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.frame.size.width / self.grade;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PickerUtilRow *data = nil;
    switch (component) {
        case 0:
        {
            if ([firstRows count] > row) {
                data = [firstRows objectAtIndex:row];
                return data.name;
                break;
            }
        }
            break;
        case 1:
        {
            if ([secondRows count] > row) {
                data = [secondRows objectAtIndex:row];
                return data.name;
                break;
            }
        }
            break;
        case 2:
        {
            if ([thirdRows count] > row) {
                data = [thirdRows objectAtIndex:row];
                return data.name;
                break;
            }
        }
            break;
        default:
            return  nil;
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            //获取选中
            if ([firstRows count] > row) {
                selectedRows = @[
                                 [firstRows objectAtIndex:row]
                                 ];
                
                //选中了才加载，下同
                if (self.grade > 1) {
                    [self loadSecond:^{
                        [pickerView selectRow:0 inComponent:1 animated:YES];
                        [pickerView reloadComponent:1];
                        
                        if (self.grade > 2) {
                            [pickerView selectRow:0 inComponent:2 animated:YES];
                            [pickerView reloadComponent:2];
                        }
                    }];
                }
            }
        }
            break;
        case 1:
        {
            //获取选中
            if ([secondRows count] > row) {
                selectedRows = @[
                                 [selectedRows objectAtIndex:0],
                                 [secondRows objectAtIndex:row]
                                 ];
                
                //选中了才加载
                if (self.grade > 2) {
                    [self loadThird:^{
                        [pickerView selectRow:0 inComponent:2 animated:YES];
                        [pickerView reloadComponent:2];
                    }];
                }
            }
        }
            break;
        case 2:
        {
            //获取选中
            if ([thirdRows count] > row) {
                selectedRows = @[
                                 [selectedRows objectAtIndex:0],
                                 [selectedRows objectAtIndex:1],
                                 [thirdRows objectAtIndex:row]
                                 ];
            }
        }
            break;
        default:
            break;
    }
}

@end

/*********************************/
#import "UserEntity.h"

static RestKitUtil *sharedClient = nil;

@implementation RestKitUtil
{
    RKObjectManager *manager;
    NSString *client;
    NSString *city;
}

#pragma mark - Static Methods
+ (RestKitUtil *) sharedClient
{
    //多线程唯一
    @synchronized(self){
        if (!sharedClient) {
            sharedClient = [[self alloc] init];
        }
    }
    return sharedClient;
}

- (id) init
{
    self = [super init];
    if (self) {
        manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:APP_REST_SERVER]];
    }
    return self;
}

#pragma mark - Public Methods
- (void) setBaseUrl:(NSURL *)baseUrl
{
    manager = [RKObjectManager managerWithBaseURL:baseUrl];
}

- (void) setClientType:(NSString *)clientType;
{
    client = clientType;
}

- (void) setCityCode:(NSString *)cityCode
{
    city = cityCode;
}

- (NSString *) formatPath: (NSString *) path  object: (id) object
{
    NSString *resultPath = RKPathFromPatternWithObject(path, object);
    return resultPath;
}

- (RKRequestDescriptor *) addRequestDescriptor: (Class) objectClass mappingParam: (id) param
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    if ([param isKindOfClass:[NSDictionary class]]) {
        [requestMapping addAttributeMappingsFromDictionary:param];
    } else {
        [requestMapping addAttributeMappingsFromArray:param];
    }
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:objectClass
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodAny];
    [manager addRequestDescriptor:requestDescriptor];
    
    return requestDescriptor;
}

- (void) removeRequestDescriptor:(RKRequestDescriptor *)requestDescriptor
{
    [manager removeRequestDescriptor:requestDescriptor];
}

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param
{
    return [self addResponseDescriptor:objectClass mappingParam:param keyPath:nil];
}

- (RKResponseDescriptor *) addResponseDescriptor: (Class) objectClass mappingParam: (id) param keyPath: (NSString *) keyPath
{
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:objectClass];
    if ([param isKindOfClass:[NSDictionary class]]) {
        [responseMapping addAttributeMappingsFromDictionary:param];
    } else {
        [responseMapping addAttributeMappingsFromArray:param];
    }
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:keyPath
                                                                                       statusCodes:[NSIndexSet indexSetWithIndex:RKStatusCodeClassSuccessful]];
    [manager addResponseDescriptor:responseDescriptor];
    
    return responseDescriptor;
}

- (void) removeResponseDescriptor:(RKResponseDescriptor *)responseDescriptor
{
    [manager removeResponseDescriptor:responseDescriptor];
}

#pragma mark - REST Methods
- (void) putObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/put"];
    
    [self addHeader];
    [manager putObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) deleteObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/delete"];
    
    //手工合并参数，解决RestKit不合并object参数问题
    param = [self mergeObject:object withParam:param];
    
    [self addHeader];
    [manager deleteObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) getObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/get"];
    
    //手工合并参数，解决RestKit不合并object参数问题
    param = [self mergeObject:object withParam:param];
    
    [self addHeader];
    [manager getObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) postObject: (id) object path: (NSString *) path param: (NSDictionary *) param success: (void (^)(NSArray *result)) success failure: (void (^)(ErrorEntity *error)) failure
{
    path = [self fixPath:path with:@"/post"];
    
    [self addHeader];
    [manager postObject:object path:path parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *result){
        [self success:operation result:result callback:success];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self failure:operation error:error callback:failure];
    }];
}

- (void) postFile:(FileEntity *)file path:(NSString *)path param:(NSDictionary *)param success:(RestKitSuccessBlock)success failure:(RestKitErrorBlock)failure
{
    path = [self fixPath:path with:@"/post"];
    
    [self addHeader];
    NSMutableURLRequest *request = [manager multipartFormRequestWithObject:file
                                                                    method:RKRequestMethodPOST
                                                                      path:path
                                                                parameters:param
                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                     [formData appendPartWithFileData:file.data
                                                                                 name:file.field
                                                                             fileName:file.name
                                                                             mimeType:file.mime];
                                                 }];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
                                                                             success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                                                                 [self success:operation result:result callback:success];
                                                                             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                                 [self failure:operation error:error callback:failure];
                                                                             }];
    
    [manager enqueueObjectRequestOperation:operation];
}

#pragma mark - Private Methods
//手工合并参数，解决RestKit使用GET和DELETE时不会自动合并参数，导致参数传递不过去的问题
- (NSDictionary *) mergeObject: (id) object withParam: (NSDictionary *) param
{
    NSMutableDictionary *dictParam = [NSMutableDictionary new];
    //只支持BaseEntity
    if (object && [object isKindOfClass:[BaseEntity class]]) {
        [dictParam setDictionary:[(BaseEntity*) object toDictionary]];
    }
    if (param) {
        [dictParam addEntriesFromDictionary:param];
    }
    
    return dictParam;
}

- (NSString *) fixPath: (NSString *) path with: (NSString *) fix
{
    if (APP_REST_RAP) {
        path = [path stringByAppendingString:fix];
    }
    return path;
}

//添加token和user_type
- (void) addHeader
{
    //客户端类型
    [manager.HTTPClient setDefaultHeader:@"Client" value:client];
    
    //城市编码
    if (city) {
        [manager.HTTPClient setDefaultHeader:@"City-Code" value:city];
    }
    
    //获取token
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        [manager.HTTPClient setDefaultHeader:@"Token" value:user.token];
    }
}

- (void) success: (RKObjectRequestOperation *) operation result:(RKMappingResult *) result callback: (void (^)(NSArray *result)) callback
{
    NSArray *array = [result array];
    
    NSLog(@"success:%@", array);
    
    callback(array);
}

- (void) failure: (RKObjectRequestOperation *) operation error:(NSError *) error callback: (void (^)(ErrorEntity *error)) callback
{
    ErrorEntity *errorModel = [[ErrorEntity alloc] init];
    
    NSData *data = operation.HTTPRequestOperation.responseData;
    if (data == nil) {
        errorModel.code = ERROR_CODE_NETWORK;
        errorModel.message = [LocaleUtil system:@"ApiError.Network"];
    } else {
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if (json == nil) {
            errorModel.code = ERROR_CODE_JSON;
            errorModel.message = [LocaleUtil system:@"ApiError.Json"];
        } else {
            id error_code = [json valueForKey:@"error_code"];
            id error_msg = [json objectForKey:@"error"];
            errorModel.code = error_code ? [error_code integerValue] : ERROR_CODE_API;
            errorModel.message = error_msg ? (NSString *) error_msg : [LocaleUtil system:@"ApiError.Api"];
        }
    }
    
    NSLog(@"failure: %li %@", errorModel.code, errorModel.message);
    
    //全局错误钩子
    BOOL errorChain = YES;
    if (self.globalErrorBlock) {
        errorChain = self.globalErrorBlock(errorModel);
    }
    
    if (errorChain && callback) {
        callback(errorModel);
    }
}

@end
