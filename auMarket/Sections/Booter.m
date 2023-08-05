//
//  YPUIBooter.m
//  Youpin
//
//  Created by douj on 15/4/15.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "Booter.h"
#import "HomeViewController.h"
#import "UserCenterViewController.h"
#import "AdPageViewController.h"
#import "TaskListViewController.h"
#import "PickOrderViewController.h"
#import "PickFreezeOrderViewController.h"
#import "PickFoodOrderViewController.h"

@interface Booter() 
{
    HomeViewController* homeViewController;
    TaskListViewController* taskListViewController;
    PickOrderViewController* pickOrderViewController;
    UserCenterViewController* userCenterViewController;
    PickFreezeOrderViewController *pickFreezeOrderViewController;
    PickFoodOrderViewController *pickFoodOrderViewController;
}
@end

@implementation Booter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasNetWork=YES;
        [self checkIfLoginAccountIsValid];
        if (@available(iOS 15.0, *)) {
            [UITableView appearance].sectionHeaderTopPadding=0;
        } else {
            // Fallback on earlier versions
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountUpdate:) name:ACCOUNT_UPDATE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//引导页
-(UIViewController*)getIntroViewController
{
    return [[IntroViewController alloc] init];
}

//主视图控制器
-(UIViewController*)bootUIViewController
{
    homeViewController = [[HomeViewController alloc] init];
    homeViewController.hidesBottomBarWhenPushed = NO;
    homeViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"配送地图" image:[UIImage imageNamed:@"1_53"] selectedImage:[UIImage imageNamed:@"1_72"]];
    
    taskListViewController = [[TaskListViewController alloc] init];
    taskListViewController.hidesBottomBarWhenPushed = NO;
    taskListViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"配送列表" image:[UIImage imageNamed:@"1_56"] selectedImage:[UIImage imageNamed:@"1_65"]];
    
    userCenterViewController = [[UserCenterViewController alloc] init];
    userCenterViewController.hidesBottomBarWhenPushed = NO;
    userCenterViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"1_69"] selectedImage:[UIImage imageNamed:@"1_59"]];
    
    pickOrderViewController = [[PickOrderViewController alloc] init];
    pickOrderViewController.hidesBottomBarWhenPushed = NO;
    pickOrderViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"普通上货" image:[UIImage imageNamed:@"sh"] selectedImage:[UIImage imageNamed:@"sh_on"]];
    
    pickFreezeOrderViewController = [[PickFreezeOrderViewController alloc] init];
    pickFreezeOrderViewController.hidesBottomBarWhenPushed = NO;
    pickFreezeOrderViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"冷冻上货" image:[UIImage imageNamed:@"sssh"] selectedImage:[UIImage imageNamed:@"sssh_on"]];
    
    pickFoodOrderViewController = [[PickFoodOrderViewController alloc] init];
    pickFoodOrderViewController.hidesBottomBarWhenPushed = NO;
    pickFoodOrderViewController.tabBarItem = [[SPTabBarItem alloc] initWithTitle:@"熟食上货" image:[UIImage imageNamed:@"ssssh"] selectedImage:[UIImage imageNamed:@"ssssh_on"]];
    
    SPNavigationController *navHomeViewController = [[SPNavigationController alloc] initWithRootViewController:homeViewController];
    SPNavigationController *navTaskListViewController = [[SPNavigationController alloc] initWithRootViewController:taskListViewController];
    SPNavigationController *navUserCenterViewController = [[SPNavigationController alloc] initWithRootViewController:userCenterViewController];
    SPNavigationController *navPickViewController = [[SPNavigationController alloc] initWithRootViewController:pickOrderViewController];
    SPNavigationController *navPickFreezeViewController = [[SPNavigationController alloc] initWithRootViewController:pickFreezeOrderViewController];
    SPNavigationController *navPickFoodViewController = [[SPNavigationController alloc] initWithRootViewController:pickFoodOrderViewController];
  
    self.tabBarController = [[SPTabBarController alloc] init];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.tabBar.tintColor = COLOR_FONT_MAIN;
    [self.tabBarController setViewControllers:@[navHomeViewController,navTaskListViewController,navPickViewController,navPickFreezeViewController,navPickFoodViewController]];
    self.tabBarController.selectedIndex = 0;
    self.tabBarController.delegate = self;
    
    //设置tabBarItem的文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_FONT_GRAY,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_FONT_MAIN,NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    
    for (UINavigationController* navVc in self.tabBarController.viewControllers) {
        navVc.navigationBar.barTintColor = [UIColor whiteColor];
        navVc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:COLOR_FONT_BLACK,NSFontAttributeName:[UIFont systemFontOfSize:18]};
    }
    
    
    [BadgeManager sharedInstance].barItems = self.tabBarController.tabBar.items;
    return self.tabBarController;
}

