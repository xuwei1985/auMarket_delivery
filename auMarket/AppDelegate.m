//
//  AppDelegate.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/7.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (UINavigationController *)getNavigationController {
    return [[APP_DELEGATE booter] navigationController];
}

+ (UITabBarController *)getTabbarController {
    return [[APP_DELEGATE booter] tabBarController];
}

-(void)bootMainVc
{
    [self.window setRootViewController:[self.booter bootUIViewController]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.booter = [[Booter alloc] init];
    [self.booter bootReachability];
    [self.booter bootGoogleMap];
    [self.booter loadTaskList];
    [self.booter loadParkingList];
//    [self.booter bootJPush:launchOptions];
//    [self.booter bootUMeng];
    
    // 当前版本第一次启动开启引导页
//    NSString* introVer = [USER_DEFAULT stringForKey:APP_INTRO_VER];
//    if (!introVer || ![[SPBaseModel getAppVer] isEqualToString:introVer]) {//显示介绍页
//        [[NSUserDefaults standardUserDefaults]  setObject:[SPBaseModel getAppVer] forKey:APP_INTRO_VER];
//        [[NSUserDefaults standardUserDefaults]  synchronize];
//        [self.window setRootViewController:[self.booter getIntroViewController]];
//    }
//    else{//显示正常的页面
//        [self.window setRootViewController:[self.booter bootUIViewController]];
//    }
//
    SPNavigationController *navController = [[SPNavigationController alloc] initWithRootViewController:[[UserLoginViewController alloc] init]];
    [self.window setRootViewController:navController];
    [self initLocation];
    
    //启动的弹出界面
//    UIViewController *startPageViewController = [self.booter bootStartPage];
//    if (startPageViewController) {
//        [self.window.rootViewController presentViewController:startPageViewController animated:NO completion:nil];
//    }
    
    self.window.backgroundColor=COLOR_WHITE;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)logObj:(id)sender{
    NSLog(@"%@",sender);
}

-(void)initLocation{
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置距离筛选器,表示设备至少移动n米,才通知委托更新
    _locationManager.distanceFilter = 5;
    //设置iOS设备是否可暂停定位来节省电池的电量
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    // 这句话ios8以上版本使用。
    if([[[UIDevice currentDevice] systemVersion]floatValue] >=8) {
        [_locationManager requestAlwaysAuthorization];
    }
    if([[[UIDevice currentDevice] systemVersion]floatValue] >=9) {
        _locationManager.allowsBackgroundLocationUpdates=YES;
    }
    
    // 开始定位
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //获取经度
    CLLocationCoordinate2D coordinate=  newLocation.coordinate;
    [self.booter postLocation:coordinate];
    NSLog(@"%lf %lf", coordinate.latitude, coordinate.longitude) ;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DID_ENTER_BACKGROUND object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_WILL_ENTER_FOREGROUND object:nil];
    [self.booter loadTaskList];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL bRet = [self.booter onHandleOpenURL:url];
    return bRet;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL bRet = [self.booter onHandleOpenURL:url];
    return bRet;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //跳转处理支付结果
    BOOL bRet = [self.booter onHandleOpenURL:url];
    return bRet;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"My token is:%@", deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //[JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    [self.booter handleRemoteNotifacation:userInfo];
}

@end