//主视图控制器的代理事件
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSString *index = [NSString stringWithFormat:@"%d",(int)tabBarController.selectedIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCurrentTabNotification object:index];
    //[MobClick event:@"tab" attributes:@{@"category":index}];
}

- (void)pullMessageManagerDidReceiveMessage:(NSNotification*)aNotification{

    NSString *badgeValue = 0;//[SPPullMessageManager sharedInstance].messageCount;
    if ([badgeValue isEqualToString:@"0"]) {
        badgeValue = nil;
    }
    [[BadgeManager sharedInstance] setBadgeValue:badgeValue forIndex:3];
}

- (void)onAccountUpdate:(NSNotification*)aNotification{

    //[[SPPullMessageManager sharedInstance] resetPullMessager];
}

- (UIViewController *)bootStartPage {
    NSDictionary *startPages = [[YPSyncManager sharedInstance] getData:@"start_page"];
    NSArray *pages = [startPages objectForKey:@"pages"];
    if (![pages isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    AdPageViewController *startPageVC = nil;
    for (NSDictionary *startPage in pages) {
        long long startTime = [[startPage numberAtPath:@"start_time"] longLongValue];
        long long endTime = [[startPage numberAtPath:@"end_time"] longLongValue];
        long long currentTime = [[NSDate date] timeIntervalSince1970];
        NSString *imageUrl = [startPage stringAtPath:@"image_url"];
        NSURL *url = [NSURL URLWithString:imageUrl];
        BOOL isInCache = [[SDWebImageManager sharedManager] cachedImageExistsForURL:url];
        if (currentTime >= startTime && currentTime < endTime && isInCache) {
            UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
            startPageVC = [[AdPageViewController alloc] init];
            [startPageVC setImage:image];
        }
        if (!isInCache) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
            }];
        }
    }
    return nil;
}


-(void)bootGoogleMap{
    [GMSServices provideAPIKey:GOOGLE_APPKEY];
}

-(void)postLocation:(CLLocationCoordinate2D)coordinate {
    SPAccount *user=[[AccountManager sharedInstance] getCurrentUser];
    if(user.user_id.length>0){
        int now=[[Common getNowTimeTimestamp] intValue];
        if((now-last_location_update)>10){//最短10秒提交一次位置信息
            last_location_update=now;
            [self.model postLocation:coordinate andUserId:user.user_id];
        }
    }
}


//启动极光推送
-(void)bootJPush:(NSDictionary *)launchOptions{
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    #else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    #endif
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_KEY channel:JPUSH_CHANNEL apsForProduction:0];//0:开发1:线上
}



//启动网络监测
- (void)bootReachability{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                self.hasNetWork=YES;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                self.hasNetWork=NO;
                [SVProgressHUD showInfoWithStatus:@"当前网络不可用,请检查你的网络连接。"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                self.hasNetWork=YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                self.hasNetWork=YES;
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}

- (void)checkIfLoginAccountIsValid{
    SPAccount *acount = [[AccountManager sharedInstance] getCurrentUser];
    if (!acount.user_id || [acount.user_id isEmpty]) {
        [[AccountManager sharedInstance] unRegisterLoginUser];//注销用户
    }else{
        [[AccountManager sharedInstance] updateUserStatusIfNeeded];
    }
}


//远程消息的注册
-(void)registRemoteNotification{
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0"))
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

-(void)sync
{
    //同步sync接口
    [[YPSyncManager sharedInstance] load];
    //检查更新
    //[YPUpdateChecker sharedInstance];
}

//获取派送任务列表
-(void)loadTaskList
{
    [self.taskModel loadTaskList];
}

//获取线路
-(void)loadLineList
{
    [self.model getDataLines];
}

//获取停车位数据
-(void)loadParkingList
{
    [self.model loadParkingList];
}

- (BOOL)onHandleOpenURL:(NSURL *)url {
    return YES;
}

-(UINavigationController*)navigationController
{
    UINavigationController *nav = (UINavigationController*)self.tabBarController.selectedViewController;
    if ([nav.presentedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController*)nav.presentedViewController;
    }
   return nav;
}

-(void)onResponse:(SPBaseModel*)model isSuccess:(BOOL)isSuccess{
    if(model==self.taskModel){
        if(isSuccess){
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.tasklist_delivering= [self.taskModel getTasksByStatus:Delivery_Status_Delivering];
                self.tasklist_finished= [self.taskModel getTasksByStatus:Delivery_Status_Finished];
                self.tasklist_failed= [self.taskModel getTasksByStatus:Delivery_Status_Failed];
                self.tasklist_unknown= [self.taskModel getTasksByStatus:Delivery_Status_Unknow];
                self.sectionArr=[self.taskModel getSectionTimes];
            //});
        }
        else{
            self.tasklist_delivering= [[NSArray alloc] init];
            self.tasklist_finished= [[NSArray alloc] init];
            self.tasklist_failed= [[NSArray alloc] init];
        }
        [self.model getDataLines];
        [[NSNotificationCenter defaultCenter] postNotificationName:TASK_UPDATE_NOTIFICATION object:nil];
    }
//    else if(model==self.model&&self.model.requestTag==1002){
//        if(isSuccess){
//            self.parkinglist=self.model.parking_entity.list;
//        }
//        else{
//            self.parkinglist= [[NSArray alloc] init];
//        }
//    }
    else if(model==self.model&&self.model.requestTag==1001){
        if(isSuccess){
            if(self.model.entity!=nil&&self.model.entity.token.length>0){
                //if(APP_DELEGATE.isTokenRequestFaild){
                //    [APP_DELEGATE initTokenTimer:0];
                //}
                [APP_DELEGATE initTokenTimer:-1];
                APP_DELEGATE.isTokenRequestFaild=NO;
                APP_DELEGATE.token=self.model.entity.token;
            }
            else{
                //if(!APP_DELEGATE.isTokenRequestFaild){
                //    [APP_DELEGATE initTokenTimer:1];
                //}
                [APP_DELEGATE initTokenTimer:1];
                APP_DELEGATE.isTokenRequestFaild=YES;
            }
        }
        else{
            //if(!APP_DELEGATE.isTokenRequestFaild){
            //    [APP_DELEGATE initTokenTimer:1];
            //}
            [APP_DELEGATE initTokenTimer:1];
            APP_DELEGATE.isTokenRequestFaild=YES;
        }
    }
    else if(model==self.model&&self.model.requestTag==1004){
        if(isSuccess){
            self.lineEntity=self.model.lineEntity;
        }
        else{
            self.lineEntity = [[LineEntity alloc] init];
        }
    }
}


-(void)getToken{
    if(self.hasNetWork){
        if(APP_DELEGATE.token!=nil&&APP_DELEGATE.token.length>0){
            NSLog(@"================getTokenAsync===================");
            [self.model getTokenAsync];
        }
        else{
            NSLog(@"================getTokenSync===================");
            
            [self.model getTokenSync];
            
        }
    }
}

-(TaskModel *)taskModel{
    if(!_taskModel){
        _taskModel=[[TaskModel alloc] init];
        _taskModel.delegate=self;
    }
    return _taskModel;
}

-(MemberLoginModel *)loginModel{
    if(!_loginModel){
        _loginModel=[[MemberLoginModel alloc] init];
        _loginModel.delegate=self;
    }
    return _loginModel;
}

-(BooterModel *)model{
    if(!_model){
        _model=[[BooterModel alloc] init];
        _model.delegate=self;
    }
    return _model;
}

@end
